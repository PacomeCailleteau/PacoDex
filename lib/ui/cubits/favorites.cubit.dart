import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/data/api/favorites.service.dart';
import 'package:pokedex_app/data/api/pokemon.service.dart';
import 'package:pokedex_app/data/model/pokemon.model.dart';
import 'package:pokedex_app/ui/cubits/favorites.state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesService _favoritesService;
  final PokemonService _pokemonService;

  List<Pokemon> _fullPokemonList = [];

  FavoritesCubit(this._favoritesService, this._pokemonService) : super(FavoritesInitial());

  Future<void> _loadFullPokemonList() async {
    try {
      if (_fullPokemonList.isEmpty) {
        _fullPokemonList = await _pokemonService.getAll();
      }
    } catch (e) {
      emit(FavoritesError("Erreur chargement des données Pokémon: ${e.toString()}"));
    }
  }

  Future<void> fetchFavoritePokemons() async {
    emit(FavoritesLoading());
    try {
      await _loadFullPokemonList();
      if (_fullPokemonList.isEmpty && state is! FavoritesError) {
        emit(FavoritesError("La liste des Pokémon n\'a pas pu être chargée."));
        return;
      }

      final favoriteIds = await _favoritesService.getFavoriteIds();
      final pokemons = _fullPokemonList.where((p) => favoriteIds.contains(p.id)).toList();

      final favoritePokemons = [
        for (final pokemon in pokemons) pokemon.copyWith(isFavorite: true)
      ];

      emit(FavoritesLoaded(favoritePokemons));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> toggleFavorite(Pokemon pokemon) async {
    await _favoritesService.toggleFavorite(pokemon.id);
    await fetchFavoritePokemons();
  }
}
