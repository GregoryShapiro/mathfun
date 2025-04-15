import 'package:flutter/material.dart';
import '../models/game_state.dart';

class GameGrid extends StatelessWidget {
  final GameState gameState;
  final double cellSize = 40.0; // Increased cell size for better visibility

  const GameGrid({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final gridWidth = cellSize * gameState.gridWidth;
    final gridHeight = cellSize * gameState.gridHeight;
    
    return SizedBox(
      width: gridWidth,
      height: gridHeight,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple.shade300, width: 3),
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade100,
              Colors.lightBlue.shade50,
              Colors.purple.shade50,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        // Add a subtle pattern overlay for more visual interest
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: CustomPaint(
                painter: GridPatternPainter(cellSize: cellSize),
              ),
            ),
            
            // Grid cells
            _buildGridBlocks(),
            
            // Falling block
            if (gameState.fallingBlock != null) _buildFallingBlock(),
          ],
        ),
      ),
    );
  }

  Widget _buildGridBlocks() {
    return Stack(
      children: [
        for (int y = 0; y < gameState.gridHeight; y++)
          for (int x = 0; x < gameState.gridWidth; x++)
            Positioned(
              left: x * cellSize,
              top: y * cellSize,
              width: cellSize,
              height: cellSize,
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  border: Border.all(color: Colors.lightBlue.shade200, width: 1),
                  borderRadius: BorderRadius.circular(6),
                  // Add subtle pattern for more visual interest
                  backgroundBlendMode: BlendMode.lighten,
                ),
              ),
            ),
        
        // Blocks in the grid
        for (int y = 0; y < gameState.gridHeight; y++)
          for (int x = 0; x < gameState.gridWidth; x++)
            if (gameState.grid[y][x] != null)
              Positioned(
                left: x * cellSize,
                top: y * cellSize,
                width: cellSize,
                height: cellSize,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _getGradientColorsForValue(gameState.grid[y][x]!.value),
                    ),
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(1, 1),
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
                        '${gameState.grid[y][x]!.value}',
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
      ],
    );
  }

  Widget _buildFallingBlock() {
    final block = gameState.fallingBlock!;
    
    return Positioned(
      left: block.x * cellSize,
      top: block.y * cellSize,
      width: cellSize,
      height: cellSize,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getGradientColorsForValue(block.value),
          ),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(1, 1),
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
              '${block.value}',
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
    );
  }

  Color _getColorForValue(int value) {
    // More vibrant, fun colors for children
    switch (value % 5) {
      case 0: return const Color(0xFFFF4081); // Vibrant pink
      case 1: return const Color(0xFF2979FF); // Bright blue
      case 2: return const Color(0xFF00E676); // Vivid green
      case 3: return const Color(0xFFFFD740); // Golden yellow
      case 4: return const Color(0xFFAA00FF); // Rich purple
      default: return const Color(0xFF1DE9B6); // Bright teal
    }
  }
  
  // Get gradient colors for more appealing blocks
  List<Color> _getGradientColorsForValue(int value) {
    final baseColor = _getColorForValue(value);
    // Create lighter and darker shades for gradient
    return [
      Color.lerp(baseColor, Colors.white, 0.4) ?? baseColor,
      baseColor,
      Color.lerp(baseColor, Colors.black, 0.2) ?? baseColor,
    ];
  }
}

// Custom painter for the grid background pattern
class GridPatternPainter extends CustomPainter {
  final double cellSize;
  
  GridPatternPainter({required this.cellSize});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    
    // Draw horizontal grid lines
    for (int i = 0; i <= size.height / cellSize; i++) {
      final y = i * cellSize;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    
    // Draw vertical grid lines
    for (int i = 0; i <= size.width / cellSize; i++) {
      final x = i * cellSize;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    // Add some decorative dots at intersections
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
      
    for (int i = 0; i <= size.width / cellSize; i++) {
      for (int j = 0; j <= size.height / cellSize; j++) {
        canvas.drawCircle(
          Offset(i * cellSize, j * cellSize),
          1.0,
          dotPaint,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Global key for navigator access
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
