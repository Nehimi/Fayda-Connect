
enum NewsType { standard, premium, alert, promotion, academy }

class NewsItem {
  final String id;
  final String title;
  final String content;
  final NewsType type;
  final DateTime date;
  final String imageUrl;
  final String? externalLink;

  NewsItem({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.date,
    required this.imageUrl,
    this.externalLink,
  });

  factory NewsItem.fromMap(String id, Map<dynamic, dynamic> map) {
    return NewsItem(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      type: _parseType(map['type']),
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      imageUrl: map['imageUrl'] ?? '',
      externalLink: map['externalLink'],
    );
  }

  static NewsType _parseType(String? typeStr) {
    switch (typeStr?.toLowerCase()) {
      case 'premium': return NewsType.premium;
      case 'alert': return NewsType.alert;
      case 'promotion': return NewsType.promotion;
      case 'academy': return NewsType.academy;
      default: return NewsType.standard;
    }
  }
}
