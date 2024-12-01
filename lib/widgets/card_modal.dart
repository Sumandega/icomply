import 'package:flutter/material.dart';

class CardDetailsModal extends StatelessWidget {
  final Map<String, dynamic> cardData;
  final VoidCallback onClose;

  const CardDetailsModal({
    super.key,
    required this.cardData,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cardData['title'] ?? 'Unnamed Card',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailField('Description', cardData['description']),
                _buildDetailField('Assigned To', cardData['assigned_to']),
                _buildDetailField('Awarding Body', cardData['awarding_body']),
                _buildDetailField('Contact', cardData['awarding_body_contact']),
                _buildDetailField('Status', cardData['card_status']),
                _buildDetailField('Priority', cardData['priority']?.toString()),
                _buildDetailField(
                    'Planned Start Date', cardData['planned_start_date']),
                _buildDetailField(
                    'Planned End Date', cardData['planned_end_date']),
                _buildDetailField(
                    'Actual Start Date', cardData['actual_start_date']),
                _buildDetailField(
                    'Actual End Date', cardData['actual_end_date']),
                _buildDetailField('Type', cardData['card_type']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value ?? 'N/A'),
          ),
        ],
      ),
    );
  }
}
