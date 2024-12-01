import 'package:flutter/material.dart';
import 'package:icomply/services/sqlite_service.dart';
import 'package:icomply/widgets/kanban_column.dart';
import 'package:icomply/screens/add_edit_card_screen.dart';

class KanbanViewScreen extends StatefulWidget {
  final SQLiteService sqliteService;

  const KanbanViewScreen({super.key, required this.sqliteService});

  @override
  State<KanbanViewScreen> createState() => _KanbanViewScreenState();
}

class _KanbanViewScreenState extends State<KanbanViewScreen> {
  final List<String> statuses = ['Backlog', 'Planned', 'Doing', 'Done'];
  Map<String, List<Map<String, dynamic>>> groupedCards = {};
  List<Map<String, dynamic>> allCards = []; // For filtering
  bool isLoading = true;
  String? errorMessage;

  // Filter state
  String selectedFilter = 'None';
  String? selectedFilterValue;
  List<String> filterValues = [];

  final List<String> filterOptions = ['None', 'Card Type', 'Assigned To', 'Parent'];

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  Future<void> _fetchCards() async {
    try {
      final cards = await widget.sqliteService.fetchCards();
      setState(() {
        allCards = cards;
        groupedCards = _groupCardsByStatus(cards);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to fetch cards. Please try again.";
        isLoading = false;
      });
    }
  }

  Map<String, List<Map<String, dynamic>>> _groupCardsByStatus(List<Map<String, dynamic>> cards) {
    final Map<String, List<Map<String, dynamic>>> grouped = {
      for (var status in statuses) status: [],
    };
    for (final card in cards) {
      final status = card['card_status'] ?? 'Backlog';
      grouped[status]?.add(card);
    }
    return grouped;
  }

  Future<void> _applyFilter() async {
    if (selectedFilter == 'None') {
      setState(() {
        groupedCards = _groupCardsByStatus(allCards);
      });
    } else if (selectedFilterValue != null) {
      List<Map<String, dynamic>> filteredCards = [];

      if (selectedFilter == 'Card Type') {
        filteredCards = allCards.where((card) => card['card_type'] == selectedFilterValue).toList();
      } else if (selectedFilter == 'Assigned To') {
        filteredCards = allCards.where((card) => card['assigned_to'] == selectedFilterValue).toList();
      } else if (selectedFilter == 'Parent') {
        filteredCards = allCards.where((card) => card['parent_card_id'] == selectedFilterValue).toList();
      }

      setState(() {
        groupedCards = _groupCardsByStatus(filteredCards);
      });
    }
  }

  Future<void> _updateFilterValues() async {
    if (selectedFilter == 'Card Type') {
      final types = allCards.map((card) => card['card_type']).toSet().cast<String>().toList();
      setState(() {
        filterValues = types;
      });
    } else if (selectedFilter == 'Assigned To') {
      final assignees = allCards
          .map((card) => card['assigned_to'] ?? 'Not Assigned')
          .toSet()
          .cast<String>()
          .toList();
      setState(() {
        filterValues = assignees;
      });
    } else if (selectedFilter == 'Parent') {
      final parents = allCards
          .where((card) => card['parent_card_id'] != null)
          .map((card) => card['title'] ?? 'Unnamed Parent')
          .toSet()
          .cast<String>()
          .toList();
      setState(() {
        filterValues = parents;
      });
    } else {
      setState(() {
        filterValues = [];
      });
    }
  }

  void _onCardMoved(Map<String, dynamic> card, String targetStatus) async {
    if (card['card_status'] != targetStatus) {
      await widget.sqliteService.updateCard(card['card_id'], {'card_status': targetStatus});
      _fetchCards(); // Refresh after moving
    }
  }

  Future<void> _addNewCard() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditCardScreen(
          sqliteService: widget.sqliteService,
        ),
      ),
    );
    _fetchCards();
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Text('Filter by: '),
          DropdownButton<String>(
            value: selectedFilter,
            items: filterOptions.map((filter) {
              return DropdownMenuItem(
                value: filter,
                child: Text(filter),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedFilter = value!;
                _updateFilterValues();
              });
            },
          ),
          if (selectedFilter != 'None') ...[
            const SizedBox(width: 16),
            DropdownButton<String>(
              value: selectedFilterValue,
              items: filterValues.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFilterValue = value;
                  _applyFilter();
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanban View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchCards,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: Row(
              children: statuses.map((status) {
                return KanbanColumn(
                  status: status,
                  cards: groupedCards[status] ?? [],
                  sqliteService: widget.sqliteService,
                  onCardMoved: (card) => _onCardMoved(card, status),

                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCard,
        child: const Icon(Icons.add),
      ),
    );
  }
}
