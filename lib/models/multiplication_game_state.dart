import 'dart:math';
import 'multiplication_game_block.dart';

class MultiplicationGameState {
  static const int gridWidth = 10;
  static const int gridHeight = 15;
  static const int maxHearts = 5;
  static const int minPipes = 0;
  static const int maxPipes = 9;
  
  final List<List<MultiplicationGameBlock?>> grid;
  final MultiplicationGameBlock? currentBlock;
  final MultiplicationGameBlock? nextBlock;
  final bool isGameOver;
  final int score;
  final int level;
  final int hearts;
  final int matchesInLevel;
  final int requiredMatches;
  final Random random;

  MultiplicationGameState({
    required this.grid,
    required this.currentBlock,
    required this.nextBlock,
    required this.isGameOver,
    required this.score,
    required this.level,
    required this.hearts,
    required this.matchesInLevel,
    required this.requiredMatches,
    Random? random,
  }) : random = random ?? Random();

  factory MultiplicationGameState.initial() {
    final random = Random();
    
    // Create empty grid
    final grid = List<List<MultiplicationGameBlock?>>.generate(
      gridHeight,
      (y) => List<MultiplicationGameBlock?>.generate(gridWidth, (x) => null),
    );
    
    // Setup pipes at the bottom
    for (int x = 0; x < gridWidth; x++) {
      grid[gridHeight - 1][x] = MultiplicationGameBlock(
        value: x.toString(),
        equation: '',
        x: x,
        y: gridHeight - 1,
        isPipe: true,
      );
    }
    
    // Create initial block
    final firstBlock = _generateBlock(random, 1);
    final nextBlock = _generateBlock(random, 1);
    
    return MultiplicationGameState(
      grid: grid,
      currentBlock: firstBlock,
      nextBlock: nextBlock,
      isGameOver: false,
      score: 0,
      level: 1,
      hearts: maxHearts,
      matchesInLevel: 0,
      requiredMatches: 10,
      random: random,
    );
  }

  static MultiplicationGameBlock _generateBlock(Random random, int level) {
    int a, b;
    
    // Level 10 is random equations
    if (level == 10) {
      a = random.nextInt(10) + 1;
      b = random.nextInt(10) + 1;
    } else {
      // Levels 1-9 use specific multiplication tables
      a = level;
      b = random.nextInt(10) + 1;
    }
    
    int result = a * b;
    String equation = '$a×$b';
    
    return MultiplicationGameBlock(
      value: result.toString(),
      equation: equation,
      x: gridWidth ~/ 2,
      y: 0,
      isPipe: false,
    );
  }

  // Move current block left
  MultiplicationGameState moveLeft() {
    if (currentBlock == null || isGameOver) return this;
    
    final block = currentBlock!;
    if (block.x <= 0) return this;
    
    final newX = block.x - 1;
    if (grid[block.y][newX] != null && !grid[block.y][newX]!.isPipe) return this;
    
    final newBlock = block.copyWith(x: newX);
    return copyWith(currentBlock: newBlock);
  }

  // Move current block right
  MultiplicationGameState moveRight() {
    if (currentBlock == null || isGameOver) return this;
    
    final block = currentBlock!;
    if (block.x >= gridWidth - 1) return this;
    
    final newX = block.x + 1;
    if (grid[block.y][newX] != null && !grid[block.y][newX]!.isPipe) return this;
    
    final newBlock = block.copyWith(x: newX);
    return copyWith(currentBlock: newBlock);
  }

  // Drop current block all the way down
  MultiplicationGameState drop() {
    if (currentBlock == null || isGameOver) return this;
    
    var state = this;
    var canMoveDown = true;
    
    while (canMoveDown) {
      final nextState = state._moveDown();
      if (nextState == state) {
        canMoveDown = false;
      } else {
        state = nextState;
      }
    }
    
    return state;
  }

  // Game tick - move blocks down
  MultiplicationGameState tick() {
    if (isGameOver || currentBlock == null) return this;
    return _moveDown();
  }

  // Internal helper to move current block down one step
  MultiplicationGameState _moveDown() {
    if (currentBlock == null) return this;
    
    final block = currentBlock!;
    final newY = block.y + 1;
    
    // Check if we've reached the pipe row
    if (newY >= gridHeight - 1) {
      return _checkAnswer();
    }
    
    // Check if we'd hit another block
    if (newY < gridHeight && grid[newY][block.x] != null && !grid[newY][block.x]!.isPipe) {
      return _checkAnswer();
    }
    
    // Move down
    final newBlock = block.copyWith(y: newY);
    return copyWith(currentBlock: newBlock);
  }

  // Check if the answer is correct
  MultiplicationGameState _checkAnswer() {
    if (currentBlock == null) return this;
    
    final block = currentBlock!;
    final targetPipeIndex = int.parse(block.value) % 10;
    
    // Create updated grid with placed block
    final newGrid = List.generate(
      gridHeight,
      (y) => List.generate(
        gridWidth,
        (x) => grid[y][x],
      ),
    );
    
    // Temporary - we'll remove this if correct or keep if wrong
    newGrid[block.y][block.x] = block;
    
    // Check if the answer is correct (block value matches pipe number)
    final int blockValue = int.parse(block.value);
    final int pipeValue = block.x;
    final bool isCorrect = (blockValue % 10) == pipeValue;
    
    int newScore = score;
    int newHearts = hearts;
    int newMatchesInLevel = matchesInLevel;
    bool gameOver = isGameOver;
    
    if (isCorrect) {
      // Correct answer - increase score
      newScore += level * 10;
      newMatchesInLevel += 1;
      
      // Clear the placed block
      newGrid[block.y][block.x] = null;
    } else {
      // Wrong answer - lose a heart
      newHearts -= 1;
      if (newHearts <= 0) {
        gameOver = true;
      }
    }
    
    // Check for level completion
    int newLevel = level;
    if (newMatchesInLevel >= requiredMatches && !gameOver) {
      newLevel += 1;
      newMatchesInLevel = 0;
      
      // Cap at level 10
      if (newLevel > 10) {
        newLevel = 10;
      }
    }
    
    // Check for game over due to stacking
    if (block.y <= 1 && !isCorrect) {
      gameOver = true;
    }
    
    // Generate next block
    final newNextBlock = _generateBlock(random, newLevel);
    
    return copyWith(
      grid: newGrid,
      currentBlock: nextBlock,
      nextBlock: newNextBlock,
      score: newScore,
      hearts: newHearts,
      level: newLevel,
      matchesInLevel: newMatchesInLevel,
      isGameOver: gameOver,
    );
  }

  // Helper to create a new game state with specific changes
  MultiplicationGameState copyWith({
    List<List<MultiplicationGameBlock?>>? grid,
    MultiplicationGameBlock? currentBlock,
    MultiplicationGameBlock? nextBlock,
    bool? isGameOver,
    int? score,
    int? level,
    int? hearts,
    int? matchesInLevel,
    int? requiredMatches,
  }) {
    return MultiplicationGameState(
      grid: grid ?? this.grid,
      currentBlock: currentBlock ?? this.currentBlock,
      nextBlock: nextBlock ?? this.nextBlock,
      isGameOver: isGameOver ?? this.isGameOver,
      score: score ?? this.score,
      level: level ?? this.level,
      hearts: hearts ?? this.hearts,
      matchesInLevel: matchesInLevel ?? this.matchesInLevel,
      requiredMatches: requiredMatches ?? this.requiredMatches,
      random: random,
    );
  }
}