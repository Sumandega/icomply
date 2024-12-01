import 'package:flutter/material.dart';
import 'package:icomply/services/sqlite_service.dart';

class KanbanColumn extends StatelessWidget {
  final String status;
  final List<Map<String, dynamic>> cards;
  final SQLiteService sqliteService;
  final void Function(Map<String, dynamic>) onCardMoved;
  final void Function(Map<String, dynamic>)? onCardTapped;

  const KanbanColumn({
    super.key,
    required this.status,
    required this.cards,
    required this.sqliteService,
    required this.onCardMoved,
    this.onCardTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DragTarget<Map<String, dynamic>>(
        onAcceptWithDetails: (details) async {
          final data = Map<String, dynamic>.from(details.data);
          if (data['card_status'] != status) {
            final previousStatus = data['card_status'];
            data['card_status'] = status;
            onCardMoved(data);

            try {
              await sqliteService.updateCard(data['card_id'], data);
            } catch (e) {
              data['card_status'] = previousStatus;
              onCardMoved(data);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to move card: $e')),
                );
              }
            }
          }
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return Draggable<Map<String, dynamic>>(
                        key: ValueKey(card['card_id']),
                        data: card,
                        feedback: Material(
                          color: Colors.transparent,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: Card(
                              elevation: 4.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(card['title'] ?? 'Unnamed Card'),
                              ),
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.5,
                          child: _buildCardTile(card),
                        ),
                        child: _buildCardTile(card),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardTile(Map<String, dynamic> card) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
    child: Semantics(
      label: 'Card: ${card['title'] ?? 'Unnamed Card'}',
      child: ListTile(
        title: Text(card['title'] ?? 'Unnamed Card'),
        subtitle: Text(card['description'] ?? 'No description'),
        onTap: () {
          if (onCardTapped != null) {
            onCardTapped!(card);
          }
        },
      ),
    ),
  );
}
}
