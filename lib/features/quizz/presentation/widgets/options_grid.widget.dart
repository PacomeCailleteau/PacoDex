import 'package:flutter/material.dart';
import 'package:pokedex_app/features/pokemon/domain/models/pokemon.model.dart';
import 'package:pokedex_app/features/pokemon/presentation/cubits/pokemons.cubit.dart';

class OptionsGrid extends StatelessWidget {
  final PokemonQuiz? currentQuiz;
  final Function(Pokemon) handleAnswer;
  final bool answered;
  final Pokemon? selectedPokemon;


  const OptionsGrid({
    super.key,
    required this.currentQuiz,
    required this.handleAnswer,
    required this.answered,
    required this.selectedPokemon,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        final pokemon = currentQuiz!.options[index];
        return ElevatedButton(
          onPressed: () => handleAnswer(pokemon),
          style: ElevatedButton.styleFrom(
            backgroundColor: _getButtonColor(pokemon),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              pokemon.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Color? _getButtonColor(Pokemon pokemon) {
    if (!answered) {
      return Colors.blue;
    }
    if (pokemon == currentQuiz!.correctPokemon) {
      return Colors.green;
    }
    if (pokemon == selectedPokemon) {
      return Colors.red;
    }
    return Colors.grey.withOpacity(0.5);
  }
}
