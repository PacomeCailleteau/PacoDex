import 'package:json_annotation/json_annotation.dart';

part 'pokemon_ref.model.g.dart';

@JsonSerializable(createFactory: false)
class PokemonRef {
  final String name;
  final int pokedexId;

  PokemonRef({
    required this.name,
    required this.pokedexId,
  });

  factory PokemonRef.fromJson(Map<String, dynamic> json) {
    return PokemonRef(
      name: json['name'] as String? ?? '',
      pokedexId: json['pokedexIdd'] as int? ?? json['pokedexId'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => _$PokemonRefToJson(this);

  static PokemonRef mock() => PokemonRef(
        name: 'Pokémock',
        pokedexId: 999,
      );
}
