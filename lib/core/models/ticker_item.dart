class TickerItem {
  final String message;
  final int? screenIndex; // optional: navigate to a screen (0=Home…5=Donate)
  final String? link; // optional: open an external URL

  const TickerItem({
    required this.message,
    this.screenIndex,
    this.link,
  });
}
