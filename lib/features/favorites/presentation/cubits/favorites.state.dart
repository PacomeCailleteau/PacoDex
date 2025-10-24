sealed class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<int> pokemonIds;

  FavoritesLoaded(this.pokemonIds);
}

class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError(this.message);
}
