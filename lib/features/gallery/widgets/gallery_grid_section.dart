import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../core/models/gallery_item.dart';
import '../../../core/utils/responsive.dart';

class GalleryGridSection extends StatelessWidget {
  final List<GalleryItem> galleryItems;
  const GalleryGridSection({super.key, required this.galleryItems});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    final visibleItems = galleryItems.where((item) => item.isVisible).toList();

    if (visibleItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 120,
        horizontal: isMobile ? 24 : 150,
      ),
      child: Wrap(
        spacing: 30,
        runSpacing: 30,
        alignment: WrapAlignment.center,
        children: visibleItems
            .map((item) => _buildImageCard(item, context))
            .toList(),
      ),
    );
  }

  String _wrapWithProxy(String url) {
    if (url.isEmpty) return '';
    // For Flutter Web, we use a proxy to avoid CORS issues when loading external images
    if (url.startsWith('http') && !url.contains('corsproxy.io')) {
      return 'https://corsproxy.io/?${Uri.encodeComponent(url)}';
    }
    return url;
  }

  Widget _buildImageCard(GalleryItem item, BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    return Container(
      width: isMobile ? double.infinity : 400,
      height: isMobile ? 240 : 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _buildImage(item),
      ),
    );
  }

  Widget _buildImage(GalleryItem item) {
    if (item.imageBytes != null) {
      return Image.memory(item.imageBytes!, fit: BoxFit.cover);
    }
    
    if (item.imageUrl.startsWith('data:image')) {
      final base64String = item.imageUrl.split(',').last;
      return Image.memory(base64Decode(base64String), fit: BoxFit.cover);
    }

    return Image.network(
      _wrapWithProxy(item.imageUrl),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
        ),
      ),
    );
  }
}
