// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.resistance.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PokemonResistance _$PokemonResistanceFromJson(Map<String, dynamic> json) =>
    PokemonResistance(
      name: json['name'] as String? ?? '',
      damage_multiplier: (json['damage_multiplier'] as num?)?.toDouble() ?? 1.0,
      damage_relation: json['damage_relation'] as String? ?? '',
    );

Map<String, dynamic> _$PokemonResistanceToJson(PokemonResistance instance) =>
    <String, dynamic>{
      'name': instance.name,
      'damage_multiplier': instance.damage_multiplier,
      'damage_relation': instance.damage_relation,
    };
