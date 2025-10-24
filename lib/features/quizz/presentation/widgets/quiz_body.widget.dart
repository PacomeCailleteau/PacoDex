import 'package:flutter/material.dart';
import 'package:pokedex_app/features/pokemon/presentation/cubits/pokemons.cubit.dart';
import 'package:pokedex_app/features/quizz/presentation/widgets/game_over.widget.dart';
import 'package:pokedex_app/features/quizz/presentation/widgets/pokemon_image.widget.dart';
import 'package:pokedex_app/features/quizz/presentation/widgets/options_grid.widget.dart';

import '../../../pokemon/domain/models/pokemon.model.dart';

class QuizBody extends StatelessWidget {
  final PokemonQuiz? currentQuiz;
  final bool isGameOver;
  final int score;
  final VoidCallback startNewGame;
  final bool answered;
  final Function(Pokemon) handleAnswer;
  final Pokemon? selectedPokemon;


  const QuizBody({
    super.key,
    required this.currentQuiz,
    required this.isGameOver,
    required this.score,
    required this.startNewGame,
    required this.answered,
    required this.handleAnswer,
    required this.selectedPokemon,
  });

  @override
  Widget build(BuildContext context) {
    if (isGameOver) {
      return GameOver(score: score, startNewGame: startNewGame);
    }
    if (currentQuiz == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PokemonImage(answered: answered, pokemon: currentQuiz!.correctPokemon),
          OptionsGrid(currentQuiz: currentQuiz, handleAnswer: handleAnswer, answered: answered, selectedPokemon: selectedPokemon),
        ],
      ),
    );
  }
}
