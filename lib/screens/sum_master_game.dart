import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/game_state.dart';
import '../widgets/game_grid.dart';
import '../widgets/language_selector.dart';
import '../widgets/next_block_preview.dart';

class SumMasterGame extends StatefulWidget {
  const SumMasterGame({super.key});

  @override
  State<SumMasterGame> createState() => _SumMasterGameState();
}

class _SumMasterGameState extends State<SumMasterGame> {
  late GameState _gameState;
  late Timer _gameTimer;
  final FocusNode _focusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    _startNewGame();
    
    // Set up game timer
    _gameTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (_gameState.status == GameStatus.playing && _gameState.fallingBlock != null) {
        setState(() {
          _gameState = _gameState.moveDown();
        });
      }
    });
  }

  @override
  void dispose() {
    _gameTimer.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _startNewGame() {
    setState(() {
      _gameState = GameState().spawnNewBlock();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(t.sumMasterTitle, 
          style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
        elevation: 5,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startNewGame,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: LanguageSelector(),
          ),
        ],
      ),
      backgroundColor: Colors.lightBlue.shade50,
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: GestureDetector(
          onHorizontalDragEnd: _handleSwipe,
          onTap: () => _focusNode.requestFocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade100,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Text(t.score(_gameState.currentScore), 
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Text(t.level(_gameState.currentLevel), 
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.green.shade300, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Text(
                          t.targetSum(_gameState.targetSum),
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                        ),
                      ),
                      if (_gameState.nextBlock != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            children: [
                              Text(
                                t.next,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple.shade700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              NextBlockPreview(nextBlock: _gameState.nextBlock!),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(
                      t.matches(_gameState.matchesInCurrentLevel, _gameState.matchesToNextLevel),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: GameGrid(gameState: _gameState),
                    ),
                  ),
                ),
                if (_gameState.status == GameStatus.gameOver)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Text(
                            t.gameOver,
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            backgroundColor: Colors.green.shade400,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: _startNewGame,
                          child: Text('${t.playAgain} 🎮'),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.purple.shade200,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: IconButton(
                          iconSize: 48,
                          icon: const Icon(Icons.arrow_left, color: Colors.white),
                          onPressed: () {
                          if (_gameState.status == GameStatus.playing) {
                            setState(() {
                              _gameState = _gameState.moveLeft();
                            });
                          }
                        },
                      ),
                    ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.amber.shade300,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: IconButton(
                          iconSize: 48,
                          icon: const Icon(Icons.arrow_downward, color: Colors.white),
                          onPressed: () {
                          if (_gameState.status == GameStatus.playing) {
                            setState(() {
                              _gameState = _gameState.moveDown();
                            });
                          }
                        },
                      ),
                    ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade300,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: IconButton(
                          iconSize: 48,
                          icon: const Icon(Icons.vertical_align_bottom, color: Colors.white),
                          tooltip: 'Drop (Space)',
                          onPressed: () {
                          if (_gameState.status == GameStatus.playing) {
                            setState(() {
                              _gameState = _gameState.dropBlock();
                            });
                          }
                        },
                      ),
                    ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade300,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: IconButton(
                          iconSize: 48,
                          icon: const Icon(Icons.arrow_right, color: Colors.white),
                          onPressed: () {
                          if (_gameState.status == GameStatus.playing) {
                            setState(() {
                              _gameState = _gameState.moveRight();
                            });
                          }
                        },
                      ),
                    ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent && _gameState.status == GameStatus.playing) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        setState(() {
          _gameState = _gameState.moveLeft();
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        setState(() {
          _gameState = _gameState.moveRight();
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          _gameState = _gameState.moveDown();
        });
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        // Drop block when space is pressed
        setState(() {
          _gameState = _gameState.dropBlock();
        });
      }
    }
  }

  void _handleSwipe(DragEndDetails details) {
    if (_gameState.status != GameStatus.playing) return;
    
    if (details.primaryVelocity! < 0) {
      // Swiped left to right
      setState(() {
        _gameState = _gameState.moveRight();
      });
    } else if (details.primaryVelocity! > 0) {
      // Swiped right to left
      setState(() {
        _gameState = _gameState.moveLeft();
      });
    }
  }
}
