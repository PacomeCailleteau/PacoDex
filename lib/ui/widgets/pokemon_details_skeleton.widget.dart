import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PokemonDetailsSkeleton extends StatelessWidget {
  const PokemonDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 200, height: 32, color: Colors.white),
                const Spacer(),
                Container(width: 50, height: 24, color: Colors.white),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Container(width: 80, height: 28, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
                const SizedBox(width: 8),
                Container(width: 80, height: 28, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
              ],
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [Container(width: 50, height: 16, color: Colors.white), const SizedBox(height: 8), Container(width: 80, height: 20, color: Colors.white)]),
                Column(children: [Container(width: 50, height: 16, color: Colors.white), const SizedBox(height: 8), Container(width: 80, height: 20, color: Colors.white)]),
              ],
            ),
            const SizedBox(height: 32),

            Container(width: 120, height: 20, color: Colors.white),
            const SizedBox(height: 16),
            Container(width: double.infinity, height: 16, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: double.infinity, height: 16, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: 150, height: 16, color: Colors.white),
            const SizedBox(height: 32),

            Container(width: 120, height: 20, color: Colors.white),
            const SizedBox(height: 16),
            ...List.generate(6, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(width: 70, height: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  Container(width: 40, height: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Container(height: 10, color: Colors.white)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
