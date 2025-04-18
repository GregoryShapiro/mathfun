import 'package:flutter/material.dart';
import '../models/multiplication_game_state.dart';
import '../models/multiplication_game_block.dart';

class MultiplicationGameGrid extends StatelessWidget {
  final MultiplicationGameState gameState;

  const MultiplicationGameGrid({
    super.key,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context) {
    // Create a copy of the grid that includes the current falling block
    final displayGrid = List.generate(
      MultiplicationGameState.gridHeight,
      (y) => List.generate(
        MultiplicationGameState.gridWidth,
        (x) => gameState.grid[y][x],
      ),
    );

    // Add the current falling block to the display grid
    if (gameState.currentBlock != null && !gameState.isGameOver) {
      final block = gameState.currentBlock!;
      displayGrid[block.y][block.x] = block;
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 1.3,
      child: Column(
        children: [
          // Game area
          Expanded(
            flex: MultiplicationGameState.gridHeight - 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange.shade300, width: 2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MultiplicationGameState.gridWidth,
                  childAspectRatio: 1.0,
                ),
                itemCount: (MultiplicationGameState.gridHeight - 1) * MultiplicationGameState.gridWidth,
                itemBuilder: (context, index) {
                  final x = index % MultiplicationGameState.gridWidth;
                  final y = index ~/ MultiplicationGameState.gridWidth;
                  final block = displayGrid[y][x];
                  
                  return _buildGameCell(block, context, false);
                },
              ),
            ),
          ),
          
          // Pipes row
          Container(
            height: MediaQuery.of(context).size.width * 0.9 / MultiplicationGameState.gridWidth,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              border: Border.all(color: Colors.orange.shade300, width: 2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: List.generate(
                MultiplicationGameState.gridWidth,
                (x) => Expanded(
                  child: _buildGameCell(displayGrid[MultiplicationGameState.gridHeight - 1][x], context, true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCell(MultiplicationGameBlock? block, BuildContext context, bool isPipe) {
    if (block == null) {
      return Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    // Coloring based on block type
    Color blockColor;
    if (isPipe) {
      blockColor = Colors.orange.shade300;
    } else {
      // Get color based on the multiplication operands
      int factor = (int.parse(block.value) % 10) + 1;
      final colors = [
        Colors.blue.shade300,
        Colors.green.shade300,
        Colors.red.shade300,
        Colors.purple.shade300,
        Colors.amber.shade300,
        Colors.cyan.shade300,
        Colors.pink.shade300,
        Colors.indigo.shade300,
        Colors.teal.shade300,
        Colors.lime.shade300,
      ];
      blockColor = colors[factor % colors.length];
    }

    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: blockColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: isPipe
          ? _buildPipeContent(block)
          : _buildBlockContent(block),
      ),
    );
  }

  Widget _buildBlockContent(MultiplicationGameBlock block) {
    // Generate a color based on the equation
    final parts = block.equation.split('×');
    final a = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 1 : 1;
    final b = parts.length > 1 ? int.tryParse(parts[1]) ?? 1 : 1;
    final colorIndex = (a + b) % 10;
    
    final colors = [
      Colors.red.shade300,
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.purple.shade300,
      Colors.orange.shade400,
      Colors.cyan.shade400,
      Colors.pink.shade400,
      Colors.indigo.shade300,
      Colors.teal.shade400,
      Colors.amber.shade400,
    ];
    
    final balloonColor = colors[colorIndex];
    
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Long balloon shape
            CustomPaint(
              size: Size.infinite,
              painter: LongBalloonPainter(
                color: balloonColor,
              ),
            ),
            
            // Equation text drawn vertically
            Center(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (parts.length == 2) ...[
                      Text(
                        parts[0],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "×",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        parts[1],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "=",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPipeContent(MultiplicationGameBlock block) {
    return Stack(
      children: [
        const CustomPaint(
          size: Size.infinite,
          painter: PipePainter(),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.brown.shade600,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.brown.shade900, width: 1),
            ),
            child: Text(
              block.value.length > 1 ? block.value : block.value.padLeft(2, '0'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BalloonStringPainter extends CustomPainter {
  const BalloonStringPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.shade800
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw a wavy string
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 2, size.height / 2);
    path.quadraticBezierTo(
      size.width * 0.7, 
      size.height * 0.7, 
      size.width / 2, 
      size.height
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class LongBalloonPainter extends CustomPainter {
  final Color color;

  LongBalloonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Calculate balloon dimensions
    final balloonWidth = size.width * 0.8;
    final balloonHeight = size.height * 0.93;
    final leftX = size.width * 0.1;
    final topY = 0.0;
    
    // Draw the balloon shape path
    final balloonPath = Path();
    
    // Top rounded part (slightly wider)
    balloonPath.moveTo(leftX + balloonWidth * 0.2, topY);
    balloonPath.quadraticBezierTo(
      leftX + balloonWidth * 0.1, 
      topY + balloonHeight * 0.1,
      leftX, 
      topY + balloonHeight * 0.2
    );
    
    // Left side (curved inward slightly)
    balloonPath.quadraticBezierTo(
      leftX - balloonWidth * 0.05, 
      topY + balloonHeight * 0.5,
      leftX + balloonWidth * 0.1, 
      topY + balloonHeight * 0.8
    );
    
    // Bottom narrowing part
    balloonPath.quadraticBezierTo(
      leftX + balloonWidth * 0.3, 
      topY + balloonHeight * 0.95,
      leftX + balloonWidth * 0.5, 
      topY + balloonHeight
    );
    
    // Right bottom corner
    balloonPath.quadraticBezierTo(
      leftX + balloonWidth * 0.7, 
      topY + balloonHeight * 0.95,
      leftX + balloonWidth * 0.9, 
      topY + balloonHeight * 0.8
    );
    
    // Right side (curved inward slightly)
    balloonPath.quadraticBezierTo(
      leftX + balloonWidth * 1.05, 
      topY + balloonHeight * 0.5,
      leftX + balloonWidth, 
      topY + balloonHeight * 0.2
    );
    
    // Top right corner
    balloonPath.quadraticBezierTo(
      leftX + balloonWidth * 0.9, 
      topY + balloonHeight * 0.1,
      leftX + balloonWidth * 0.8, 
      topY
    );
    
    // Close the path
    balloonPath.close();
    
    // Draw balloon
    canvas.drawPath(balloonPath, paint);
    canvas.drawPath(balloonPath, borderPaint);
    
    // Draw a knot at the bottom
    final knotPaint = Paint()
      ..color = color.withRed((color.red - 20).clamp(0, 255))
      ..style = PaintingStyle.fill;
    
    final knotPath = Path();
    knotPath.addOval(
      Rect.fromCenter(
        center: Offset(leftX + balloonWidth * 0.5, topY + balloonHeight * 0.97),
        width: balloonWidth * 0.15,
        height: balloonHeight * 0.05,
      )
    );
    
    canvas.drawPath(knotPath, knotPaint);
    
    // Add highlights for 3D effect
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    final highlightPath = Path();
    
    // Left side highlight
    highlightPath.moveTo(leftX + balloonWidth * 0.2, topY + balloonHeight * 0.1);
    highlightPath.quadraticBezierTo(
      leftX + balloonWidth * 0.05, 
      topY + balloonHeight * 0.2, 
      leftX + balloonWidth * 0.1, 
      topY + balloonHeight * 0.4
    );
    highlightPath.quadraticBezierTo(
      leftX + balloonWidth * 0.2, 
      topY + balloonHeight * 0.3, 
      leftX + balloonWidth * 0.25, 
      topY + balloonHeight * 0.15
    );
    highlightPath.close();
    
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class PipePainter extends CustomPainter {
  const PipePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final pipeFillPaint = Paint()
      ..color = Colors.brown.shade600
      ..style = PaintingStyle.fill;

    // Draw the pipe
    final rect = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.3,
      size.width * 0.6,
      size.height * 0.7,
    );

    // Pipe top opening
    final topRect = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.2,
      size.width * 0.8,
      size.height * 0.1,
    );

    canvas.drawRect(rect, pipeFillPaint);
    canvas.drawRect(rect, paint);
    
    canvas.drawOval(topRect, pipeFillPaint);
    canvas.drawOval(topRect, paint);

    // Add pipe details - horizontal lines
    final linePaint = Paint()
      ..color = Colors.brown.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.5),
      linePaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.7),
      Offset(size.width * 0.8, size.height * 0.7),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}