import 'package:pokedex_app/features/pokemon/data/pokemon.service.dart';
import 'package:pokedex_app/features/pokemon/domain/models/pokemon.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _favoritesKey = 'favorite_pokemons';

  Future<List<int>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_favoritesKey) ?? [];
    return favoriteIds.map(int.parse).toList();
  }

  Future<bool> isFavorite(int pokemonId) async {
    final favoriteIds = await getFavoriteIds();
    return favoriteIds.contains(pokemonId);
  }

  Future<void> toggleFavorite(int pokemonId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = await getFavoriteIds();

    if (favoriteIds.contains(pokemonId)) {
      favoriteIds.remove(pokemonId);
    } else {
      favoriteIds.add(pokemonId);
    }

    await prefs.setStringList(_favoritesKey, favoriteIds.map((id) => id.toString()).toList());
  }

  Future<List<Pokemon>> getFavoritePokemons() async {
    final favoriteIds = await getFavoriteIds();
    if (favoriteIds.isEmpty) {
      return [];
    }

    final pokemonService = PokemonService();
    final allPokemons = await pokemonService.getAll();
    return allPokemons.where((pokemon) => favoriteIds.contains(pokemon.id)).toList();
  }
}
