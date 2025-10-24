import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/features/pokemon/domain/models/pokemon.model.dart';
import 'package:pokedex_app/features/pokemon/presentation/cubits/pokemons.cubit.dart';
import 'package:pokedex_app/features/quizz/presentation/widgets/quiz_body.widget.dart';

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
      _currentQuiz = null;
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

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

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
      body: QuizBody(
        currentQuiz: _currentQuiz,
        isGameOver: _isGameOver,
        score: _score,
        startNewGame: _startNewGame,
        answered: _answered,
        handleAnswer: _handleAnswer,
        selectedPokemon: _selectedPokemon,
      ),
    );
  }
}
