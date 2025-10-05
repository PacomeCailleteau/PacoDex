import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/data/api/favorites.service.dart';
import 'package:pokedex_app/data/api/pokemon.service.dart';
import 'package:pokedex_app/data/model/pokemon.model.dart';
import 'package:pokedex_app/ui/cubits/pokemons.state.dart';

class PokemonQuiz {
  final Pokemon correctPokemon;
  final List<Pokemon> options;

  PokemonQuiz({required this.correctPokemon, required this.options});
}


enum FetchType { generation, type, favorites }

class PokemonsCubit extends Cubit<PokemonsState> {
  final PokemonService _pokemonService;
  final FavoritesService _favoritesService;

  List<Pokemon> _fullPokemonList = [];
  List<Pokemon> _pokemonsForCurrentFilter = [];

  FetchType _lastFetchType = FetchType.generation;
  int _lastGeneration = 1;
  String _lastType = '';

  FetchType get lastFetchType => _lastFetchType;
  int get lastGeneration => _lastGeneration;

  PokemonsCubit(this._pokemonService, this._favoritesService) : super(PokemonsInitial()) {
    _loadFullPokemonList();
  }

  Future<void> _loadFullPokemonList() async {
    try {
      _fullPokemonList = await _pokemonService.getAll();
    } catch (e) {
      emit(PokemonsError(e.toString()));
    }
  }

  Future<void> fetchPokemonsByGeneration(int generation) async {
    _lastFetchType = FetchType.generation;
    _lastGeneration = generation;
    emit(PokemonsLoading());
    try {
      final pokemons = await _pokemonService.getByGeneration(generation);
      _pokemonsForCurrentFilter = pokemons;
      emit(PokemonsLoaded(pokemons));
    } catch (e) {
      emit(PokemonsError(e.toString()));
    }
  }

  Future<void> fetchPokemonsByType(String type) async {
    _lastFetchType = FetchType.type;
    _lastType = type;
    emit(PokemonsLoading());
    try {
      final pokemons = await _pokemonService.getByType(type);
      _pokemonsForCurrentFilter = pokemons;
      emit(PokemonsLoaded(pokemons));
    } catch (e) {
      emit(PokemonsError(e.toString()));
    }
  }

  Future<void> fetchFavoritePokemons() async {
    _lastFetchType = FetchType.favorites;
    emit(PokemonsLoading());
    try {
      final pokemons = await _favoritesService.getFavoritePokemons();
      _pokemonsForCurrentFilter = pokemons;
      emit(PokemonsLoaded(pokemons));
    } catch (e) {
      emit(PokemonsError(e.toString()));
    }
  }

  Future<void> refreshCurrentView() async {
    if (state is PokemonsLoading) return;

    if (_lastFetchType == FetchType.favorites) {
      await fetchFavoritePokemons();
    } else if (_lastFetchType == FetchType.generation) {
      await fetchPokemonsByGeneration(_lastGeneration);
    } else if (_lastFetchType == FetchType.type) {
      await fetchPokemonsByType(_lastType);
    }
  }

  void searchPokemons(String query) {
    if (query.isEmpty) {
      emit(PokemonsLoaded(_pokemonsForCurrentFilter));
      return;
    }

    final lowerCaseQuery = query.toLowerCase();
    final results = _fullPokemonList.where((pokemon) {
      final formattedPokedexId = pokemon.pokedexId.toString().padLeft(3, '0');
      return pokemon.name.toLowerCase().contains(lowerCaseQuery) ||
          formattedPokedexId.contains(lowerCaseQuery);
    }).toList();

    emit(PokemonsLoaded(results));
  }

  Pokemon? getRandomPokemon() {
    if (_fullPokemonList.isEmpty) return null;
    final random = Random();
    return _fullPokemonList[random.nextInt(_fullPokemonList.length)];
  }

  PokemonQuiz? getPokemonQuiz() {
    if (_fullPokemonList.length < 4) return null;
    final random = Random();
    final options = <Pokemon>[];
    while (options.length < 4) {
      final randomPokemon = _fullPokemonList[random.nextInt(_fullPokemonList.length)];
      if (!options.contains(randomPokemon)) {
        options.add(randomPokemon);
      }
    }
    final correctPokemon = options[random.nextInt(4)];
    options.shuffle();
    return PokemonQuiz(correctPokemon: correctPokemon, options: options);
  }
}
