import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/features/favorites/presentation/cubits/favorites.cubit.dart';
import 'package:pokedex_app/features/favorites/presentation/cubits/favorites.state.dart';
import 'package:pokedex_app/core/widgets/empty_state.widget.dart';
import 'package:pokedex_app/features/favorites/presentation/widgets/favorites_grid_view.dart';

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
              const FavoritesGridView(pokemons: [], isLoading: true),
            FavoritesError(message: final message) =>
              Center(child: Text(message)),
            FavoritesLoaded(pokemons: final pokemons) =>
              pokemons.isEmpty
                  ? const EmptyStateWidget(
                      message:
                          'Vous n\'avez pas encore de Pokémon favoris. Appuyez sur le cœur dans les détails d\'un Pokémon pour l\'ajouter ici !',
                    )
                  : FavoritesGridView(pokemons: pokemons),
          };
        },
      ),
    );
  }
}
