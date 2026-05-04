import 'package:flutter/material.dart';

class Course {
  final String id;
  String title;
  List<String> subtitles;
  String registrationLink;
  String queryLink; // Link for the Query button (e.g. WhatsApp)
  String courseType; // Physical, Online
  String locationDetail; // Platform for Online, Address for Physical
  String description;
  String duration;
  String schedule;
  String price;
  String orderNumber;
  String remainingSeats;
  IconData icon;
  bool isVisible;

  Course({
    required this.id,
    required this.title,
    required this.subtitles,
    this.registrationLink = '',
    this.queryLink = 'https://wa.me/923138840971',
    this.courseType = 'Physical',
    this.locationDetail = '',
    this.description = '',
    this.duration = '',
    this.schedule = '',
    this.price = '',
    this.orderNumber = '01',
    this.remainingSeats = '',
    required this.icon,
    this.isVisible = true,
  });
}
