import 'package:flutter/material.dart';

class MultiplicationNextBlockPreview extends StatelessWidget {
  final String equation;

  const MultiplicationNextBlockPreview({
    super.key,
    required this.equation,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a color based on the equation
    final parts = equation.split('×');
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
    
    return Container(
      width: 50,
      height: 70,
      child: Stack(
        children: [
          // Balloon shape
          CustomPaint(
            size: Size.infinite,
            painter: NextBalloonPainter(
              color: balloonColor,
            ),
          ),
          
          // Equation text drawn vertically
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (parts.length == 2) ...[
                  Text(
                    parts[0],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "×",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    parts[1],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "=",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ] else ...[
                  Text(
                    equation,
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
        ],
      ),
    );
  }
}

class BalloonPainter extends CustomPainter {
  final Color color;

  BalloonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw balloon body (rounded rectangle)
    RRect balloonShape = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.9),
      const Radius.circular(10),
    );

    // Draw the main balloon shape
    canvas.drawRRect(balloonShape, paint);
    canvas.drawRRect(balloonShape, borderPaint);

    // Draw highlights for 3D effect
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final Path highlightPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.3, 
        size.height * 0.3, 
        size.width * 0.1, 
        size.height * 0.4
      )
      ..quadraticBezierTo(
        size.width * 0.15, 
        size.height * 0.2, 
        size.width * 0.2, 
        size.height * 0.2
      );

    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class NextBalloonPainter extends CustomPainter {
  final Color color;

  NextBalloonPainter({required this.color});

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

class StringPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.brown.shade800
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw string
    final Path path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width / 2, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}