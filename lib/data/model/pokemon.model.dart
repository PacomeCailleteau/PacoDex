import 'package:json_annotation/json_annotation.dart';
import 'package:pokedex_app/data/model/pokemon.resistance.model.dart';
import 'package:pokedex_app/data/model/pokemon.stats.model.dart';
import 'package:pokedex_app/data/model/pokemon.type.model.dart';
import 'package:pokedex_app/data/model/pokemon_ref.model.dart';

part 'pokemon.model.g.dart';

PokemonRef? _preEvolutionFromJson(dynamic json) {
  if (json is Map<String, dynamic>) {
    return PokemonRef.fromJson(json);
  }
  return null;
}

List<PokemonType> _typesFromJson(List<dynamic> json) {
  final types = json.map((e) => PokemonType.fromJson(e as Map<String, dynamic>)).toList();
  if (types.length == 2) {
    return types.reversed.toList();
  }
  return types;
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Pokemon {
  const Pokemon({
    required this.id,
    required this.pokedexId,
    required this.name,
    required this.image,
    required this.stats,
    required this.apiTypes,
    required this.apiGeneration,
    required this.apiEvolutions,
    this.apiPreEvolution,
    this.height,
    this.weight,
    this.flavorText,
    this.cry,
    this.apiResistances,
    this.isFavorite = false,
  });

  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: 0)
  final int pokedexId;

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String image;

  final PokemonStats stats;

  @JsonKey(defaultValue: [], fromJson: _typesFromJson)
  final List<PokemonType> apiTypes;

  @JsonKey(defaultValue: 0)
  final int apiGeneration;

  @JsonKey(defaultValue: [])
  final List<PokemonRef> apiEvolutions;

  @JsonKey(fromJson: _preEvolutionFromJson)
  final PokemonRef? apiPreEvolution;

  final String? height;
  final String? weight;
  final String? flavorText;
  final String? cry;

  @JsonKey(defaultValue: [])
  final List<PokemonResistance>? apiResistances;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isFavorite;

  factory Pokemon.fromJson(Map<String, dynamic> json) => _$PokemonFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonToJson(this);

  Pokemon copyWith({
    String? height,
    String? weight,
    String? flavorText,
    String? cry,
    List<PokemonResistance>? apiResistances,
    bool? isFavorite,
  }) {
    return Pokemon(
      id: id,
      pokedexId: pokedexId,
      name: name,
      image: image,
      stats: stats,
      apiTypes: apiTypes,
      apiGeneration: apiGeneration,
      apiEvolutions: apiEvolutions,
      apiPreEvolution: apiPreEvolution,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      flavorText: flavorText ?? this.flavorText,
      cry: cry ?? this.cry,
      apiResistances: apiResistances ?? this.apiResistances,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  static Pokemon mock() => Pokemon(
        id: 999,
        pokedexId: 999,
        name: 'Pokémock',
        image: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
        stats: PokemonStats.mock(),
        apiTypes: <PokemonType>[
          PokemonType.mock(),
          PokemonType.mock(),
        ],
        apiGeneration: 9,
        apiEvolutions: <PokemonRef>[
          PokemonRef.mock(),
        ],
        apiPreEvolution: null,
        height: '1.7 m',
        weight: '90.5 kg',
        flavorText: 'Un Pokémon de test pour les maquettes.',
        cry: 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/1.ogg',
        apiResistances: [],
        isFavorite: false,
      );
}
