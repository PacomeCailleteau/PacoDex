import 'package:pokedex_app/features/pokemon/domain/models/pokemon.model.dart';

sealed class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Pokemon> pokemons;

  FavoritesLoaded(this.pokemons);
}

class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError(this.message);
}
