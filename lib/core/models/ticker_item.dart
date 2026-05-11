class TickerItem {
  final String message;
  final int? screenIndex;
  final String? link;

  const TickerItem({
    required this.message,
    this.screenIndex,
    this.link,
  });

  Map<String, dynamic> toMap() => {
        'message': message,
        'screenIndex': screenIndex,
        'link': link,
      };

  factory TickerItem.fromMap(Map<String, dynamic> map) => TickerItem(
        message: map['message'] ?? '',
        screenIndex: map['screenIndex'] as int?,
        link: map['link'] as String?,
      );
}
