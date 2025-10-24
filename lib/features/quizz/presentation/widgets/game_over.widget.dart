import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  final int score;
  final VoidCallback startNewGame;

  const GameOver({super.key, required this.score, required this.startNewGame});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Game Over', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('Score final: $score', style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 32),
          ElevatedButton(onPressed: startNewGame, child: const Text('Rejouer')),
        ],
      ),
    );
  }
}
