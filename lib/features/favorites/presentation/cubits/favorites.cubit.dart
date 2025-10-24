import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/features/favorites/data/favorites.service.dart';
import 'package:pokedex_app/features/favorites/presentation/cubits/favorites.state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesService _favoritesService;

  FavoritesCubit(this._favoritesService) : super(FavoritesInitial());

  Future<void> fetchFavoritePokemons() async {
    emit(FavoritesLoading());
    try {
      final favoriteIds = await _favoritesService.getFavoriteIds();
      emit(FavoritesLoaded(favoriteIds));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> toggleFavorite(int pokemonId) async {
    await _favoritesService.toggleFavorite(pokemonId);
    await fetchFavoritePokemons();
  }
}
