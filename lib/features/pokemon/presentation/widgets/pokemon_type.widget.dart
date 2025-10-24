import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/core/utils/color.utils.dart';
import 'package:pokedex_app/core/utils/string.utils.dart';
import 'package:shimmer/shimmer.dart';

class PokemonTypeWidget extends StatelessWidget {
  final String name;
  final String imageUrl;

  const PokemonTypeWidget({
    super.key,
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final color = getColorForType(name);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              httpHeaders: const {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
              },
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: color.withOpacity(0.3),
                highlightColor: color.withOpacity(0.1),
                child: Container(color: Colors.transparent),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error_outline, size: 16),
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            capitalize(name),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
