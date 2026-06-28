import 'package:flutter/material.dart';

class ClubModel {
  final String name;
  final String shortName;
  final String nickname;
  final String league;
  final String country;
  final Color color;
  final Color ink;
  final String badgeUrl;
  final int members;

  const ClubModel({
    required this.name,
    required this.shortName,
    required this.nickname,
    required this.league,
    required this.country,
    required this.color,
    required this.ink,
    required this.badgeUrl,
    this.members = 0,
  });

  factory ClubModel.fromMap(Map<String, dynamic> map) {
    final hex = (map['color'] as String? ?? '000000').replaceAll('#', '');
    final color = Color(int.parse('FF$hex', radix: 16));
    return ClubModel(
      name: map['name'] ?? '',
      shortName: map['shortName'] ?? '',
      nickname: map['nickname'] ?? '',
      league: map['league'] ?? '',
      country: map['country'] ?? '',
      color: color,
      ink: color.computeLuminance() > 0.4 ? Colors.black87 : Colors.white,
      badgeUrl: map['badgeUrl'] ?? '',
    );
  }
}
