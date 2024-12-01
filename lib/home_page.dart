import 'package:flutter/material.dart';
import 'package:icomply/services/sqlite_service.dart';
import 'package:icomply/screens/tree_view_screen.dart';
import 'package:icomply/screens/kanban_view_screen.dart';

class HomePage extends StatefulWidget {
  final SQLiteService sqliteService;

  const HomePage({super.key, required this.sqliteService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _currentScreen = Center(child: Text('Welcome to iComply!'));

  void _navigateTo(Widget screen) {
    setState(() {
      _currentScreen = KeyedSubtree(
        key: ValueKey(screen.hashCode), // Ensure a unique subtree key
        child: screen,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(
            child: _currentScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.blue[50],
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue,
            child: const Text(
              'iComply',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildExpandableMenu(
            title: 'Dashboard',
            subItems: [
              _buildSubMenuItem('Compliance Report', () {
                _navigateTo(Center(child: Text('Compliance Report')));
              }),
              _buildSubMenuItem('Daily View', () {
                _navigateTo(Center(child: Text('Daily View')));
              }),
              _buildSubMenuItem('Weekly View', () {
                _navigateTo(Center(child: Text('Weekly View')));
              }),
            ],
          ),
          _buildExpandableMenu(
            title: 'Auditing',
            subItems: [
              _buildSubMenuItem('Tree View', () {
                _navigateTo(TreeViewScreen(sqliteService: widget.sqliteService));
              }),
              _buildSubMenuItem('Kanban View', () {
                _navigateTo(KanbanViewScreen(sqliteService: widget.sqliteService));
              }),
            ],
          ),
          _buildExpandableMenu(
            title: 'Operational Activities',
            subItems: [
              _buildSubMenuItem('Ongoing Activities', () {
                _navigateTo(Center(child: Text('Ongoing Activities')));
              }),
              _buildSubMenuItem('Maintenance', () {
                _navigateTo(Center(child: Text('Maintenance')));
              }),
              _buildSubMenuItem('Assets', () {
                _navigateTo(Center(child: Text('Assets')));
              }),
              _buildSubMenuItem('Consumables', () {
                _navigateTo(Center(child: Text('Consumables')));
              }),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Administration'),
            onTap: () {
              _navigateTo(Center(child: Text('Administration')));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableMenu({
    required String title,
    required List<Widget> subItems,
  }) {
    return ExpansionTile(
      title: Text(title),
      children: subItems,
    );
  }

  Widget _buildSubMenuItem(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }
}