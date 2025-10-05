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


enum FetchType { generation, type, favorites, search }

class PokemonsCubit extends Cubit<PokemonsState> {
  final PokemonService _pokemonService;
  final FavoritesService _favoritesService;

  List<Pokemon> _fullPokemonList = [];
  List<Pokemon> _pokemonsForCurrentFilter = [];

  FetchType _lastFetchType = FetchType.generation;
  int _lastGeneration = 1;
  String _lastType = '';
  String _lastSearchQuery = '';

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

  Future<List<Pokemon>> _applyFavoritesStatus(List<Pokemon> pokemons) async {
    final favoriteIds = await _favoritesService.getFavoriteIds();
    return [
      for (final pokemon in pokemons)
        pokemon.copyWith(isFavorite: favoriteIds.contains(pokemon.id))
    ];
  }

  Future<void> fetchPokemonsByGeneration(int generation) async {
    _lastFetchType = FetchType.generation;
    _lastGeneration = generation;
    emit(PokemonsLoading());
    try {
      var pokemons = await _pokemonService.getByGeneration(generation);
      pokemons = await _applyFavoritesStatus(pokemons);
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
      var pokemons = await _pokemonService.getByType(type);
      pokemons = await _applyFavoritesStatus(pokemons);
      _pokemonsForCurrentFilter = pokemons;
      emit(PokemonsLoaded(pokemons));
    } catch (e) {
      emit(PokemonsError(e.toString()));
    }
  }

  Future<void> fetchFavoritePokemons() async {
    emit(PokemonsLoading());
    try {
      final favoriteIds = await _favoritesService.getFavoriteIds();
      final pokemons = _fullPokemonList.where((p) => favoriteIds.contains(p.id)).toList();
      final favoritePokemons = await _applyFavoritesStatus(pokemons);
      // Do not update the _pokemonsForCurrentFilter here, as this is a separate view
      emit(PokemonsLoaded(favoritePokemons));
    } catch (e) {
      emit(PokemonsError(e.toString()));
    }
  }

  Future<void> refreshCurrentView() async {
    if (state is PokemonsLoading) return;

    switch (_lastFetchType) {
      // No 'favorites' case here, because we don't want to change the main screen's state
      case FetchType.generation:
        await fetchPokemonsByGeneration(_lastGeneration);
        break;
      case FetchType.type:
        await fetchPokemonsByType(_lastType);
        break;
      case FetchType.search:
        await searchPokemons(_lastSearchQuery);
        break;
      default:
        await fetchPokemonsByGeneration(1); // Fallback to the default view
    }
  }

  Future<void> searchPokemons(String query) async {
    if (query.isEmpty) {
      await refreshCurrentView();
      return;
    }

    _lastFetchType = FetchType.search;
    _lastSearchQuery = query;
    emit(PokemonsLoading());

    final lowerCaseQuery = query.toLowerCase();
    var results = _fullPokemonList.where((pokemon) {
      final formattedPokedexId = pokemon.pokedexId.toString().padLeft(3, '0');
      return pokemon.name.toLowerCase().contains(lowerCaseQuery) ||
          formattedPokedexId.contains(lowerCaseQuery);
    }).toList();

    results = await _applyFavoritesStatus(results);
    _pokemonsForCurrentFilter = results;

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

  Future<void> toggleFavorite(Pokemon pokemon) async {
    await _favoritesService.toggleFavorite(pokemon.id);
    final updatedPokemons = await _applyFavoritesStatus(_pokemonsForCurrentFilter);
    _pokemonsForCurrentFilter = updatedPokemons;
    emit(PokemonsLoaded(updatedPokemons));
  }
}
