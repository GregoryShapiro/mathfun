import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/multiplication_game_state.dart';
import '../widgets/multiplication_game_grid.dart';
import '../widgets/multiplication_next_block_preview.dart';

class MultiplicationMasterGame extends StatefulWidget {
  const MultiplicationMasterGame({super.key});

  @override
  State<MultiplicationMasterGame> createState() => _MultiplicationMasterGameState();
}

class _MultiplicationMasterGameState extends State<MultiplicationMasterGame> {
  late MultiplicationGameState gameState;
  Timer? gameTimer;
  final FocusNode _focusNode = FocusNode();
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    gameState = MultiplicationGameState.initial();
    startGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void startGame() {
    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      setState(() {
        gameState = gameState.tick();
      });
    });
  }

  void resetGame() {
    setState(() {
      gameState = MultiplicationGameState.initial();
    });
    startGame();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        setState(() {
          gameState = gameState.moveLeft();
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        setState(() {
          gameState = gameState.moveRight();
        });
      } else if (event.logicalKey == LogicalKeyboardKey.space || 
                 event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          gameState = gameState.drop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      autofocus: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${t.multiplicationMasterTitle} 🔢'),
          backgroundColor: const Color.fromARGB(255, 77, 190, 255),
          foregroundColor: const Color.fromARGB(255, 224, 21, 21),
        ),
        body: gameState.isGameOver 
          ? _buildGameOverScreen(t)
          : _buildGameScreen(t),
      ),
    );
  }

  Widget _buildGameScreen(AppLocalizations t) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange.shade100, Colors.orange.shade200],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top info row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoCard(
                    title: 'Score',
                    value: '${gameState.score}',
                    color: Colors.orange.shade300,
                  ),
                  _buildInfoCard(
                    title: 'Level',
                    value: '${gameState.level}',
                    color: Colors.orange.shade400,
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.favorite,
                        color: index < gameState.hearts 
                            ? Colors.red.shade300
                            : Colors.grey.shade300,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Game grid - takes most of the screen
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 89, 158, 101),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: MultiplicationGameGrid(gameState: gameState),
              ),
            ),
            
            // Next block preview - small and to the side
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Next:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  MultiplicationNextBlockPreview(
                    equation: gameState.nextBlock?.equation ?? '0×0',
                  ),
                  // Controls row - at the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade300,
                          foregroundColor: Colors.white,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          minimumSize: const Size(40, 40),
                        ),
                        onPressed: () {
                          setState(() {
                            gameState = gameState.moveLeft();
                          });
                        },
                        child: const Icon(Icons.arrow_left, size: 24),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade400,
                          foregroundColor: Colors.white,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          minimumSize: const Size(40, 40),
                        ),
                        onPressed: () {
                          setState(() {
                            gameState = gameState.drop();
                          });
                        },
                        child: const Icon(Icons.arrow_drop_down, size: 24),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade300,
                          foregroundColor: Colors.white,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          minimumSize: const Size(40, 40),
                        ),
                        onPressed: () {
                          setState(() {
                            gameState = gameState.moveRight();
                          });
                        },
                        child: const Icon(Icons.arrow_right, size: 24),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverScreen(AppLocalizations t) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange.shade100, Colors.orange.shade200],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Over!',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Final Score: ${gameState.score}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Level: ${gameState.level}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade400,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: resetGame,
              child: Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required Color color,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white),
                const SizedBox(width: 4),
              ],
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}