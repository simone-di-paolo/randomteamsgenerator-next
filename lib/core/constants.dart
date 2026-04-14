import 'package:flutter/material.dart';
import '../data/models/team_model.dart';

class TeamConstants {
  static const List<String> adjectives = [
    'Fierce', 'Mighty', 'Sneaky', 'Brave', 'Clever', 
    'Swift', 'Giant', 'Tiny', 'Cosmic', 'Wild'
  ];

  static const List<String> animals = [
    'Tigers', 'Dragons', 'Foxes', 'Bears', 'Owls', 
    'Hawks', 'Whales', 'Ants', 'Unicorns', 'Wolves'
  ];

  static const List<String> colors = [
    '#ef4444', '#f97316', '#f59e0b', '#84cc16', 
    '#22c55e', '#06b6d4', '#3b82f6', '#6366f1', 
    '#a855f7', '#ec4899', '#f43f5e', '#14b8a6', 
    '#000000', '#ffffff'
  ];

  static const List<TeamPattern> patterns = [
    TeamPattern.vertical,
    TeamPattern.horizontal,
    TeamPattern.diagonal,
  ];

  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}
