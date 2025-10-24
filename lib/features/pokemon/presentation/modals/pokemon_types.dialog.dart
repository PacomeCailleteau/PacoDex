import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pokedex_app/features/pokemon/data/pokemon.service.dart';
import 'package:pokedex_app/features/pokemon/domain/models/pokemon.type.model.dart';
import 'package:pokedex_app/core/utils/color.utils.dart';
import 'package:pokedex_app/core/utils/string.utils.dart';
import 'package:shimmer/shimmer.dart';

class PokemonTypesDialog extends StatefulWidget {
  const PokemonTypesDialog({super.key});

  @override
  State<PokemonTypesDialog> createState() => _PokemonTypesDialogState();
}

class _PokemonTypesDialogState extends State<PokemonTypesDialog> {
  final PokemonService _pokemonService = PokemonService();
  late Future<List<PokemonType>> _typesFuture;

  @override
  void initState() {
    super.initState();
    _typesFuture = _pokemonService.getTypes();
  }

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
              child: FutureBuilder<List<PokemonType>>(
                future: _typesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load types'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No types found'));
                  }

                  final types = snapshot.data!;
                  return AnimationLimiter(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.2,
                      ),
                      itemCount: types.length,
                      itemBuilder: (context, index) {
                        final type = types[index];
                        final color = getColorForType(type.name);
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(type.name);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        capitalize(type.name),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      CachedNetworkImage(
                                        imageUrl: type.image,
                                        httpHeaders: const {
                                          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                                        },
                                        placeholder: (context, url) => Shimmer.fromColors(
                                          baseColor: Colors.white.withAlpha(128),
                                          highlightColor: Colors.white.withAlpha(230),
                                          child: Container(color: Colors.transparent, height: 25, width: 25),
                                        ),
                                        errorWidget: (context, url, error) => const SizedBox(height: 25),
                                        height: 25,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
