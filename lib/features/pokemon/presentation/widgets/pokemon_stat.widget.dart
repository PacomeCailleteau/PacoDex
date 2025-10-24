import 'package:flutter/material.dart';

class PokemonStatWidget extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color color;

  const PokemonStatWidget({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double ratio = value / maxValue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              value.toString(),
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: ratio,
                backgroundColor: color.withOpacity(0.2),
                color: color,
                minHeight: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
