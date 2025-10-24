import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pokedex_app/features/favorites/presentation/pages/favorites_page.dart';
import 'package:pokedex_app/features/pokemon/presentation/cubits/pokemons.cubit.dart';
import 'package:pokedex_app/features/pokemon/presentation/modals/pokemon_generations.dialog.dart';
import 'package:pokedex_app/features/pokemon/presentation/modals/pokemon_search.dialog.dart';
import 'package:pokedex_app/features/pokemon/presentation/modals/pokemon_types.dialog.dart';
import 'package:pokedex_app/features/quizz/presentation/pages/pokemon_quiz.page.dart';

class HomeFloatingActionButton extends StatelessWidget {
  final VoidCallback goToRandomPokemon;

  const HomeFloatingActionButton({super.key, required this.goToRandomPokemon});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
        icon: Icons.filter_list,
        activeIcon: Icons.close,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.blueGrey,
        activeForegroundColor: Colors.white,
        buttonSize: const Size(56.0, 56.0),
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.casino),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            label: 'Pokémon au hasard',
            onTap: goToRandomPokemon,
          ),
          SpeedDialChild(
            child: const Icon(Icons.gamepad),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            label: 'Quel est ce Pokémon ?',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<PokemonsCubit>(),
                    child: const PokemonQuizPage(),
                  ),
                ),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.favorite),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Favoris',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesPage(),
                ),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.catching_pokemon),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Tous les types',
            onTap: () async {
              final selectedType = await showModalBottomSheet<String>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                builder: (BuildContext context) {
                  return const PokemonTypesDialog();
                },
              );

              if (!context.mounted) return;

              if (selectedType != null) {
                context.read<PokemonsCubit>().fetchPokemonsByType(selectedType);
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.catching_pokemon),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            label: 'Toutes les générations',
            onTap: () async {
              final selectedGeneration = await showModalBottomSheet<int>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                builder: (BuildContext context) {
                  return const PokemonGenerationsDialog();
                },
              );

              if (!context.mounted) return;

              if (selectedGeneration != null) {
                context.read<PokemonsCubit>().fetchPokemonsByGeneration(selectedGeneration);
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.search),
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            label: 'Rechercher',
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                builder: (BuildContext innerContext) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(innerContext).viewInsets.bottom),
                    child: PokemonSearchDialog(
                        onSearch: (query) => context.read<PokemonsCubit>().searchPokemons(query)),
                  );
                },
              );
            },
          ),
        ]);
  }
}
