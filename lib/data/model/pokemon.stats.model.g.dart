// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.stats.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PokemonStats _$PokemonStatsFromJson(Map<String, dynamic> json) => PokemonStats(
  hp: (json['HP'] as num?)?.toInt() ?? 0,
  attack: (json['attack'] as num?)?.toInt() ?? 0,
  defense: (json['defense'] as num?)?.toInt() ?? 0,
  specialAttack: (json['special_attack'] as num?)?.toInt() ?? 0,
  specialDefense: (json['special_defense'] as num?)?.toInt() ?? 0,
  speed: (json['speed'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PokemonStatsToJson(PokemonStats instance) =>
    <String, dynamic>{
      'HP': instance.hp,
      'attack': instance.attack,
      'defense': instance.defense,
      'special_attack': instance.specialAttack,
      'special_defense': instance.specialDefense,
      'speed': instance.speed,
    };
