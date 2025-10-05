import 'package:flutter/material.dart';

class PokemonSearchDialog extends StatefulWidget {
  const PokemonSearchDialog({super.key, required this.onSearch});

  final Function(String) onSearch;

  @override
  State<PokemonSearchDialog> createState() => _PokemonSearchDialogState();
}

class _PokemonSearchDialogState extends State<PokemonSearchDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 9),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tapez pour rechercher (ex: Pikachu ou 025)',
                hintStyle: const TextStyle(fontSize: 9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSubmitted: (value) {
                widget.onSearch(value);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
