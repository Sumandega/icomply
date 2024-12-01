class CardItem {
  final String id;
  final String title;
  final String description;

  CardItem({required this.id, required this.title, required this.description});
}

class ColumnData {
  final String id;
  final String title;
  final List<CardItem> cards;

  ColumnData({required this.id, required this.title, required this.cards});
}
