import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/data/model/pokemon.model.dart';
import 'package:pokedex_app/ui/cubits/pokemons.cubit.dart';

class PokemonQuizPage extends StatefulWidget {
  const PokemonQuizPage({super.key});

  @override
  State<PokemonQuizPage> createState() => _PokemonQuizPageState();
}

class _PokemonQuizPageState extends State<PokemonQuizPage> {
  PokemonQuiz? _currentQuiz;
  int _score = 0;
  int _lives = 3;
  bool _answered = false;
  bool _isGameOver = false;
  Pokemon? _selectedPokemon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startNewGame();
    });
  }

  void _startNewGame() {
    setState(() {
      _score = 0;
      _lives = 3;
      _isGameOver = false;
      _currentQuiz = null; // Show loader while we fetch the first quiz
    });
    _loadNewQuiz();
  }

  void _loadNewQuiz() {
    final newQuiz = context.read<PokemonsCubit>().getPokemonQuiz();

    if (newQuiz == null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _loadNewQuiz();
        }
      });
      return;
    }

    setState(() {
      _currentQuiz = newQuiz;
      _answered = false;
      _selectedPokemon = null;
    });
  }

  void _handleAnswer(Pokemon selectedPokemon) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedPokemon = selectedPokemon;
      bool isCorrect = selectedPokemon == _currentQuiz!.correctPokemon;

      if (isCorrect) {
        _score++;
      } else {
        _lives--;
      }
    });

    // Wait 2 seconds before moving on
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return; // Guard against calling setState on an unmounted widget

      if (_lives == 0) {
        setState(() {
          _isGameOver = true;
        });
      } else {
        _loadNewQuiz();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quel est ce Pokémon ?', style: TextStyle(fontSize: 14)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: List.generate(3, (index) {
                    return Icon(
                      index < _lives ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 20,
                    );
                  }),
                ),
                const SizedBox(height: 2),
                Text(
                  'Score: $_score',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isGameOver) {
      return _buildGameOver();
    }
    if (_currentQuiz == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPokemonImage(),
          _buildOptionsGrid(),
        ],
      ),
    );
  }

  Widget _buildGameOver() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Game Over', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('Score final: $_score', style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 32),
          ElevatedButton(onPressed: _startNewGame, child: const Text('Rejouer')),
        ],
      ),
    );
  }

  Widget _buildPokemonImage() {
    final pokemon = _currentQuiz!.correctPokemon;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final silhouetteColor = isDarkMode ? Colors.grey[400] : Colors.black;

    final image = CachedNetworkImage(
      imageUrl: pokemon.image,
      httpHeaders: const {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
      },
      placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error, size: 80),
      fit: BoxFit.contain,
    );

    return Expanded(
      child: _answered
          ? image // After answering, show the raw image.
          : ColorFiltered(
              // Before answering, wrap in a filter for the silhouette effect.
              colorFilter: ColorFilter.mode(
                silhouetteColor!,
                BlendMode.srcIn,
              ),
              child: image,
            ),
    );
  }

  Widget _buildOptionsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        final pokemon = _currentQuiz!.options[index];
        return ElevatedButton(
          onPressed: () => _handleAnswer(pokemon),
          style: ElevatedButton.styleFrom(
            backgroundColor: _getButtonColor(pokemon),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              pokemon.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Color? _getButtonColor(Pokemon pokemon) {
    if (!_answered) {
      return Colors.blue;
    }
    if (pokemon == _currentQuiz!.correctPokemon) {
      return Colors.green;
    }
    if (pokemon == _selectedPokemon) {
      return Colors.red;
    }
    return Colors.grey.withOpacity(0.5);
  }
}
