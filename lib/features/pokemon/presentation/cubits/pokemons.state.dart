import 'package:equatable/equatable.dart';
import 'package:pokedex_app/features/pokemon/domain/models/pokemon.model.dart';

abstract class PokemonsState extends Equatable {
  const PokemonsState();

  @override
  List<Object> get props => [];
}

class PokemonsInitial extends PokemonsState {}

class PokemonsLoading extends PokemonsState {}

class PokemonsLoaded extends PokemonsState {
  final List<Pokemon> pokemons;

  const PokemonsLoaded(this.pokemons);

  @override
  List<Object> get props => [pokemons];
}

class PokemonsError extends PokemonsState {
  final String message;

  const PokemonsError(this.message);

  @override
  List<Object> get props => [message];
}
