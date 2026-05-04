import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/models/gallery_item.dart';

class ManageGalleryTab extends StatefulWidget {
  final List<GalleryItem> galleryItems;
  final VoidCallback onUpdate;

  const ManageGalleryTab({
    super.key,
    required this.galleryItems,
    required this.onUpdate,
  });

  @override
  State<ManageGalleryTab> createState() => _ManageGalleryTabState();
}

class _ManageGalleryTabState extends State<ManageGalleryTab> {
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
          child: widget.galleryItems.isEmpty
              ? const Center(
                  child: Text(
                    'No images yet. Tap "Add Image" to get started.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: widget.galleryItems.length,
                  itemBuilder: (context, index) =>
                      _buildGridCard(index, widget.galleryItems[index]),
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
                  setState(() => item.isVisible = !item.isVisible);
                  widget.onUpdate();
                },
              ),
              const SizedBox(width: 5),
              _iconAction(
                icon: Icons.delete,
                color: Colors.red,
                onPressed: () {
                  setState(() => widget.galleryItems.removeAt(index));
                  widget.onUpdate();
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
    return Image.network(
      item.imageUrl,
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
      builder: (context) => _AddImageDialog(
        onAddFromDevice: _addFromDevice,
        onAddFromLink: _addFromLink,
        processUrl: _processImageUrl,
      ),
    );
  }

  Future<void> _addFromDevice(Uint8List bytes) async {
    setState(() {
      widget.galleryItems.add(
        GalleryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          imageBytes: bytes,
        ),
      );
    });
    widget.onUpdate();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Image added successfully')));
    }
  }

  void _addFromLink(String processedUrl) {
    setState(() {
      widget.galleryItems.add(
        GalleryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          imageUrl: processedUrl,
        ),
      );
    });
    widget.onUpdate();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Image added successfully')));
  }

  // ── URL processing ─────────────────────────────────────────────────────────

  String _processImageUrl(String url) {
    if (url.contains('drive.google.com')) {
      final RegExp regExp = RegExp(r'(?:/d/|id=)([a-zA-Z0-9_-]+)');
      final Match? match = regExp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        final String? fileId = match.group(1);
        final directUrl = 'https://drive.google.com/uc?export=view&id=$fileId';
        return 'https://images1-focus-opensocial.googleusercontent.com/gadgets/proxy?container=focus&refresh=2592000&url=${Uri.encodeComponent(directUrl)}';
      }
    }
    return url;
  }
}

// ── Add Image Dialog (self-contained) ─────────────────────────────────────────

class _AddImageDialog extends StatefulWidget {
  final Future<void> Function(Uint8List bytes) onAddFromDevice;
  final void Function(String processedUrl) onAddFromLink;
  final String Function(String url) processUrl;

  const _AddImageDialog({
    required this.onAddFromDevice,
    required this.onAddFromLink,
    required this.processUrl,
  });

  @override
  State<_AddImageDialog> createState() => _AddImageDialogState();
}

class _AddImageDialogState extends State<_AddImageDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _urlController = TextEditingController();

  Uint8List? _pickedBytes;
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _urlController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _pickFromDevice() {
    final input = html.FileUploadInputElement()..accept = 'image/*';

    input.onChange.listen((_) async {
      final file = input.files?.first;
      if (file == null || !mounted) return;

      setState(() => _isPicking = true);

      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoadEnd.first;

      if (!mounted) return;
      setState(() {
        final result = reader.result;
        if (result is List<int>) {
          _pickedBytes = Uint8List.fromList(result);
        }
        _isPicking = false;
      });
    });

    input.click();
  }

  void _submit() {
    if (_tabController.index == 0) {
      // From Device
      if (_pickedBytes == null) return;
      widget.onAddFromDevice(_pickedBytes!);
    } else {
      // From Link
      final raw = _urlController.text.trim();
      if (raw.isEmpty) return;
      widget.onAddFromLink(widget.processUrl(raw));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Gallery Image'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Tab bar ──
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: kDarkGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black54,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.upload_file, size: 18),
                    text: 'From Device',
                  ),
                  Tab(icon: Icon(Icons.link, size: 18), text: 'From Link'),
                ],
                onTap: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 20),

            // ── Tab content ──
            SizedBox(
              height: 220,
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [_buildDeviceTab(), _buildLinkTab()],
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
          onPressed: _canSubmit() ? _submit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkGreen,
            foregroundColor: Colors.white,
          ),
          child: const Text('Add Image'),
        ),
      ],
    );
  }

  bool _canSubmit() {
    if (_tabController.index == 0) return _pickedBytes != null;
    return _urlController.text.trim().isNotEmpty;
  }

  // ── From Device tab ────────────────────────────────────────────────────────

  Widget _buildDeviceTab() {
    if (_pickedBytes != null) {
      return Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                _pickedBytes!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _pickFromDevice,
            icon: const Icon(Icons.refresh),
            label: const Text('Choose Different Image'),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: _isPicking ? null : _pickFromDevice,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: _isPicking
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Click to choose an image',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'JPG, PNG, WebP supported',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }

  // ── From Link tab ──────────────────────────────────────────────────────────

  Widget _buildLinkTab() {
    final url = _urlController.text.trim();
    return Column(
      children: [
        TextField(
          controller: _urlController,
          decoration: const InputDecoration(
            labelText: 'Image URL',
            hintText: 'Direct link or Google Drive share link',
            helperText:
                'For Google Drive, ensure file is set to "Anyone with the link"',
            helperStyle: TextStyle(fontSize: 10, color: Colors.blueGrey),
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.link),
          ),
        ),
        const SizedBox(height: 12),
        if (url.isNotEmpty)
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.processUrl(url),
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.broken_image, color: Colors.red),
                    const SizedBox(height: 8),
                    const Text(
                      'Could not load image',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                    TextButton(
                      onPressed: () async {
                        final uri = Uri.parse(widget.processUrl(url));
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      child: const Text(
                        'Verify Link Manually',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
