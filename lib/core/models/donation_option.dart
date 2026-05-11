import 'package:flutter/material.dart';

final _kDonationIconEntries = [
  (icon: Icons.card_giftcard, name: 'card_giftcard'),
  (icon: Icons.menu_book, name: 'menu_book'),
  (icon: Icons.group, name: 'group'),
  (icon: Icons.favorite, name: 'favorite'),
  (icon: Icons.volunteer_activism, name: 'volunteer_activism'),
];

IconData _iconFromString(String? s) => _kDonationIconEntries
    .firstWhere((e) => e.name == s,
        orElse: () => _kDonationIconEntries.first).icon;

String _iconToString(IconData icon) => _kDonationIconEntries
    .firstWhere((e) => e.icon == icon,
        orElse: () => _kDonationIconEntries.first).name;

class DonationOption {
  final String id;
  String title;
  String price;
  String description;
  IconData icon;
  bool isPopular;

  DonationOption({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.icon,
    this.isPopular = false,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'price': price,
        'description': description,
        'icon': _iconToString(icon),
        'isPopular': isPopular,
      };

  factory DonationOption.fromMap(Map<String, dynamic> map, String id) =>
      DonationOption(
        id: id,
        title: map['title'] ?? '',
        price: map['price'] ?? '',
        description: map['description'] ?? '',
        icon: _iconFromString(map['icon']),
        isPopular: map['isPopular'] ?? false,
      );
}
