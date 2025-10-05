import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/data/model/pokemon.model.dart';
import 'package:shimmer/shimmer.dart';

class PokemonEvolutionWidget extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onTap;

  const PokemonEvolutionWidget({
    super.key,
    required this.pokemon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CachedNetworkImage(
                imageUrl: pokemon.image,
                httpHeaders: const {
                  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                },
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pokemon.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('#${pokemon.pokedexId.toString().padLeft(3, '0')}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
            if (onTap != null) const Spacer(),
            if (onTap != null) const Icon(Icons.navigate_next, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
