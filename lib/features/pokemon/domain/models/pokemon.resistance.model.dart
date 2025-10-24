import 'package:json_annotation/json_annotation.dart';

part 'pokemon.resistance.model.g.dart';

@JsonSerializable()
class PokemonResistance {
  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: 1.0)
  final double damage_multiplier;

  @JsonKey(defaultValue: '')
  final String damage_relation;

  PokemonResistance({
    required this.name,
    required this.damage_multiplier,
    required this.damage_relation,
  });

  factory PokemonResistance.fromJson(Map<String, dynamic> json) => _$PokemonResistanceFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonResistanceToJson(this);
}
