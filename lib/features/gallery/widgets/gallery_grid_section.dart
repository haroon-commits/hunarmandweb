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

  Widget _buildImageCard(GalleryItem item, BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    ImageProvider imageProvider;
    if (item.imageBytes != null) {
      imageProvider = MemoryImage(item.imageBytes!);
    } else if (item.imageUrl.startsWith('data:image')) {
      final base64String = item.imageUrl.split(',').last;
      imageProvider = MemoryImage(base64Decode(base64String));
    } else {
      imageProvider = NetworkImage(item.imageUrl);
    }

    return Container(
      width: isMobile ? double.infinity : 400,
      height: isMobile ? 240 : 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
    );
  }
}
