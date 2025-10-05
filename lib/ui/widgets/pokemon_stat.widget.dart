import 'package:flutter/material.dart';

class PokemonStatWidget extends StatefulWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color color;

  const PokemonStatWidget({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  @override
  State<PokemonStatWidget> createState() => _PokemonStatWidgetState();
}

class _PokemonStatWidgetState extends State<PokemonStatWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.value.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          children: [
            SizedBox(width: 80, child: Text(widget.label)),
            SizedBox(width: 40, child: Text(widget.value.toString().padLeft(3, '0'))),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _animation.value / widget.maxValue,
                  color: widget.color,
                  backgroundColor: widget.color.withOpacity(0.2),
                  minHeight: 8,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
