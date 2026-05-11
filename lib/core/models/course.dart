import 'package:flutter/material.dart';

// Icon name ↔ IconData mapping using a list (IconData can't be a const map key)
final _kIconEntries = [
  (icon: Icons.school, name: 'school'),
  (icon: Icons.smart_toy, name: 'smart_toy'),
  (icon: Icons.brush, name: 'brush'),
  (icon: Icons.shopping_bag, name: 'shopping_bag'),
  (icon: Icons.language, name: 'language'),
  (icon: Icons.phone_android, name: 'phone_android'),
  (icon: Icons.computer, name: 'computer'),
  (icon: Icons.code, name: 'code'),
];

IconData _iconFromString(String? s) =>
    _kIconEntries.firstWhere((e) => e.name == s,
        orElse: () => _kIconEntries.first).icon;

String _iconToString(IconData icon) =>
    _kIconEntries.firstWhere((e) => e.icon == icon,
        orElse: () => _kIconEntries.first).name;

class Course {
  final String id;
  String title;
  List<String> subtitles;
  String registrationLink;
  String queryLink;
  String courseType;
  String locationDetail;
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

  Map<String, dynamic> toMap() => {
        'title': title,
        'subtitles': subtitles,
        'registrationLink': registrationLink,
        'queryLink': queryLink,
        'courseType': courseType,
        'locationDetail': locationDetail,
        'description': description,
        'duration': duration,
        'schedule': schedule,
        'price': price,
        'orderNumber': orderNumber,
        'remainingSeats': remainingSeats,
        'icon': _iconToString(icon),
        'isVisible': isVisible,
      };

  factory Course.fromMap(Map<String, dynamic> map, String id) => Course(
        id: id,
        title: map['title'] ?? '',
        subtitles: List<String>.from(map['subtitles'] ?? []),
        registrationLink: map['registrationLink'] ?? '',
        queryLink: map['queryLink'] ?? 'https://wa.me/923138840971',
        courseType: map['courseType'] ?? 'Physical',
        locationDetail: map['locationDetail'] ?? '',
        description: map['description'] ?? '',
        duration: map['duration'] ?? '',
        schedule: map['schedule'] ?? '',
        price: map['price'] ?? '',
        orderNumber: map['orderNumber'] ?? '01',
        remainingSeats: map['remainingSeats'] ?? '',
        icon: _iconFromString(map['icon']),
        isVisible: map['isVisible'] ?? true,
      );
}
