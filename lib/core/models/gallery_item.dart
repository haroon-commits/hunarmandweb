import 'dart:typed_data';

class GalleryItem {
  final String id;
  String imageUrl;
  Uint8List? imageBytes;
  bool isVisible;
  DateTime? createdAt;

  GalleryItem({
    required this.id,
    this.imageUrl = '',
    this.imageBytes,
    this.isVisible = true,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'isVisible': isVisible,
      'createdAt': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory GalleryItem.fromMap(Map<String, dynamic> map, String id) {
    return GalleryItem(
      id: id,
      imageUrl: map['imageUrl'] ?? '',
      isVisible: map['isVisible'] ?? true,
      createdAt: map['createdAt'] != null 
        ? DateTime.tryParse(map['createdAt']) 
        : null,
    );
  }
}
