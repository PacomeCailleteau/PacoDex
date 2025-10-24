import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/features/pokemon/domain/models/pokemon.model.dart';

class PokemonImage extends StatelessWidget {
  final bool answered;
  final Pokemon pokemon;

  const PokemonImage({super.key, required this.answered, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final silhouetteColor = isDarkMode ? Colors.grey[400] : Colors.black;

    final image = CachedNetworkImage(
      imageUrl: pokemon.image,
      httpHeaders: const {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
      },
      placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error, size: 80),
      fit: BoxFit.contain,
    );

    return Expanded(
      child: answered
          ? image
          : ColorFiltered(
              colorFilter: ColorFilter.mode(
                silhouetteColor!,
                BlendMode.srcIn,
              ),
              child: image,
            ),
    );
  }
}
