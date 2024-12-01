
class CardModel {
  final int? cardId;
  final String title;
  final String? description;
  final String? assignedTo;
  final String? awardingBody;
  final String cardStatus;
  final int priority;
  final DateTime? plannedStartDate;
  final DateTime? plannedEndDate;
  final DateTime? actualStartDate;
  final DateTime? actualEndDate;
  final int? parentCardId;
  final String cardType;
  final String? awardingBodyContact;

  CardModel({
    this.cardId,
    required this.title,
    this.description,
    this.assignedTo,
    this.awardingBody,
    required this.cardStatus,
    this.priority = 1,
    this.plannedStartDate,
    this.plannedEndDate,
    this.actualStartDate,
    this.actualEndDate,
    this.parentCardId,
    required this.cardType,
    this.awardingBodyContact,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      cardId: json['card_id'],
      title: json['title'],
      description: json['description'],
      assignedTo: json['assigned_to'],
      awardingBody: json['awarding_body'],
      cardStatus: json['card_status'],
      priority: json['priority'] ?? 1,
      plannedStartDate: json['planned_start_date'] != null
          ? DateTime.parse(json['planned_start_date'])
          : null,
      plannedEndDate: json['planned_end_date'] != null
          ? DateTime.parse(json['planned_end_date'])
          : null,
      actualStartDate: json['actual_start_date'] != null
          ? DateTime.parse(json['actual_start_date'])
          : null,
      actualEndDate: json['actual_end_date'] != null
          ? DateTime.parse(json['actual_end_date'])
          : null,
      parentCardId: json['parent_card_id'],
      cardType: json['card_type'],
      awardingBodyContact: json['awarding_body_contact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card_id': cardId,
      'title': title,
      'description': description,
      'assigned_to': assignedTo,
      'awarding_body': awardingBody,
      'card_status': cardStatus,
      'priority': priority,
      'planned_start_date': plannedStartDate?.toIso8601String(),
      'planned_end_date': plannedEndDate?.toIso8601String(),
      'actual_start_date': actualStartDate?.toIso8601String(),
      'actual_end_date': actualEndDate?.toIso8601String(),
      'parent_card_id': parentCardId,
      'card_type': cardType,
      'awarding_body_contact': awardingBodyContact,
    };
  }
}
