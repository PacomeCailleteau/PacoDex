import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

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
          _buildCreditTile(
            context,
            'PokéAPI',
            'Pour les données complètes sur les Pokémon.',
            'https://pokeapi.co/',
          ),
          _buildCreditTile(
            context,
            'PokéBuild API',
            'Pour les données en français et les sprites.',
            'https://pokebuildapi.fr/',
          ),
          _buildCreditTile(
            context,
            'Flutter',
            'Le framework qui a rendu cette application possible.',
            'https://flutter.dev/',
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

  Widget _buildCreditTile(BuildContext context, String title, String subtitle, String url) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => _launchURL(url),
    );
  }
}
