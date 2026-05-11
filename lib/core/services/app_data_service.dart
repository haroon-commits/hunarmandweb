import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/bank_details.dart';
import '../models/course.dart';
import '../models/donation_option.dart';
import '../models/ticker_item.dart';

/// Single service that handles Courses, Donations, Bank Details, and Ticker
/// persistence in Firestore.
///
/// Collections:
///   courses/          — one doc per course
///   donations/        — one doc per donation option
///   settings/bank     — single document for bank details
///   settings/ticker   — single document whose 'items' field is a List
class AppDataService {
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  // ── Courses ────────────────────────────────────────────────────────────────

  Stream<List<Course>> coursesStream() {
    return _db.collection('courses').snapshots().map((snap) {
      final list = snap.docs
          .map((d) => Course.fromMap(d.data(), d.id))
          .toList();
      list.sort((a, b) => a.orderNumber.compareTo(b.orderNumber));
      return list;
    });
  }

  Future<void> saveCourse(Course course) async {
    await _db.collection('courses').doc(course.id).set(course.toMap());
    debugPrint('[AppDataService] Course saved: ${course.id}');
  }

  Future<void> deleteCourse(String id) async {
    await _db.collection('courses').doc(id).delete();
    debugPrint('[AppDataService] Course deleted: $id');
  }

  // ── Donations ──────────────────────────────────────────────────────────────

  Stream<List<DonationOption>> donationsStream() {
    return _db.collection('donations').snapshots().map((snap) =>
        snap.docs.map((d) => DonationOption.fromMap(d.data(), d.id)).toList());
  }

  Future<void> saveDonation(DonationOption opt) async {
    await _db.collection('donations').doc(opt.id).set(opt.toMap());
    debugPrint('[AppDataService] Donation saved: ${opt.id}');
  }

  Future<void> deleteDonation(String id) async {
    await _db.collection('donations').doc(id).delete();
    debugPrint('[AppDataService] Donation deleted: $id');
  }

  // ── Bank Details ───────────────────────────────────────────────────────────

  Stream<BankDetails?> bankStream() {
    return _db
        .collection('settings')
        .doc('bank')
        .snapshots()
        .map((snap) => snap.exists ? BankDetails.fromMap(snap.data()!) : null);
  }

  Future<void> saveBank(BankDetails bank) async {
    await _db.collection('settings').doc('bank').set(bank.toMap());
    debugPrint('[AppDataService] Bank details saved');
  }

  // ── Ticker ─────────────────────────────────────────────────────────────────

  Stream<List<TickerItem>> tickerStream() {
    return _db
        .collection('settings')
        .doc('ticker')
        .snapshots()
        .map((snap) {
      if (!snap.exists) return <TickerItem>[];
      final raw = snap.data()?['items'] as List<dynamic>? ?? [];
      return raw
          .map((e) => TickerItem.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    });
  }

  Future<void> saveTicker(List<TickerItem> items) async {
    await _db.collection('settings').doc('ticker').set({
      'items': items.map((i) => i.toMap()).toList(),
    });
    debugPrint('[AppDataService] Ticker saved (${items.length} items)');
  }
}
