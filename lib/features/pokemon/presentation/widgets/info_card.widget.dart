import 'package:flutter/material.dart';

class InfoPokemonCard extends StatelessWidget {
  final String label;
  final String value;

  const InfoPokemonCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
