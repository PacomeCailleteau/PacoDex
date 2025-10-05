import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PokemonCardSkeleton extends StatelessWidget {
  const PokemonCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 56,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              width: 100,
              height: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
