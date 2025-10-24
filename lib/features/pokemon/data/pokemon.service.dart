import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/features/pokemon/domain/models/pokemon.model.dart';
import 'package:pokedex_app/features/pokemon/domain/models/pokemon.type.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonService {
  static const String _frenchApiBaseUrl = 'https://pokebuildapi.fr/api/v1';
  static const String _internationalApiBaseUrl = 'https://pokeapi.co/api/v2';

  Future<String> _getCached(String url, String cacheKey) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        await prefs.setString(cacheKey, response.body);
        print("Fetched and cached from $url");
        return response.body;
      } else {
        throw Exception('API returned status ${response.statusCode}');
      }
    } catch (e) {
      print("Network failed for $url: $e. Trying cache.");
      final cachedResponse = prefs.getString(cacheKey);
      if (cachedResponse != null) {
        print("Loaded from cache for key $cacheKey");
        return cachedResponse;
      } else {
        throw Exception(
            'Failed to fetch data and no cache is available. Please check your connection.');
      }
    }
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith('api_cache_') || key.startsWith('pokemon_details_cache_')) {
        await prefs.remove(key);
      }
    }
    print("API cache cleared.");
  }

  Future<Pokemon> getPokemon(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'pokemon_details_cache_$query';

    try {
      final frenchResponse =
          await http.get(Uri.parse('$_frenchApiBaseUrl/pokemon/$query'));
      if (frenchResponse.statusCode != 200) {
        throw Exception('Failed to load base pokemon data');
      }

      final frenchData = json.decode(frenchResponse.body);
      Pokemon pokemon = Pokemon.fromJson(frenchData);

      try {
        final internationalResponse = await http.get(
            Uri.parse('$_internationalApiBaseUrl/pokemon-species/${pokemon.id}'));
        final internationalData = json.decode(internationalResponse.body);

        final flavorTextEntry = (internationalData['flavor_text_entries'] as List)
            .firstWhere((entry) => entry['language']['name'] == 'fr',
                orElse: () => null);
        final flavorText = flavorTextEntry != null
            ? flavorTextEntry['flavor_text'].replaceAll('\n', ' ')
            : null;

        final pokeApiResponse = await http
            .get(Uri.parse('$_internationalApiBaseUrl/pokemon/${pokemon.id}'));
        final pokeApiData = json.decode(pokeApiResponse.body);

        final height = (pokeApiData['height'] / 10).toString() + ' m';
        final weight = (pokeApiData['weight'] / 10).toString() + ' kg';
        final cry = pokeApiData['cries']?['latest'];

        pokemon = pokemon.copyWith(
          height: height,
          weight: weight,
          flavorText: flavorText,
          cry: cry,
        );
      } catch (e) {
        print("Could not fetch international data for ${pokemon.name}: $e");
      }

      final pokemonJsonString = json.encode(pokemon.toJson());
      await prefs.setString(cacheKey, pokemonJsonString);

      return pokemon;
    } catch (e) {
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        return Pokemon.fromJson(json.decode(cachedData));
      } else {
        throw Exception(
            'Failed to load pokemon $query and no cache is available.');
      }
    }
  }

  Future<List<Pokemon>> getAll() async {
    final url = '$_frenchApiBaseUrl/pokemon';
    final cacheKey = 'api_cache_all_pokemons';

    final responseBody = await _getCached(url, cacheKey);
    final List<dynamic> data = json.decode(responseBody);
    return data.map((json) => Pokemon.fromJson(json)).toList();
  }

  Future<List<Pokemon>> getByGeneration(int generation) async {
    final url = '$_frenchApiBaseUrl/pokemon/generation/$generation';
    final cacheKey = 'api_cache_gen_$generation';

    final responseBody = await _getCached(url, cacheKey);
    final List<dynamic> data = json.decode(responseBody);
    return data.map((json) => Pokemon.fromJson(json)).toList();
  }

  Future<List<Pokemon>> getByType(String type) async {
    final url = '$_frenchApiBaseUrl/pokemon/type/$type';
    final cacheKey = 'api_cache_type_$type';

    final responseBody = await _getCached(url, cacheKey);
    final List<dynamic> data = json.decode(responseBody);
    return data.map((json) => Pokemon.fromJson(json)).toList();
  }

  Future<List<PokemonType>> getTypes() async {
    final url = '$_frenchApiBaseUrl/types';
    final cacheKey = 'api_cache_all_types';

    final responseBody = await _getCached(url, cacheKey);
    final List<dynamic> data = json.decode(responseBody);
    return data.map((json) => PokemonType.fromJson(json)).toList();
  }
}
