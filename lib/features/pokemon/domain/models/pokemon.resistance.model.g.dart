// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.resistance.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PokemonResistance _$PokemonResistanceFromJson(Map<String, dynamic> json) =>
    PokemonResistance(
      name: json['name'] as String? ?? '',
      damageMultiplier: (json['damage_multiplier'] as num?)?.toDouble() ?? 1.0,
      damageRelation: json['damage_relation'] as String? ?? '',
    );

Map<String, dynamic> _$PokemonResistanceToJson(PokemonResistance instance) =>
    <String, dynamic>{
      'name': instance.name,
      'damage_multiplier': instance.damageMultiplier,
      'damage_relation': instance.damageRelation,
    };
