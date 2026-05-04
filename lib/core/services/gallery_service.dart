import 'dart:typed_data';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/gallery_item.dart';

class GalleryService {
  // Lazy getter so Firestore is only accessed after Firebase.initializeApp()
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  static const String collectionPath = 'gallery';

  // ── Stream of gallery items (sorted newest first) ──────────────────────────
  Stream<List<GalleryItem>> getGalleryItems() {
    debugPrint('[GalleryService] Subscribing to "$collectionPath" stream...');
    return _db
        .collection(collectionPath)
        .snapshots()
        .handleError((error) {
          debugPrint('[GalleryService] ❌ Stream error: $error');
        })
        .map((snapshot) {
          debugPrint(
              '[GalleryService] ✅ Received ${snapshot.docs.length} docs from Firestore.');
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

  // ── Add image from URL ─────────────────────────────────────────────────────
  Future<void> addFromLink(String url) async {
    debugPrint('[GalleryService] addFromLink() called with url: "$url"');

    if (url.trim().isEmpty) {
      debugPrint('[GalleryService] ❌ Rejected: URL is empty.');
      throw Exception('Image URL cannot be empty.');
    }

    try {
      final docRef = _db.collection(collectionPath).doc();
      debugPrint('[GalleryService] Writing to doc: ${docRef.id}');

      final data = {
        'imageUrl': url.trim(),
        'isVisible': true,
        'createdAt': DateTime.now().toIso8601String(),
      };

      debugPrint('[GalleryService] Data to write: $data');
      await docRef.set(data);
      debugPrint('[GalleryService] ✅ Successfully wrote to Firestore! Doc id: ${docRef.id}');
    } on FirebaseException catch (e) {
      debugPrint('[GalleryService] ❌ FirebaseException: code=${e.code}, message=${e.message}');
      rethrow;
    } catch (e, stack) {
      debugPrint('[GalleryService] ❌ Unexpected error: $e');
      debugPrint('[GalleryService] Stack: $stack');
      rethrow;
    }
  }

  // ── Add image from device bytes (stored as base64 data URL) ───────────────
  Future<void> addFromDevice(Uint8List imageBytes, String fileName) async {
    debugPrint('[GalleryService] addFromDevice() called for file: $fileName');
    final String base64Image = base64Encode(imageBytes);
    final String dataUrl = 'data:image/jpeg;base64,$base64Image';
    await addFromLink(dataUrl);
  }

  // ── Toggle visibility ──────────────────────────────────────────────────────
  Future<void> toggleVisibility(String id, bool isVisible) async {
    debugPrint('[GalleryService] toggleVisibility($id, $isVisible)');
    try {
      await _db.collection(collectionPath).doc(id).update({'isVisible': isVisible});
      debugPrint('[GalleryService] ✅ Visibility updated.');
    } catch (e) {
      debugPrint('[GalleryService] ❌ Failed to toggle visibility: $e');
      rethrow;
    }
  }

  // ── Delete item ────────────────────────────────────────────────────────────
  Future<void> deleteItem(GalleryItem item) async {
    debugPrint('[GalleryService] deleteItem(${item.id})');
    try {
      await _db.collection(collectionPath).doc(item.id).delete();
      debugPrint('[GalleryService] ✅ Deleted doc: ${item.id}');
    } catch (e) {
      debugPrint('[GalleryService] ❌ Failed to delete: $e');
      rethrow;
    }
  }
}
