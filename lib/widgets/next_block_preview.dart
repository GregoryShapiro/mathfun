import 'package:flutter/material.dart';
import '../models/game_block.dart';

class NextBlockPreview extends StatelessWidget {
  final GameBlock nextBlock;
  final double size;
  
  const NextBlockPreview({
    super.key,
    required this.nextBlock,
    this.size = 60.0,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade100,
            Colors.purple.shade50,
            Colors.blue.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade200, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.7,
          height: size * 0.7,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getGradientColorsForValue(nextBlock.value),
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ],
          ),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(2),
              child: Text(
                '${nextBlock.value}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.black54, blurRadius: 3, offset: Offset(1, 1))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  List<Color> _getGradientColorsForValue(int value) {
    final baseColor = _getColorForValue(value);
    // Create lighter and darker shades for gradient
    return [
      Color.lerp(baseColor, Colors.white, 0.4) ?? baseColor,
      baseColor,
      Color.lerp(baseColor, Colors.black, 0.2) ?? baseColor,
    ];
  }
  
  Color _getColorForValue(int value) {
    // Same vibrant colors as in the game grid
    switch (value % 5) {
      case 0: return const Color(0xFFFF4081); // Vibrant pink
      case 1: return const Color(0xFF2979FF); // Bright blue
      case 2: return const Color(0xFF00E676); // Vivid green
      case 3: return const Color(0xFFFFD740); // Golden yellow
      case 4: return const Color(0xFFAA00FF); // Rich purple
      default: return const Color(0xFF1DE9B6); // Bright teal
    }
  }
}