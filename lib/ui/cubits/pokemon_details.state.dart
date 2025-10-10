import 'package:pokedex_app/data/model/pokemon.model.dart';

sealed class PokemonDetailsState {}

class PokemonDetailsInitial extends PokemonDetailsState {}

class PokemonDetailsLoading extends PokemonDetailsState {}

class PokemonDetailsLoaded extends PokemonDetailsState {
  final Pokemon pokemon;
  final Pokemon? preEvolution;
  final List<Pokemon> evolutions;

  PokemonDetailsLoaded({
    required this.pokemon,
    this.preEvolution,
    this.evolutions = const [],
  });
}

class PokemonDetailsError extends PokemonDetailsState {
  final String message;

  PokemonDetailsError(this.message);
}
