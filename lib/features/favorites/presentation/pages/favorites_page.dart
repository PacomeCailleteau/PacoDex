import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/features/favorites/data/favorites.service.dart';
import 'package:pokedex_app/features/favorites/presentation/cubits/favorites.cubit.dart';
import 'package:pokedex_app/features/favorites/presentation/cubits/favorites.state.dart';
import 'package:pokedex_app/core/widgets/empty_state.widget.dart';
import 'package:pokedex_app/features/favorites/presentation/widgets/favorites_grid_view.dart';
import 'package:pokedex_app/features/pokemon/presentation/cubits/pokemons.cubit.dart';
import 'package:pokedex_app/features/pokemon/presentation/cubits/pokemons.state.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late final FavoritesCubit _favoritesCubit;

  @override
  void initState() {
    super.initState();
    _favoritesCubit = FavoritesCubit(FavoritesService());
    _favoritesCubit.fetchFavoritePokemons();
  }

  @override
  void dispose() {
    _favoritesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes favoris'),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        bloc: _favoritesCubit,
        builder: (context, favoritesState) {
          return BlocBuilder<PokemonsCubit, PokemonsState>(
            builder: (context, pokemonsState) {
              if (favoritesState is FavoritesLoading || pokemonsState is PokemonsLoading) {
                return const FavoritesGridView(pokemons: [], isLoading: true);
              }

              if (favoritesState is FavoritesError) {
                return Center(child: Text(favoritesState.message));
              }

              if (pokemonsState is PokemonsError) {
                return Center(child: Text(pokemonsState.message));
              }

              if (favoritesState is FavoritesLoaded && pokemonsState is PokemonsLoaded) {
                final favoritePokemons = pokemonsState.pokemons
                    .where((pokemon) => favoritesState.pokemonIds.contains(pokemon.id))
                    .toList();

                if (favoritePokemons.isEmpty) {
                  return const EmptyStateWidget(
                    message:
                        'Vous n\'avez pas encore de Pokémon favoris. Appuyez sur le cœur dans les détails d\'un Pokémon pour l\'ajouter ici !',
                  );
                }

                return FavoritesGridView(pokemons: favoritePokemons, isLoading: true);
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
