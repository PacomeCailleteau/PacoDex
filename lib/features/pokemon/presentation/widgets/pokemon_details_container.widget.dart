import 'package:flutter/material.dart';
import 'package:pokedex_app/features/pokemon/domain/models/pokemon.model.dart';
import 'package:pokedex_app/features/pokemon/domain/models/pokemon.type.model.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/info_card.widget.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/pokemon_details_skeleton.widget.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/pokemon_evolution.widget.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/pokemon_stat.widget.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/pokemon_type.widget.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/resistance_icon.widget.dart';

class PokemonDetailsContainer extends StatelessWidget {
  final Pokemon pokemon;
  final String? error;
  final bool isLoading;
  final Pokemon? preEvolution;
  final List<Pokemon> evolutions;
  final void Function(String?) playSound;
  final void Function(Pokemon) navigateToPokemon;


  const PokemonDetailsContainer({
    super.key,
    required this.pokemon,
    this.error,
    this.isLoading = false,
    this.preEvolution,
    this.evolutions = const [],
    required this.playSound,
    required this.navigateToPokemon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: isLoading
          ? const PokemonDetailsSkeleton()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: error != null
                  ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                pokemon.name,
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            if (pokemon.cry != null)
                              IconButton(
                                icon: const Icon(Icons.volume_up, color: Colors.grey),
                                onPressed: () => playSound(pokemon.cry),
                                tooltip: 'Écouter le cri',
                              ),
                            Text('#${pokemon.pokedexId.toString().padLeft(3, '0')}', style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: pokemon.apiTypes
                              .map((type) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: PokemonTypeWidget(
                                      name: type.name,
                                      imageUrl: type.image,
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InfoPokemonCard(label: 'Poids', value: pokemon.weight ?? '- '),
                            InfoPokemonCard(label: 'Taille', value: pokemon.height ?? '- '),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          pokemon.flavorText ?? 'Aucune description disponible pour le moment.',
                          style: const TextStyle(height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        const Text('Statistiques', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        PokemonStatWidget(label: 'PV', value: pokemon.stats.hp, maxValue: 255, color: Colors.green),
                        PokemonStatWidget(label: 'Attaque', value: pokemon.stats.attack, maxValue: 255, color: Colors.red),
                        PokemonStatWidget(label: 'Défense', value: pokemon.stats.defense, maxValue: 255, color: Colors.blue),
                        PokemonStatWidget(
                            label: 'Atq Spé', value: pokemon.stats.specialAttack, maxValue: 255, color: Colors.red),
                        PokemonStatWidget(
                            label: 'Déf Spé', value: pokemon.stats.specialDefense, maxValue: 255, color: Colors.blue),
                        PokemonStatWidget(label: 'Vitesse', value: pokemon.stats.speed, maxValue: 255, color: Colors.orange),
                        const SizedBox(height: 24),
                        if (pokemon.apiResistances != null && pokemon.apiResistances!.isNotEmpty) ...[
                          const Text('Résistances', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: pokemon.apiResistances!.length,
                            itemBuilder: (context, index) {
                              final resistance = pokemon.apiResistances![index];
                              final typeImageUrl = pokemon.apiTypes.firstWhere((t) => t.name == resistance.name, orElse: () => PokemonType.mock()).image;
                              return ResistanceIcon(resistance: resistance, imageUrl: typeImageUrl);
                            },
                          ),
                        ],
                        const SizedBox(height: 24),
                        const Text('Pré-évolution', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        if (preEvolution != null)
                          PokemonEvolutionWidget(
                            pokemon: preEvolution!,
                            onTap: () => navigateToPokemon(preEvolution!),
                          )
                        else
                          const Text('Ce pokémon n\'a pas de pré-évolution'),
                        const SizedBox(height: 24),
                        const Text('Évolutions', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        if (evolutions.isNotEmpty)
                          ...evolutions.map((evo) => PokemonEvolutionWidget(
                                pokemon: evo,
                                onTap: () => navigateToPokemon(evo),
                              ))
                        else
                          const Text('Ce pokémon n\'a pas d\'évolution'),
                      ],
                    ),
            ),
    );
  }
}
