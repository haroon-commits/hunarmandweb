import 'dart:typed_data';

class GalleryItem {
  final String id;
  String imageUrl; // used when image comes from a URL/link
  Uint8List? imageBytes; // used when image is picked from device
  bool isVisible;

  GalleryItem({
    required this.id,
    this.imageUrl = '',
    this.imageBytes,
    this.isVisible = true,
  });
}
