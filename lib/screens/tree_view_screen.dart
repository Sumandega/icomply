import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:icomply/services/sqlite_service.dart';
import 'add_edit_card_screen.dart';

class TreeViewScreen extends StatefulWidget {
  final SQLiteService sqliteService;

  const TreeViewScreen({super.key, required this.sqliteService});

  @override
  TreeViewScreenState createState() => TreeViewScreenState();
}

class TreeViewScreenState extends State<TreeViewScreen> {
  late TreeViewController _treeViewController;
  bool isLoading = true;
  List<Map<String, dynamic>> allCards = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _treeViewController = TreeViewController(children: []);
    _fetchTreeData();
  }

  Future<void> _fetchTreeData() async {
    try {
      final cards = await widget.sqliteService.fetchCards();
      setState(() {
        allCards = cards;
        _updateTreeView();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load data.";
        isLoading = false;
      });
      debugPrint('Error fetching tree data: $e');
    }
  }

  void _updateTreeView() {
    final Map<int, Node> nodeMap = {};

    for (var card in allCards) {
      nodeMap[card['card_id']] = Node(
        key: card['card_id'].toString(),
        label: card['title'] ?? 'Unnamed Card',
        children: [],
      );
    }

    final List<Node> rootNodes = [];
    for (var card in allCards) {
      final parentId = card['parent_card_id'];
      if (parentId == null) {
        rootNodes.add(nodeMap[card['card_id']]!);
      } else {
        nodeMap[parentId]?.children.add(nodeMap[card['card_id']]!);
      }
    }

    setState(() {
      _treeViewController = _treeViewController.copyWith(children: rootNodes);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tree View'),
      ),
      body: TreeView(
        controller: _treeViewController,
        allowParentSelect: false,
        supportParentDoubleTap: true,
        onNodeTap: (key) {
          final card = allCards.firstWhere((card) => card['card_id'].toString() == key);
          _openEditScreen(card);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCard,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewCard() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditCardScreen(sqliteService: widget.sqliteService),
      ),
    );
    if (mounted) _fetchTreeData();
  }

  void _openEditScreen(Map<String, dynamic> card) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddEditCardScreen(
        sqliteService: widget.sqliteService,
        cardData: card, // Updated to match the parameter in AddEditCardScreen
      ),
    ),
  );
  if (mounted) _fetchTreeData();
}
}
