import 'package:flutter/material.dart';
import 'package:pokedex_app/features/credits/presentation/widgets/credit_tile.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crédits'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Merci à la communauté pour ces outils incroyables !',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const CreditTile(
            title: 'PokéAPI',
            subtitle: 'Pour les données complètes sur les Pokémon.',
            url: 'https://pokeapi.co/',
          ),
          const CreditTile(
            title: 'PokéBuild API',
            subtitle: 'Pour les données en français et les sprites.',
            url: 'https://pokebuildapi.fr/',
          ),
          const CreditTile(
            title: 'Flutter',
            subtitle: 'Le framework qui a rendu cette application possible.',
            url: 'https://flutter.dev/',
          ),
          const Divider(height: 32),
          Text(
            'Développé avec ❤️ par Pacôme',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
