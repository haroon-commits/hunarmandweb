import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/models/gallery_item.dart';
import '../../../../core/services/gallery_service.dart';

class ManageGalleryTab extends StatefulWidget {
  final VoidCallback onUpdate;

  const ManageGalleryTab({
    super.key,
    required this.onUpdate,
  });

  @override
  State<ManageGalleryTab> createState() => _ManageGalleryTabState();
}

class _ManageGalleryTabState extends State<ManageGalleryTab> {
  final GalleryService _galleryService = GalleryService();

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gallery Images',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _showAddImageDialog,
                icon: const Icon(Icons.add_a_photo),
                label: const Text('Add Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentOrange,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<GalleryItem>>(
            stream: _galleryService.getGalleryItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error loading gallery: ${snapshot.error}'));
              }

              final items = snapshot.data ?? [];

              if (items.isEmpty) {
                return const Center(
                  child: Text(
                    'No images yet. Tap "Add Image" to get started.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.5,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) =>
                    _buildGridCard(index, items[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Grid card ──────────────────────────────────────────────────────────────

  Widget _buildGridCard(int index, GalleryItem item) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _buildImage(item),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Row(
            children: [
              _iconAction(
                icon: item.isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.blue,
                onPressed: () {
                  _galleryService.toggleVisibility(item.id, !item.isVisible);
                },
              ),
              const SizedBox(width: 5),
              _iconAction(
                icon: Icons.delete,
                color: Colors.red,
                onPressed: () {
                  _galleryService.deleteItem(item);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage(GalleryItem item) {
    if (item.imageBytes != null) {
      return Image.memory(
        item.imageBytes!,
        fit: BoxFit.cover,
        opacity: AlwaysStoppedAnimation(item.isVisible ? 1.0 : 0.4),
      );
    }
    if (item.imageUrl.startsWith('data:image')) {
      final base64String = item.imageUrl.split(',').last;
      return Image.memory(
        base64Decode(base64String),
        fit: BoxFit.cover,
        opacity: AlwaysStoppedAnimation(item.isVisible ? 1.0 : 0.4),
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          child: const Center(child: Icon(Icons.broken_image, color: Colors.red)),
        ),
      );
    }

    return Image.network(
      _processImageUrl(item.imageUrl), // Using the proxy helper here
      fit: BoxFit.cover,
      opacity: AlwaysStoppedAnimation(item.isVisible ? 1.0 : 0.4),
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[200],
        child: const Center(child: Icon(Icons.broken_image, color: Colors.red)),
      ),
    );
  }

  Widget _iconAction({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: IconButton(
        icon: Icon(icon, color: color, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  // ── Add image dialog ───────────────────────────────────────────────────────

  void _showAddImageDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AddImageDialog(
        // Save the RAW url to Firestore (not the proxy-wrapped one)
        onAddFromLink: (rawUrl) async {
          try {
            await _galleryService.addFromLink(rawUrl);
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image added successfully!')));
          } catch (e) {
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
          }
        },
        // Proxy is only used for the live preview inside the dialog
        processUrl: _processImageUrl,
      ),
    );
  }

  // ── URL processing ─────────────────────────────────────────────────────────

  String _processImageUrl(String url) {
    if (url.isEmpty) return '';
    // For Flutter Web, we use a proxy to avoid CORS issues when loading external images
    if (url.startsWith('http') && !url.contains('corsproxy.io')) {
      return 'https://corsproxy.io/?${Uri.encodeComponent(url.trim())}';
    }
    return url.trim();
  }
}

// ── Add Image Dialog (Simplified) ───────────────────────────────────────────

class _AddImageDialog extends StatefulWidget {
  final void Function(String processedUrl) onAddFromLink;
  final String Function(String url) processUrl;

  const _AddImageDialog({
    required this.onAddFromLink,
    required this.processUrl,
  });

  @override
  State<_AddImageDialog> createState() => _AddImageDialogState();
}

class _AddImageDialogState extends State<_AddImageDialog> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _urlController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _submit() {
    final raw = _urlController.text.trim();
    if (raw.isEmpty) return;
    // Pass the RAW url – the proxy is only for preview rendering, not storage
    widget.onAddFromLink(raw);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final url = _urlController.text.trim();

    return AlertDialog(
      title: const Text('Add Gallery Image Link'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter a direct link to an image (ending in .jpg, .png, etc.)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _urlController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Direct Image URL',
                hintText: 'https://example.com/image.jpg',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 20),
            if (url.isNotEmpty)
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.processUrl(url),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, color: Colors.red),
                          SizedBox(height: 8),
                          Text('Invalid image link',
                              style: TextStyle(color: Colors.red, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: url.isNotEmpty ? _submit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkGreen,
            foregroundColor: Colors.white,
          ),
          child: const Text('Add Image'),
        ),
      ],
    );
  }
}
