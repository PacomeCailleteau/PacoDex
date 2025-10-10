import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/data/model/pokemon.model.dart';
import 'package:pokedex_app/ui/utils/color.utils.dart';
import 'package:pokedex_app/ui/utils/string.utils.dart';
import 'package:shimmer/shimmer.dart';

class PokemonCardWidget extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback onTap;

  const PokemonCardWidget({
    super.key,
    required this.pokemon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mainType = pokemon.apiTypes.isNotEmpty ? pokemon.apiTypes[0].name : '';
    final typeColor = getColorForType(mainType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              typeColor.withOpacity(0.95),
              typeColor.withOpacity(0.65),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: typeColor.withOpacity(0.40),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double scale;
            final bool isListMode = constraints.hasBoundedHeight && constraints.maxWidth / constraints.maxHeight > 2.5;

            if (constraints.hasBoundedHeight) {
              final double scaleW = (constraints.maxWidth / (isListMode ? 400 : 300)).clamp(0.5, 1.2);
              final double scaleH = (constraints.maxHeight / 140).clamp(0.5, 1.2);
              scale = min(scaleW, scaleH);
            } else {
              scale = (constraints.maxWidth / 300).clamp(0.5, 1.0);
            }
            double s(double v) => v * scale;

            final nameStyle = TextStyle(
              fontSize: s(28),
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.5 * scale,
            );
            final idStyle = TextStyle(
              fontSize: s(24),
              color: Colors.white.withOpacity(0.92),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4 * scale,
            );
            final double verticalGap = s(12);

            return ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(s(18), s(16), s(14), s(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              pokemon.name,
                              style: nameStyle,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        SizedBox(width: s(6)),
                        Text(
                          '#${pokemon.pokedexId.toString().padLeft(3, '0')}',
                          style: idStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: verticalGap),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isListMode
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    for (int i = 0; i < pokemon.apiTypes.length; i++) ...[
                                      _TypePill(
                                        name: pokemon.apiTypes[i].name,
                                        imageUrl: pokemon.apiTypes[i].image,
                                        scale: scale,
                                      ),
                                      if (i != pokemon.apiTypes.length - 1) SizedBox(width: s(4)),
                                    ],
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    for (int i = 0; i < pokemon.apiTypes.length; i++) ...[
                                      _TypePill(
                                        name: pokemon.apiTypes[i].name,
                                        imageUrl: pokemon.apiTypes[i].image,
                                        scale: scale,
                                      ),
                                      if (i != pokemon.apiTypes.length - 1) SizedBox(height: s(4)),
                                    ],
                                  ],
                                ),
                          SizedBox(width: s(8)),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Hero(
                                tag: pokemon.id,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  alignment: Alignment.bottomRight,
                                  child: CachedNetworkImage(
                                    imageUrl: pokemon.image,
                                    httpHeaders: const {
                                      'User-Agent':
                                          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                                    },
                                    filterQuality: FilterQuality.high,
                                    placeholder: (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.white.withOpacity(0.5),
                                      highlightColor: Colors.white.withOpacity(0.9),
                                      child: Container(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white.withOpacity(0.85),
                                      size: s(100),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double scale;
  const _TypePill({
    required this.name,
    required this.imageUrl,
    required this.scale,
  });
  @override
  Widget build(BuildContext context) {
    double s(double v) => v * scale;
    final pillPaddingH = s(10);
    final double pillPaddingV = s(5).clamp(4.0, 9.0).toDouble();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: pillPaddingH, vertical: pillPaddingV),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(s(20)),
        border: Border.all(
          color: Colors.white.withOpacity(0.55),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: s(18),
            width: s(18),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              httpHeaders: const {
                'User-Agent':
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
              },
              color: Colors.white,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.white.withOpacity(0.5),
                highlightColor: Colors.white.withOpacity(0.9),
                child: Container(color: Colors.transparent),
              ),
              errorWidget: (context, url, error) => const SizedBox(),
            ),
          ),
          SizedBox(width: s(8)),
          Text(
            capitalize(name),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: s(16),
              letterSpacing: 0.2 * scale,
            ),
            maxLines: 1,
            softWrap: false,
          ),
        ],
      ),
    );
  }
}
