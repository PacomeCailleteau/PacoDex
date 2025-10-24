import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/core/utils/color.utils.dart';
import 'package:pokedex_app/features/pokemon/domain/models/pokemon.resistance.model.dart';
import 'package:shimmer/shimmer.dart';

class ResistanceIcon extends StatelessWidget {
  final PokemonResistance resistance;
  final String? imageUrl;

  const ResistanceIcon({super.key, required this.resistance, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final color = getColorForType(resistance.name.toLowerCase());
    Color multiplierColor;
    if (resistance.damageMultiplier > 1) {
      multiplierColor = Colors.red;
    } else if (resistance.damageMultiplier < 1) {
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
                    baseColor: Colors.white.withAlpha(128),
                    highlightColor: Colors.white.withAlpha(230),
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
          'x${resistance.damageMultiplier}',
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
