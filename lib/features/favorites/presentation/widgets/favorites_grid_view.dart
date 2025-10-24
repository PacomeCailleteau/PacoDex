import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pokedex_app/features/favorites/presentation/cubits/favorites.cubit.dart';
import 'package:pokedex_app/features/pokemon/domain/models/pokemon.model.dart';
import 'package:pokedex_app/features/pokemon/presentation/pages/pokemon_details.page.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/pokemon_card.widget.dart';

class FavoritesGridView extends StatelessWidget {
  final List<Pokemon> pokemons;

  const FavoritesGridView({super.key, required this.pokemons, required bool isLoading});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final crossAxisCount = width > 800 ? 3 : 2;
    const horizontalPadding = 16.0;
    const crossSpacing = 14.0;

    final cardWidth = (width - (horizontalPadding * 2) - crossSpacing * (crossAxisCount - 1)) / crossAxisCount;
    final desiredHeight = cardWidth * 0.68;
    final aspectRatio = cardWidth / desiredHeight;

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
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PokemonDetailsPage(pokemon: pokemon),
                      ),
                    );
                    if (!context.mounted) return;
                    context.read<FavoritesCubit>().fetchFavoritePokemons();
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
