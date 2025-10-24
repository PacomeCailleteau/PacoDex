import 'package:json_annotation/json_annotation.dart';

part 'pokemon.stats.model.g.dart';

@JsonSerializable()
class PokemonStats {
  @JsonKey(name: 'HP', defaultValue: 0)
  final int hp;
  @JsonKey(defaultValue: 0)
  final int attack;
  @JsonKey(defaultValue: 0)
  final int defense;
  @JsonKey(name: 'special_attack', defaultValue: 0)
  final int specialAttack;
  @JsonKey(name: 'special_defense', defaultValue: 0)
  final int specialDefense;
  @JsonKey(defaultValue: 0)
  final int speed;

  PokemonStats({
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
  });

  factory PokemonStats.fromJson(Map<String, dynamic> json) => _$PokemonStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonStatsToJson(this);

  static PokemonStats mock() => PokemonStats(
        hp: 10,
        attack: 20,
        defense: 30,
        specialAttack: 40,
        specialDefense: 50,
        speed: 60,
      );
}
