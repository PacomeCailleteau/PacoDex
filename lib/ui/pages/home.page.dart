import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pokedex_app/data/model/pokemon.model.dart';
import 'package:pokedex_app/ui/cubits/pokemons.cubit.dart';
import 'package:pokedex_app/ui/cubits/pokemons.state.dart';
import 'package:pokedex_app/ui/modals/pokemon_generations.dialog.dart';
import 'package:pokedex_app/ui/modals/pokemon_search.dialog.dart';
import 'package:pokedex_app/ui/modals/pokemon_types.dialog.dart';
import 'package:pokedex_app/ui/pages/favorites_page.dart';
import 'package:pokedex_app/ui/pages/pokemon_details.page.dart';
import 'package:pokedex_app/ui/pages/pokemon_quiz.page.dart';
import 'package:pokedex_app/ui/pages/settings_page.dart';
import 'package:pokedex_app/ui/widgets/empty_state.widget.dart';
import 'package:pokedex_app/ui/widgets/pokemon_card_skeleton.widget.dart';

import '../widgets/pokemon_card.widget.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<PokemonsCubit>().fetchPokemonsByGeneration(1);
  }

  void _goToRandomPokemon() {
    final randomPokemon = context.read<PokemonsCubit>().getRandomPokemon();
    if (randomPokemon != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PokemonDetailsPage(pokemon: randomPokemon),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PokemonsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => cubit.fetchPokemonsByGeneration(1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                    'assets/images/pacodex_logo.png', height: 32),
              ),
              const SizedBox(width: 12),
              Text(widget.title),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            tooltip: 'Paramètres',
          ),
        ],
      ),
      body: BlocBuilder<PokemonsCubit, PokemonsState>(
        builder: (context, state) {
          if (state is PokemonsLoading || state is PokemonsInitial) {
            return _buildGridView(context, [], isLoading: true);
          }
          if (state is PokemonsLoaded) {
            if (state.pokemons.isEmpty) {
              return const EmptyStateWidget(
                message: 'Aucun Pokémon trouvé pour cette recherche.',
              );
            }
            return _buildGridView(context, state.pokemons);
          }
          if (state is PokemonsError) {
            return Center(child: Text(state.message));
          }
          return _buildGridView(context, [], isLoading: true);
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildGridView(BuildContext context, List<Pokemon> pokemons, {bool isLoading = false}) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final crossAxisCount = width > 800 ? 3 : 2;
    const horizontalPadding = 16.0;
    const crossSpacing = 14.0;

    final cardWidth = (width - (horizontalPadding * 2) - crossSpacing * (crossAxisCount - 1)) / crossAxisCount;
    final desiredHeight = cardWidth * 0.68;
    final aspectRatio = cardWidth / desiredHeight;

    if (isLoading) {
      return GridView.builder(
        padding: const EdgeInsets.all(horizontalPadding),
        itemCount: 12,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossSpacing,
          mainAxisSpacing: 0.0,
          childAspectRatio: aspectRatio,
        ),
        itemBuilder: (context, index) {
          return const PokemonCardSkeleton();
        },
      );
    }

    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.all(horizontalPadding),
        itemCount: pokemons.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossSpacing,
          mainAxisSpacing: 0.0,
          childAspectRatio: aspectRatio,
        ),
        itemBuilder: (context, index) {
          final pokemon = pokemons[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: crossAxisCount,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: PokemonCardWidget(
                  pokemon: pokemon,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PokemonDetailsPage(pokemon: pokemon),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
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
            onTap: _goToRandomPokemon,
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
                  builder: (_) => BlocProvider.value(
                    value: context.read<PokemonsCubit>(),
                    child: const FavoritesPage(),
                  ),
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
