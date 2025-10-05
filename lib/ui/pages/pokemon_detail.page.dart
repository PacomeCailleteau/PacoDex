import 'package:flutter/material.dart';
import 'package:pokedex_app/data/model/pokemon.model.dart';

class PokemonDetailPage extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
      ),
      body: Center(
        child: Text('Détails pour ${pokemon.name}'),
      ),
    );
  }
}
