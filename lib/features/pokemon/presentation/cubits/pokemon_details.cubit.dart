import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/features/favorites/data/favorites.service.dart';
import 'package:pokedex_app/features/pokemon/data/pokemon.service.dart';
import 'package:pokedex_app/features/pokemon/domain/models/pokemon.model.dart';
import 'package:pokedex_app/features/pokemon/presentation/cubits/pokemon_details.state.dart';

class PokemonDetailsCubit extends Cubit<PokemonDetailsState> {
  final PokemonService _pokemonService;
  final FavoritesService _favoritesService;

  PokemonDetailsCubit(this._pokemonService, this._favoritesService) : super(PokemonDetailsInitial());

  Future<void> loadPokemonDetails(Pokemon basePokemon) async {
    emit(PokemonDetailsLoading());
    try {
      final detailedPokemon = await _pokemonService.getPokemon(basePokemon.id.toString());
      final favoriteIds = await _favoritesService.getFavoriteIds();

      Pokemon? preEvolution;
      if (detailedPokemon.apiPreEvolution != null) {
        preEvolution = await _pokemonService.getPokemon(detailedPokemon.apiPreEvolution!.pokedexId.toString());
      }

      List<Pokemon> evolutions = [];
      if (detailedPokemon.apiEvolutions.isNotEmpty) {
        final evolutionFutures = detailedPokemon.apiEvolutions.map((e) => _pokemonService.getPokemon(e.pokedexId.toString()));
        evolutions = await Future.wait(evolutionFutures);
      }

      final finalPokemon = detailedPokemon.copyWith(isFavorite: favoriteIds.contains(detailedPokemon.id));

      emit(PokemonDetailsLoaded(
        pokemon: finalPokemon,
        preEvolution: preEvolution,
        evolutions: evolutions,
      ));
    } catch (e) {
      emit(PokemonDetailsError(e.toString()));
    }
  }

  Future<void> toggleFavorite() async {
    if (state is PokemonDetailsLoaded) {
      final loadedState = state as PokemonDetailsLoaded;
      final currentPokemon = loadedState.pokemon;
      
      await _favoritesService.toggleFavorite(currentPokemon.id);

      final updatedPokemon = currentPokemon.copyWith(isFavorite: !currentPokemon.isFavorite);
      emit(PokemonDetailsLoaded(
        pokemon: updatedPokemon,
        preEvolution: loadedState.preEvolution,
        evolutions: loadedState.evolutions,
      ));
    }
  }
}
