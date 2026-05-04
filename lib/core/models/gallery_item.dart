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

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'isVisible': isVisible,
    };
  }

  factory GalleryItem.fromMap(Map<String, dynamic> map, String id) {
    return GalleryItem(
      id: id,
      imageUrl: map['imageUrl'] ?? '',
      isVisible: map['isVisible'] ?? true,
    );
  }
}
