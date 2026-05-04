import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/gallery_item.dart';

class GalleryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
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

  // Add from device (uploads to Firebase Storage first)
  Future<void> addFromDevice(Uint8List imageBytes, String fileName) async {
    final storageRef = _storage.ref().child('gallery/$fileName-${DateTime.now().millisecondsSinceEpoch}.jpg');
    
    // Upload bytes
    final uploadTask = storageRef.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
    final snapshot = await uploadTask;
    
    // Get download URL
    final downloadUrl = await snapshot.ref.getDownloadURL();
    
    // Save to Firestore
    await addFromLink(downloadUrl);
  }

  // Update visibility
  Future<void> toggleVisibility(String id, bool isVisible) async {
    await _firestore.collection(collectionPath).doc(id).update({
      'isVisible': isVisible,
    });
  }

  // Delete item
  Future<void> deleteItem(GalleryItem item) async {
    // If it's a storage image (contains firebase_storage in URL), delete the file from storage
    if (item.imageUrl.contains('firebasestorage.googleapis.com')) {
      try {
        final ref = _storage.refFromURL(item.imageUrl);
        await ref.delete();
      } catch (e) {
        print('Error deleting image from storage: $e');
      }
    }
    
    // Delete from Firestore
    await _firestore.collection(collectionPath).doc(item.id).delete();
  }
}
