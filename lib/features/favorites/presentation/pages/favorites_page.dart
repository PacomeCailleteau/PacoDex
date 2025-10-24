import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pokedex_app/features/pokemon/domain/models/pokemon.model.dart';
import 'package:pokedex_app/features/favorites/presentation/cubits/favorites.cubit.dart';
import 'package:pokedex_app/features/favorites/presentation/cubits/favorites.state.dart';
import 'package:pokedex_app/core/widgets/empty_state.widget.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/pokemon_card.widget.dart';
import 'package:pokedex_app/features/pokemon/presentation/pages/pokemon_details.page.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/pokemon_card_skeleton.widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().fetchFavoritePokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes favoris'),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          return switch (state) {
            FavoritesInitial() ||
            FavoritesLoading() =>
              _buildGridView(context, [], isLoading: true),
            FavoritesError(message: final message) =>
              Center(child: Text(message)),
            FavoritesLoaded(pokemons: final pokemons) =>
              pokemons.isEmpty
                  ? const EmptyStateWidget(
                      message:
                          'Vous n\'avez pas encore de Pokémon favoris. Appuyez sur le cœur dans les détails d\'un Pokémon pour l\'ajouter ici !',
                    )
                  : _buildGridView(context, pokemons),
          };
        },
      ),
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
                    ).then((_) => context.read<FavoritesCubit>().fetchFavoritePokemons());
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
