import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex_app/ui/pages/home.page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyPokedexApp());
}

class MyPokedexApp extends StatelessWidget {
  const MyPokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PacôDex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Orbitron',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(title: 'PacôDex'),
    );
  }
}
