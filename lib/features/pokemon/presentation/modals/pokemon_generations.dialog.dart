import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

const Map<int, List<int>> _generationStarters = {
  1: [1, 4, 7],       // Bulbasaur, Charmander, Squirtle
  2: [152, 155, 158], // Chikorita, Cyndaquil, Totodile
  3: [252, 255, 258], // Treecko, Torchic, Mudkip
  4: [387, 390, 393], // Turtwig, Chimchar, Piplup
  5: [495, 498, 501], // Snivy, Tepig, Oshawott
  6: [650, 653, 656], // Chespin, Fennekin, Froakie
  7: [722, 725, 728], // Rowlet, Litten, Popplio
  8: [810, 813, 816], // Grookey, Scorbunny, Sobble
};

class PokemonGenerationsDialog extends StatelessWidget {
  const PokemonGenerationsDialog({super.key});

  static const List<Map<String, dynamic>> _generations = [
    {'id': 1, 'title': 'Génération I'},
    {'id': 2, 'title': 'Génération II'},
    {'id': 3, 'title': 'Génération III'},
    {'id': 4, 'title': 'Génération IV'},
    {'id': 5, 'title': 'Génération V'},
    {'id': 6, 'title': 'Génération VI'},
    {'id': 7, 'title': 'Génération VII'},
    {'id': 8, 'title': 'Génération VIII'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Flexible(
              child: AnimationLimiter(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: _generations.length,
                  itemBuilder: (context, index) {
                    final generation = _generations[index];
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 2,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: _GenerationCard(
                            generationId: generation['id'],
                            title: generation['title'],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenerationCard extends StatelessWidget {
  final int generationId;
  final String title;

  const _GenerationCard({required this.generationId, required this.title});

  String _getImageUrl(int pokemonId) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png';
  }

  @override
  Widget build(BuildContext context) {
    final starterIds = _generationStarters[generationId] ?? [];

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(generationId);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: starterIds.map((id) {
                    return Expanded(
                      child: CachedNetworkImage(
                        imageUrl: _getImageUrl(id),
                        httpHeaders: const {
                          'User-Agent':
                              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                        },
                        fit: BoxFit.contain,
                        fadeInDuration: const Duration(milliseconds: 300),
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
