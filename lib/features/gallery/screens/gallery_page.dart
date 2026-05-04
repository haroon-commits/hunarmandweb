import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/models/gallery_item.dart';
import '../../../core/services/gallery_service.dart';
import '../../../shared/widgets/footer_section.dart';
import '../widgets/gallery_hero_section.dart';
import '../widgets/gallery_grid_section.dart';

class GalleryPage extends StatefulWidget {
  final Function(int) onNavigate;
  final ScrollController? scrollController;

  const GalleryPage({
    super.key,
    required this.onNavigate,
    this.scrollController,
  });

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with AutomaticKeepAliveClientMixin {
  final GalleryService _galleryService = GalleryService();

  // Hold the stream in state so it's created exactly ONCE
  late final Stream<List<GalleryItem>> _stream;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Create the Firestore stream once and reuse it
    _stream = _galleryService.getGalleryItems();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Column(
        children: [
          GalleryHeroSection(onNavigate: widget.onNavigate),
          StreamBuilder<List<GalleryItem>>(
            stream: _stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(50.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Center(
                    child: Text(
                      'Could not load gallery: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }
              final items = snapshot.data ?? [];
              return GalleryGridSection(galleryItems: items);
            },
          ),
          FooterSection(onNavigate: widget.onNavigate, activeIndex: 3),
        ],
      ),
    );
  }
}
