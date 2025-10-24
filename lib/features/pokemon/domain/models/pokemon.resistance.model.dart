import 'package:json_annotation/json_annotation.dart';

part 'pokemon.resistance.model.g.dart';

@JsonSerializable()
class PokemonResistance {
  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: 1.0, name: 'damage_multiplier')
  final double damageMultiplier;

  @JsonKey(defaultValue: '', name: 'damage_relation')
  final String damageRelation;

  PokemonResistance({
    required this.name,
    required this.damageMultiplier,
    required this.damageRelation,
  });

  factory PokemonResistance.fromJson(Map<String, dynamic> json) => _$PokemonResistanceFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonResistanceToJson(this);
}
