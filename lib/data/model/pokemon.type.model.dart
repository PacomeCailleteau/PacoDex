import 'package:json_annotation/json_annotation.dart';

part 'pokemon.type.model.g.dart';

@JsonSerializable()
class PokemonType {
  const PokemonType({
    required this.name,
    required this.image,
  });

  final String name;
  final String image;

  factory PokemonType.fromJson(Map<String, dynamic> json) => _$PokemonTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonTypeToJson(this);

  static PokemonType mock() => PokemonType(
        name: 'water',
        image: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
      );
}
