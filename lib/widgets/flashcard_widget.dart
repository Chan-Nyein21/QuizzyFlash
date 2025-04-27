import 'dart:math';
import 'package:flutter/material.dart';

class FlashcardWidget extends StatefulWidget {
  final String question;
  final String answer;
  final bool showFront;

  const FlashcardWidget({
    super.key,
    required this.question,
    required this.answer,
    this.showFront = true, // 👈 allow controlling front/back
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  late bool _showFront;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _showFront = widget.showFront; // 👈 set based on passed value
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void _flipCard() {
    if (_controller.isAnimating) return;

    setState(() {
      _showFront = !_showFront;
    });

    if (_showFront) {
      _controller.reverse(from: 1);
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          double angle = _animation.value * pi;
          bool isFront = angle <= pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(angle),
            child:
                isFront
                    ? _buildCard(widget.question)
                    : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(pi),
                      child: _buildCard(widget.answer),
                    ),
          );
        },
      ),
    );
  }

  Widget _buildCard(String text) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }
}
