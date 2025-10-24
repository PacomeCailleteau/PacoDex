// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pokemon _$PokemonFromJson(Map<String, dynamic> json) => Pokemon(
  id: (json['id'] as num?)?.toInt() ?? 0,
  pokedexId: (json['pokedexId'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  image: json['image'] as String? ?? '',
  stats: PokemonStats.fromJson(json['stats'] as Map<String, dynamic>),
  apiTypes: json['apiTypes'] == null
      ? []
      : _typesFromJson(json['apiTypes'] as List),
  apiGeneration: (json['apiGeneration'] as num?)?.toInt() ?? 0,
  apiEvolutions:
      (json['apiEvolutions'] as List<dynamic>?)
          ?.map((e) => PokemonRef.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  apiPreEvolution: _preEvolutionFromJson(json['apiPreEvolution']),
  height: json['height'] as String?,
  weight: json['weight'] as String?,
  flavorText: json['flavorText'] as String?,
  cry: json['cry'] as String?,
  apiResistances:
      (json['apiResistances'] as List<dynamic>?)
          ?.map((e) => PokemonResistance.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$PokemonToJson(Pokemon instance) => <String, dynamic>{
  'id': instance.id,
  'pokedexId': instance.pokedexId,
  'name': instance.name,
  'image': instance.image,
  'stats': instance.stats.toJson(),
  'apiTypes': instance.apiTypes.map((e) => e.toJson()).toList(),
  'apiGeneration': instance.apiGeneration,
  'apiEvolutions': instance.apiEvolutions.map((e) => e.toJson()).toList(),
  'apiPreEvolution': ?instance.apiPreEvolution?.toJson(),
  'height': ?instance.height,
  'weight': ?instance.weight,
  'flavorText': ?instance.flavorText,
  'cry': ?instance.cry,
  'apiResistances': ?instance.apiResistances?.map((e) => e.toJson()).toList(),
};
