import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pokedex_app/data/api/pokemon.service.dart';
import 'package:pokedex_app/ui/cubits/theme.cubit.dart';
import 'package:pokedex_app/ui/pages/credits_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Vider le cache'),
          content: const Text(
              'Voulez-vous vraiment vider le cache de l\'application ? Toutes les données et images hors ligne seront supprimées.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Vider'),
              onPressed: () async {
                await PokemonService().clearCache();
                await DefaultCacheManager().emptyCache();

                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Le cache a été vidé.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thème',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, currentThemeMode) {
                return Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('Clair'),
                      value: ThemeMode.light,
                      groupValue: currentThemeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          context.read<ThemeCubit>().setTheme(value);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Sombre'),
                      value: ThemeMode.dark,
                      groupValue: currentThemeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          context.read<ThemeCubit>().setTheme(value);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Système'),
                      value: ThemeMode.system,
                      groupValue: currentThemeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          context.read<ThemeCubit>().setTheme(value);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Données',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Vider le cache'),
              subtitle: const Text('Supprime les données et images stockées sur votre appareil.'),
              leading: const Icon(Icons.delete_sweep),
              onTap: () => _showClearCacheDialog(context),
            ),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'À propos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Crédits'),
              subtitle: const Text('Remerciements et sources des données.'),
              leading: const Icon(Icons.people),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreditsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
