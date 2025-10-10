import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/data/api/favorites.service.dart';
import 'package:pokedex_app/data/api/pokemon.service.dart';
import 'package:pokedex_app/data/model/pokemon.model.dart';
import 'package:pokedex_app/data/model/pokemon.resistance.model.dart';
import 'package:pokedex_app/data/model/pokemon.type.model.dart';
import 'package:pokedex_app/ui/cubits/pokemon_details.cubit.dart';
import 'package:pokedex_app/ui/cubits/pokemon_details.state.dart';
import 'package:pokedex_app/ui/utils/color.utils.dart';
import 'package:pokedex_app/ui/widgets/pokemon_details_skeleton.widget.dart';
import 'package:pokedex_app/ui/widgets/pokemon_evolution.widget.dart';
import 'package:pokedex_app/ui/widgets/pokemon_stat.widget.dart';
import 'package:pokedex_app/ui/widgets/pokemon_type.widget.dart';
import 'package:shimmer/shimmer.dart';

class PokemonDetailsPage extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailsPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonDetailsCubit(PokemonService(), FavoritesService())..loadPokemonDetails(pokemon),
      child: _PokemonDetailsView(basePokemon: pokemon),
    );
  }
}

class _PokemonDetailsView extends StatefulWidget {
  final Pokemon basePokemon;

  const _PokemonDetailsView({required this.basePokemon});

  @override
  State<_PokemonDetailsView> createState() => _PokemonDetailsViewState();
}

class _PokemonDetailsViewState extends State<_PokemonDetailsView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _showShiny = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _toggleShiny() {
    setState(() {
      _showShiny = !_showShiny;
    });
  }

  void _playSound(String? url) {
    if (url != null) {
      _audioPlayer.play(UrlSource(url));
    }
  }

  String _getShinyImageUrl(Pokemon pokemon) {
    return pokemon.image.replaceFirst('/official-artwork/', '/official-artwork/shiny/');
  }

  void _navigateToPokemon(Pokemon pokemon) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PokemonDetailsPage(pokemon: pokemon)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryType = widget.basePokemon.apiTypes.isNotEmpty ? widget.basePokemon.apiTypes[0].name : '';
    final backgroundColor = getColorForType(primaryType);

    return BlocBuilder<PokemonDetailsCubit, PokemonDetailsState>(
      builder: (context, state) {
        final pokemonForDisplay = (state is PokemonDetailsLoaded) ? state.pokemon : widget.basePokemon;
        final isFavorite = (state is PokemonDetailsLoaded) ? state.pokemon.isFavorite : false;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Précédent',
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.star,
                  color: _showShiny ? Colors.yellow : Colors.white.withOpacity(0.7),
                ),
                onPressed: _toggleShiny,
                tooltip: _showShiny ? 'Voir la version Normale' : 'Voir la version Shiny',
              ),
              if (state is PokemonDetailsLoaded)
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
                  onPressed: () => context.read<PokemonDetailsCubit>().toggleFavorite(),
                  tooltip: isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                ),
            ],
          ),
          body: Column(
            children: [
              Hero(
                tag: pokemonForDisplay.id,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: CachedNetworkImage(
                    imageUrl: _showShiny ? _getShinyImageUrl(pokemonForDisplay) : pokemonForDisplay.image,
                    key: ValueKey<bool>(_showShiny),
                    httpHeaders: const {
                      'User-Agent':
                          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                    },
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.white.withOpacity(0.5),
                      highlightColor: Colors.white.withOpacity(0.9),
                      child: Container(color: Colors.transparent, height: 140, width: 140),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error, size: 140, color: Colors.white),
                    height: 140,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: switch (state) {
                  PokemonDetailsInitial() ||
                  PokemonDetailsLoading() =>
                    _buildDetailsContainer(context, widget.basePokemon, isLoading: true),
                  PokemonDetailsError(message: final error) =>
                    _buildDetailsContainer(context, widget.basePokemon, error: error),
                  PokemonDetailsLoaded(pokemon: final p, preEvolution: final pre, evolutions: final evos) =>
                    _buildDetailsContainer(context, p, preEvolution: pre, evolutions: evos, isLoading: false),
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsContainer(
    BuildContext context,
    Pokemon pokemon, {
    String? error,
    bool isLoading = false,
    Pokemon? preEvolution,
    List<Pokemon> evolutions = const [],
  }) {
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
                  ? Center(child: Text(error, style: const TextStyle(color: Colors.red)))
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
                                onPressed: () => _playSound(pokemon.cry),
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
                            _InfoCard(label: 'Poids', value: pokemon.weight ?? '- '),
                            _InfoCard(label: 'Taille', value: pokemon.height ?? '- '),
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
                              return _ResistanceIcon(resistance: resistance, imageUrl: typeImageUrl);
                            },
                          ),
                        ],
                        const SizedBox(height: 24),
                        const Text('Pré-évolution', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        if (preEvolution != null)
                          PokemonEvolutionWidget(
                            pokemon: preEvolution,
                            onTap: () => _navigateToPokemon(preEvolution),
                          )
                        else
                          const Text('Ce pokémon n\'a pas de pré-évolution'),
                        const SizedBox(height: 24),
                        const Text('Évolutions', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        if (evolutions.isNotEmpty)
                          ...evolutions.map((evo) => PokemonEvolutionWidget(
                                pokemon: evo,
                                onTap: () => _navigateToPokemon(evo),
                              ))
                        else
                          const Text('Ce pokémon n\'a pas d\'évolution'),
                      ],
                    ),
            ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}

class _ResistanceIcon extends StatelessWidget {
  final PokemonResistance resistance;
  final String? imageUrl;

  const _ResistanceIcon({required this.resistance, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final color = getColorForType(resistance.name.toLowerCase());
    Color multiplierColor;
    if (resistance.damage_multiplier > 1) {
      multiplierColor = Colors.red;
    } else if (resistance.damage_multiplier < 1) {
      multiplierColor = Colors.green;
    } else {
      multiplierColor = Theme.of(context).textTheme.bodyLarge?.color ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 16,
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  httpHeaders: const {
                    'User-Agent':
                        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                  },
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.white.withOpacity(0.5),
                    highlightColor: Colors.white.withOpacity(0.9),
                    child: Container(color: Colors.transparent),
                  ),
                  errorWidget: (context, error, stackTrace) => const Icon(Icons.help_outline, color: Colors.white, size: 20),
                  height: 20,
                  width: 20,
                  color: Colors.white,
                )
              : const Icon(Icons.help_outline, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          'x${resistance.damage_multiplier}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: multiplierColor,
          ),
        ),
      ],
    );
  }
}
