import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/data/model/pokemon.model.dart';
import 'package:pokedex_app/data/model/pokemon.type.model.dart';

class PokemonService {
  static const String _frenchApiBaseUrl = 'https://pokebuildapi.fr/api/v1';
  static const String _internationalApiBaseUrl = 'https://pokeapi.co/api/v2';

  List<Pokemon>? _allPokemonsCache;

  Future<Pokemon> getPokemon(String query) async {
    final frenchResponse = await http.get(Uri.parse('$_frenchApiBaseUrl/pokemon/$query'));
    if (frenchResponse.statusCode != 200) {
      throw Exception('Failed to load pokemon: $query');
    }

    final frenchData = json.decode(frenchResponse.body);
    Pokemon pokemon = Pokemon.fromJson(frenchData);

    try {
      final internationalResponse = await http.get(Uri.parse('$_internationalApiBaseUrl/pokemon-species/${pokemon.id}'));
      final internationalData = json.decode(internationalResponse.body);

      final flavorTextEntry = (internationalData['flavor_text_entries'] as List)
          .firstWhere((entry) => entry['language']['name'] == 'fr', orElse: () => null);
      final flavorText = flavorTextEntry != null ? flavorTextEntry['flavor_text'].replaceAll('\n', ' ') : null;

      final pokeApiResponse = await http.get(Uri.parse('$_internationalApiBaseUrl/pokemon/${pokemon.id}'));
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

    return pokemon;
  }

  Future<List<Pokemon>> getAll() async {
    if (_allPokemonsCache != null) {
      return _allPokemonsCache!;
    }
    final response = await http.get(Uri.parse('$_frenchApiBaseUrl/pokemon/limit/1025'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _allPokemonsCache = data.map((json) => Pokemon.fromJson(json)).toList();
      return _allPokemonsCache!;
    } else {
      throw Exception('Failed to load pokemons');
    }
  }

  Future<List<Pokemon>> getByGeneration(int generation) async {
    final response = await http.get(Uri.parse('$_frenchApiBaseUrl/pokemon/generation/$generation'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Pokemon.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pokemons of generation $generation');
    }
  }

  Future<List<Pokemon>> getByType(String type) async {
    final response = await http.get(Uri.parse('$_frenchApiBaseUrl/pokemon/type/$type'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Pokemon.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pokemons of type $type');
    }
  }

  Future<List<PokemonType>> getTypes() async {
    final response = await http.get(Uri.parse('$_frenchApiBaseUrl/types'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PokemonType.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load types');
    }
  }
}
