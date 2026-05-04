import 'package:flutter/material.dart';

import '../../../core/models/gallery_item.dart';
import '../../../core/services/gallery_service.dart';
import '../../../shared/widgets/footer_section.dart';
import '../widgets/gallery_hero_section.dart';
import '../widgets/gallery_grid_section.dart';

class GalleryPage extends StatelessWidget {
  final Function(int) onNavigate;
  final ScrollController? scrollController;

  GalleryPage({
    super.key,
    required this.onNavigate,
    this.scrollController,
  });

  final GalleryService _galleryService = GalleryService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          GalleryHeroSection(onNavigate: onNavigate),
          StreamBuilder<List<GalleryItem>>(
            stream: _galleryService.getGalleryItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(50.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final items = snapshot.data ?? [];
              return GalleryGridSection(galleryItems: items);
            },
          ),
          FooterSection(onNavigate: onNavigate, activeIndex: 3),
        ],
      ),
    );
  }
}
