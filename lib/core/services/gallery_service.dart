import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gallery_item.dart';

class GalleryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'gallery';

  // Stream of gallery items (real-time updates)
  Stream<List<GalleryItem>> getGalleryItems() {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => GalleryItem.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Add from URL link
  Future<void> addFromLink(String url) async {
    final docRef = _firestore.collection(collectionPath).doc();
    final item = GalleryItem(id: docRef.id, imageUrl: url, isVisible: true);
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

