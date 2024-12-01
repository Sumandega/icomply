import 'package:flutter/material.dart';
import 'package:icomply/services/sqlite_service.dart';

class AddEditCardScreen extends StatefulWidget {
  final SQLiteService sqliteService;
  final Map<String, dynamic>? cardData;

  const AddEditCardScreen({
    super.key,
    required this.sqliteService,
    this.cardData,
  });

  @override
  State<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _assignedToController;
  late String _status;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing card data or defaults
    _titleController = TextEditingController(text: widget.cardData?['title'] ?? '');
    _descriptionController = TextEditingController(text: widget.cardData?['description'] ?? '');
    _assignedToController = TextEditingController(text: widget.cardData?['assigned_to'] ?? '');
    _status = widget.cardData?['card_status'] ?? 'Backlog';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assignedToController.dispose();
    super.dispose();
  }

Future<void> _saveCard() async {
  if (_formKey.currentState?.validate() ?? false) {
    final Map<String, dynamic> card = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'assigned_to': _assignedToController.text,
      'card_status': _status,
    };

    try {
      if (widget.cardData == null) {
        // Add a new card
        await widget.sqliteService.insertCard(card);
      } else {
        // Update the existing card
        final int cardId = widget.cardData!['card_id'];
        await widget.sqliteService.updateCard(cardId, card);
      }

      // Use context only if the widget is still mounted
      if (mounted) {
        Navigator.pop(context); // Line 89 fixed
      }
    } catch (e) {
      // Use context only if the widget is still mounted
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar( // Line 92 fixed
          SnackBar(content: Text('Failed to save card: $e')),
        );
      }
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cardData == null ? 'Add Card' : 'Edit Card'),
        actions: [
          if (widget.cardData != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                try {
                  final int cardId = widget.cardData!['card_id'];
                  await widget.sqliteService.deleteCard(cardId);
                  if (mounted) Navigator.pop(context);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete card: $e')),
                    );
                  }
                }
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _assignedToController,
                decoration: const InputDecoration(labelText: 'Assigned To'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['Backlog', 'Planned', 'Doing', 'Done']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveCard,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
