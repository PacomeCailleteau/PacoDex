import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/features/pokemon/presentation/cubits/pokemons.cubit.dart';
import 'package:pokedex_app/features/pokemon/presentation/cubits/pokemons.state.dart';
import 'package:pokedex_app/features/pokemon/presentation/pages/pokemon_details.page.dart';
import 'package:pokedex_app/features/settings/presentation/pages/settings_page.dart';
import 'package:pokedex_app/core/widgets/empty_state.widget.dart';
import 'package:pokedex_app/features/dashboard/presentation/widgets/home_floating_action_button.dart';
import 'package:pokedex_app/features/dashboard/presentation/widgets/pokemon_grid_view.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<PokemonsCubit>().fetchPokemonsByGeneration(1);
  }

  void _goToRandomPokemon() {
    final randomPokemon = context.read<PokemonsCubit>().getRandomPokemon();
    if (randomPokemon != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PokemonDetailsPage(pokemon: randomPokemon),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PokemonsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => cubit.fetchPokemonsByGeneration(1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                    'assets/images/pacodex_logo.png', height: 32),
              ),
              const SizedBox(width: 12),
              Text(widget.title),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            tooltip: 'Paramètres',
          ),
        ],
      ),
      body: BlocBuilder<PokemonsCubit, PokemonsState>(
        builder: (context, state) {
          if (state is PokemonsLoading || state is PokemonsInitial) {
            return const PokemonGridView(pokemons: [], isLoading: true);
          }
          if (state is PokemonsLoaded) {
            if (state.pokemons.isEmpty) {
              return const EmptyStateWidget(
                message: 'Aucun Pokémon trouvé pour cette recherche.',
              );
            }
            return PokemonGridView(pokemons: state.pokemons);
          }
          if (state is PokemonsError) {
            return Center(child: Text(state.message));
          }
          return const PokemonGridView(pokemons: [], isLoading: true);
        },
      ),
      floatingActionButton: HomeFloatingActionButton(goToRandomPokemon: _goToRandomPokemon),
    );
  }
}
