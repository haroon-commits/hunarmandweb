import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/models/ticker_item.dart';
import '../../core/utils/responsive.dart';

class TickerWidget extends StatefulWidget {
  final List<TickerItem> items;
  final Function(int)? onNavigate; // for internal screen navigation
  const TickerWidget({super.key, required this.items, this.onNavigate});

  @override
  State<TickerWidget> createState() => _TickerWidgetState();
}

class _TickerWidgetState extends State<TickerWidget>
    with TickerProviderStateMixin {
  // Mobile/Cycling state
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  // Web/Scrolling state
  late AnimationController _scrollController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startMobileTimer();
    _scrollController = AnimationController(vsync: this);
    _startWebScroll();
  }

  void _startMobileTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && widget.items.length > 1) {
        if (_currentPage < widget.items.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  void _startWebScroll() {
    String fullText = widget.items.map((i) => i.message).join('  •  ');
    int seconds = (fullText.length / 10).clamp(15.0, 90.0).toInt();
    _scrollController.duration = Duration(seconds: seconds);
    _scrollController.repeat();
  }

  @override
  void didUpdateWidget(TickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _startWebScroll();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Handles tapping an item: screen nav takes priority over URL.
  void _handleTap(TickerItem item) async {
    if (item.screenIndex != null && widget.onNavigate != null) {
      widget.onNavigate!(item.screenIndex!);
      return;
    }
    if (item.link != null && item.link!.isNotEmpty) {
      final uri = Uri.parse(item.link!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  bool _isTappable(TickerItem item) =>
      item.screenIndex != null || (item.link != null && item.link!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      height: isMobile ? 36 : 42,
      decoration:
          const BoxDecoration(color: Color.fromRGBO(242, 169, 0, 1)),
      child: Row(
        children: [
          // LATEST label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: double.infinity,
            color: Colors.black.withValues(alpha: 0.1),
            child: const Center(
              child: Text(
                'LATEST',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: isMobile
                ? _buildMobileCycling()
                : _buildWebScrolling(),
          ),
          // Icon
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.campaign, color: Colors.white38, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCycling() {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return GestureDetector(
          onTap: _isTappable(item) ? () => _handleTap(item) : null,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                item.message,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                  decoration: _isTappable(item)
                      ? TextDecoration.underline
                      : null,
                  decorationColor: Colors.white70,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWebScrolling() {
    final hasAnyTappable = widget.items.any(_isTappable);

    Widget scrollingText = ClipRect(
      child: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, child) {
          return Align(
            alignment:
                Alignment(4.0 - (_scrollController.value * 8.0), 0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.items.map((i) => i.message).join('  •  '),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
                maxLines: 1,
              ),
            ),
          );
        },
      ),
    );

    if (!hasAnyTappable) return scrollingText;

    final firstTappable =
        widget.items.firstWhere(_isTappable, orElse: () => widget.items.first);

    return GestureDetector(
      onTap: () => _handleTap(firstTappable),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: scrollingText,
      ),
    );
  }
}
