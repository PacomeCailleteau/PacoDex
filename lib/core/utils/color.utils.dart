import 'package:flutter/material.dart';

Color getColorForType(String type) {
  switch (type.toLowerCase()) {
    case 'normal':
      return const Color(0xFFA8A77A);
    case 'feu':
      return const Color(0xFFEE8130);
    case 'eau':
      return const Color(0xFF6390F0);
    case 'électrik':
      return const Color(0xFFF7D02C);
    case 'plante':
      return const Color(0xFF7AC74C);
    case 'glace':
      return const Color(0xFF96D9D6);
    case 'combat':
      return const Color(0xFFC22E28);
    case 'poison':
      return const Color(0xFFA33EA1);
    case 'sol':
      return const Color(0xFFE2BF65);
    case 'vol':
      return const Color(0xFFA98FF3);
    case 'psy':
      return const Color(0xFFF95587);
    case 'insecte':
      return const Color(0xFFA6B91A);
    case 'roche':
      return const Color(0xFFB6A136);
    case 'spectre':
      return const Color(0xFF735797);
    case 'dragon':
      return const Color(0xFF6F35FC);
    case 'ténèbres':
      return const Color(0xFF705746);
    case 'acier':
      return const Color(0xFFB7B7CE);
    case 'fée':
      return const Color(0xFFD685AD);
    default:
      return Colors.grey;
  }
}
