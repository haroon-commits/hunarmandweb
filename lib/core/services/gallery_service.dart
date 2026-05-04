import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gallery_item.dart';

class GalleryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'gallery';

  // Stream of gallery items (sorted by newest first)
  Stream<List<GalleryItem>> getGalleryItems() {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      final items = snapshot.docs
          .map((doc) => GalleryItem.fromMap(doc.data(), doc.id))
          .toList();

      // Sort in memory (newest first)
      items.sort((a, b) {
        final dateA = a.createdAt ?? DateTime(2000);
        final dateB = b.createdAt ?? DateTime(2000);
        return dateB.compareTo(dateA);
      });

      return items;
    });
  }

  // Add from URL link
  Future<void> addFromLink(String url) async {
    final docRef = _firestore.collection(collectionPath).doc();
    final item = GalleryItem(
      id: docRef.id,
      imageUrl: url,
      isVisible: true,
      createdAt: DateTime.now(),
    );
    await docRef.set(item.toMap());
  }

  // Add from device (Stores directly in Firestore as Base64 string)
  Future<void> addFromDevice(Uint8List imageBytes, String fileName) async {
    final String base64Image = base64Encode(imageBytes);
    final String dataUrl = 'data:image/jpeg;base64,$base64Image';
    await addFromLink(dataUrl);
  }

  // Update visibility
  Future<void> toggleVisibility(String id, bool isVisible) async {
    await _firestore.collection(collectionPath).doc(id).update({
      'isVisible': isVisible,
    });
  }

  // Delete item
  Future<void> deleteItem(GalleryItem item) async {
    await _firestore.collection(collectionPath).doc(item.id).delete();
  }
}
