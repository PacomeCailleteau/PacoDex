import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/data/api/favorites.service.dart';
import 'package:pokedex_app/data/api/pokemon.service.dart';
import 'package:pokedex_app/ui/cubits/pokemons.cubit.dart';
import 'package:pokedex_app/ui/cubits/theme.cubit.dart';
import 'package:pokedex_app/ui/pages/home.page.dart';
import 'package:pokedex_app/ui/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyPokedexApp());
}

class MyPokedexApp extends StatelessWidget {
  const MyPokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) => PokemonsCubit(PokemonService(), FavoritesService()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'PacôDex',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const Home(title: 'PacôDex'),
          );
        },
      ),
    );
  }
}
