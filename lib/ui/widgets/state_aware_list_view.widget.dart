import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/ui/cubits/pokemons.cubit.dart';
import 'package:pokedex_app/ui/cubits/pokemons.state.dart';

class StateAwareListView extends StatelessWidget {
  final Widget Function(BuildContext, PokemonsLoaded) builder;

  const StateAwareListView({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonsCubit, PokemonsState>(
      builder: (context, state) {
        if (state is PokemonsLoading) {
          return const _LoadingView();
        } else if (state is PokemonsLoaded) {
          if (state.pokemons.isEmpty) {
            return const _EmptyView();
          }
          return builder(context, state);
        } else if (state is PokemonsError) {
          return _ErrorView(message: state.message);
        } else {
          return const _InitialView();
        }
      },
    );
  }
}

class _InitialView extends StatelessWidget {
  const _InitialView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Veuillez sélectionner une génération, un type ou vos favoris.'),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/pacodex_logo.png', height: 100),
          const SizedBox(height: 20),
          const CircularProgressIndicator(),
          const SizedBox(height: 10),
          const Text('Chargement...'),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://www.gifimili.com/gif/2018/02/pikachu-pleure.gif',
            height: 100,
          ),
          const SizedBox(height: 20),
          const Text(
            'Aucun Pokémon ne correspond à votre recherche.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://www.gifimili.com/gif/2018/02/pikachu-pleure.gif',
            height: 100,
          ),
          const SizedBox(height: 20),
          const Text(
            'Une erreur est survenue :',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
