import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/features/favorites/data/favorites.service.dart';
import 'package:pokedex_app/features/pokemon/data/pokemon.service.dart';
import 'package:pokedex_app/features/pokemon/domain/models/pokemon.model.dart';
import 'package:pokedex_app/features/pokemon/presentation/cubits/pokemon_details.cubit.dart';
import 'package:pokedex_app/features/pokemon/presentation/cubits/pokemon_details.state.dart';
import 'package:pokedex_app/core/utils/color.utils.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/pokemon_details_container.widget.dart';
import 'package:shimmer/shimmer.dart';

class PokemonDetailsPage extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailsPage({super.key, required this.pokemon});

  @override
  State<PokemonDetailsPage> createState() => _PokemonDetailsPageState();
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final PokemonDetailsCubit _pokemonDetailsCubit;
  bool _showShiny = false;

  @override
  void initState() {
    super.initState();
    _pokemonDetailsCubit = PokemonDetailsCubit(PokemonService(), FavoritesService());
    _pokemonDetailsCubit.loadPokemonDetails(widget.pokemon);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pokemonDetailsCubit.close();
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
    final primaryType = widget.pokemon.apiTypes.isNotEmpty ? widget.pokemon.apiTypes[0].name : '';
    final backgroundColor = getColorForType(primaryType);

    return BlocBuilder<PokemonDetailsCubit, PokemonDetailsState>(
      bloc: _pokemonDetailsCubit,
      builder: (context, state) {
        final pokemonForDisplay = (state is PokemonDetailsLoaded) ? state.pokemon : widget.pokemon;
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
                  color: _showShiny ? Colors.yellow : Colors.white.withAlpha(178),
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
                  onPressed: () => _pokemonDetailsCubit.toggleFavorite(),
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
                      baseColor: Colors.white.withAlpha(128),
                      highlightColor: Colors.white.withAlpha(230),
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
                    PokemonDetailsContainer(
                      pokemon: widget.pokemon,
                      isLoading: true,
                      playSound: _playSound,
                      navigateToPokemon: _navigateToPokemon,
                    ),
                  PokemonDetailsError(message: final error) =>
                    PokemonDetailsContainer(
                      pokemon: widget.pokemon,
                      error: error,
                      playSound: _playSound,
                      navigateToPokemon: _navigateToPokemon,
                    ),
                  PokemonDetailsLoaded(pokemon: final p, preEvolution: final pre, evolutions: final evos) =>
                    PokemonDetailsContainer(
                      pokemon: p,
                      preEvolution: pre,
                      evolutions: evos,
                      isLoading: false,
                      playSound: _playSound,
                      navigateToPokemon: _navigateToPokemon,
                    ),
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
