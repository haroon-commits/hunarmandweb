import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/models/ticker_item.dart';
import '../../../../core/services/app_data_service.dart';

// ──────────────────────────────────────────────
// Per-item editor state
// ──────────────────────────────────────────────
class _TickerItemState {
  final TextEditingController messageController;
  final TextEditingController linkController;
  int? screenIndex;

  _TickerItemState({
    required String message,
    required this.screenIndex,
    required String link,
  }) : messageController = TextEditingController(text: message),
       linkController = TextEditingController(text: link);

  void dispose() {
    messageController.dispose();
    linkController.dispose();
  }
}

// ──────────────────────────────────────────────
// Widget
// ──────────────────────────────────────────────
class ManageTickerTab extends StatefulWidget {
  final List<TickerItem> tickerItems;
  final Function(List<TickerItem>) onUpdateTicker;

  const ManageTickerTab({
    super.key,
    required this.tickerItems,
    required this.onUpdateTicker,
  });

  @override
  State<ManageTickerTab> createState() => _ManageTickerTabState();
}

class _ManageTickerTabState extends State<ManageTickerTab> {
  late List<_TickerItemState> _items;
  final _service = AppDataService();

  static const List<DropdownMenuItem<int?>> _screenItems = [
    DropdownMenuItem(value: null, child: Text('None (no screen)')),
    DropdownMenuItem(value: 0, child: Text('Home')),
    DropdownMenuItem(value: 1, child: Text('About Us')),
    DropdownMenuItem(value: 2, child: Text('Courses')),
    DropdownMenuItem(value: 3, child: Text('Gallery')),
    DropdownMenuItem(value: 4, child: Text('Contact')),
    DropdownMenuItem(value: 5, child: Text('Donate')),
  ];

  @override
  void initState() {
    super.initState();
    _items = widget.tickerItems
        .map(
          (item) => _TickerItemState(
            message: item.message,
            screenIndex: item.screenIndex,
            link: item.link ?? '',
          ),
        )
        .toList();

    if (_items.isEmpty) {
      _items.add(_TickerItemState(message: '', screenIndex: null, link: ''));
    }
  }

  @override
  void dispose() {
    for (var item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _items.add(_TickerItemState(message: '', screenIndex: null, link: ''));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items[index].dispose();
      _items.removeAt(index);
    });
  }

  void _save() {
    final finalItems = _items
        .where((i) => i.messageController.text.trim().isNotEmpty)
        .map(
          (i) => TickerItem(
            message: i.messageController.text.trim(),
            screenIndex: i.screenIndex,
            link: i.linkController.text.trim().isEmpty
                ? null
                : i.linkController.text.trim(),
          ),
        )
        .toList();

    // Save to Firestore
    _service.saveTicker(finalItems).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Ticker saved to Firebase!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }).catchError((e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('❌ Error saving: $e'),
              backgroundColor: Colors.red),
        );
      }
    });

    // Also notify parent for in-memory sync
    widget.onUpdateTicker(finalItems);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            const Text(
              'Announcement Ticker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add scrolling announcements. For each entry you can optionally link to an internal screen or an external URL. Screen link takes priority over URL.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 30),

            // ── Item list ──
            ...List.generate(_items.length, (index) {
              final item = _items[index];
              return _buildItemCard(index, item);
            }),

            // ── Add button ──
            OutlinedButton.icon(
              onPressed: _addItem,
              icon: const Icon(Icons.add),
              label: const Text('Add Another Announcement'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // ── Save ──
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save All Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(int index, _TickerItemState item) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: item.linkController,
      builder: (context, linkValue, _) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title row ──
              Row(
                children: [
                  Text(
                    'Announcement ${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    tooltip: 'Remove',
                    onPressed: () => _removeItem(index),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ── Message ──
              TextField(
                controller: item.messageController,
                decoration: const InputDecoration(
                  labelText: 'Message *',
                  hintText: 'Admissions open for Batch 5!',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.campaign_outlined),
                ),
              ),
              const SizedBox(height: 14),

              // ── Screen dropdown (optional) ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Link to Screen (optional)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.4),
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: DropdownButton<int?>(
                      value: item.screenIndex,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: _screenItems,
                      onChanged: (val) =>
                          setState(() => item.screenIndex = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── External URL (optional) ──
              TextField(
                controller: item.linkController,
                decoration: const InputDecoration(
                  labelText: 'External URL (optional)',
                  hintText: 'https://example.com',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
              ),

              // ── Priority warning ──
              if (item.screenIndex != null && linkValue.text.trim().isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    '⚠ Screen link takes priority over the external URL.',
                    style: TextStyle(fontSize: 11, color: Colors.orange),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
