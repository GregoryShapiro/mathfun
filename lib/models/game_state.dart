import 'dart:math';
import 'game_block.dart';

enum GameStatus { playing, gameOver }

class GameState {
  final int gridWidth = 8;
  final int gridHeight = 10;
  final int targetSum;
  final int maxNumber;
  final int matchesToNextLevel;
  final int currentScore;
  final int currentLevel;
  final int matchesInCurrentLevel;
  final List<List<GameBlock?>> grid;
  final GameBlock? fallingBlock;
  final GameBlock? nextBlock; // Preview of the next block
  final GameStatus status;
  final Random random = Random();

  GameState({
    this.targetSum = 10,
    this.maxNumber = 5,
    this.matchesToNextLevel = 15,
    this.currentScore = 0,
    this.currentLevel = 1,
    this.matchesInCurrentLevel = 0,
    List<List<GameBlock?>>? grid,
    this.fallingBlock,
    this.nextBlock,
    this.status = GameStatus.playing,
  }) : grid = grid ?? List.generate(
          20,
          (y) => List.generate(
            10,
            (x) => null,
          ),
        );

  GameState copyWith({
    int? targetSum,
    int? maxNumber,
    int? matchesToNextLevel,
    int? currentScore,
    int? currentLevel,
    int? matchesInCurrentLevel,
    List<List<GameBlock?>>? grid,
    GameBlock? fallingBlock,
    GameBlock? nextBlock,
    GameStatus? status,
  }) {
    return GameState(
      targetSum: targetSum ?? this.targetSum,
      maxNumber: maxNumber ?? this.maxNumber,
      matchesToNextLevel: matchesToNextLevel ?? this.matchesToNextLevel,
      currentScore: currentScore ?? this.currentScore,
      currentLevel: currentLevel ?? this.currentLevel,
      matchesInCurrentLevel: matchesInCurrentLevel ?? this.matchesInCurrentLevel,
      grid: grid ?? this.grid,
      fallingBlock: fallingBlock,
      nextBlock: nextBlock ?? this.nextBlock,
      status: status ?? this.status,
    );
  }

  GameState spawnNewBlock() {
    if (status == GameStatus.gameOver) return this;
    
    // Check if game is over (top row has blocks)
    if (grid[0].any((block) => block != null)) {
      return copyWith(status: GameStatus.gameOver);
    }

    // If we have a next block, use it as the falling block
    if (nextBlock != null) {
      // Create a new falling block at the top of the grid
      final newFallingBlock = GameBlock(
        value: nextBlock!.value,
        x: random.nextInt(gridWidth), // Random horizontal position
        y: 0, // Start at the top
      );
      
      // Generate a new "next block"
      final int nextValue = random.nextInt(maxNumber) + 1;
      final newNextBlock = GameBlock(value: nextValue, x: 0, y: 0);
      
      return copyWith(
        fallingBlock: newFallingBlock,
        nextBlock: newNextBlock,
      );
    } else {
      // First block at game start - generate both current and next
      final int currentValue = random.nextInt(maxNumber) + 1;
      final int nextValue = random.nextInt(maxNumber) + 1;
      final int x = random.nextInt(gridWidth);
      
      return copyWith(
        fallingBlock: GameBlock(value: currentValue, x: x, y: 0),
        nextBlock: GameBlock(value: nextValue, x: 0, y: 0),
      );
    }
  }

  bool _isValidPosition(int x, int y) {
    if (x < 0 || x >= gridWidth || y < 0 || y >= gridHeight) return false;
    return grid[y][x] == null;
  }

  GameState moveLeft() {
    if (fallingBlock == null || status != GameStatus.playing) return this;
    
    final newX = fallingBlock!.x - 1;
    if (_isValidPosition(newX, fallingBlock!.y)) {
      return copyWith(
        fallingBlock: fallingBlock!.copyWith(x: newX),
      );
    }
    return this;
  }

  GameState moveRight() {
    if (fallingBlock == null || status != GameStatus.playing) return this;
    
    final newX = fallingBlock!.x + 1;
    if (_isValidPosition(newX, fallingBlock!.y)) {
      return copyWith(
        fallingBlock: fallingBlock!.copyWith(x: newX),
      );
    }
    return this;
  }

  GameState moveDown() {
    if (fallingBlock == null || status != GameStatus.playing) return this;
    
    final newY = fallingBlock!.y + 1;
    if (_isValidPosition(fallingBlock!.x, newY)) {
      return copyWith(
        fallingBlock: fallingBlock!.copyWith(y: newY),
      );
    } else {
      // Block has landed
      return _placeFallingBlock();
    }
  }
  
  // Instantly drop the block to the bottom
  GameState dropBlock() {
    if (fallingBlock == null || status != GameStatus.playing) return this;
    
    int newY = fallingBlock!.y;
    
    // Find the lowest valid position
    while (_isValidPosition(fallingBlock!.x, newY + 1)) {
      newY++;
    }
    
    // Place the block at the lowest position
    return copyWith(
      fallingBlock: fallingBlock!.copyWith(y: newY),
    )._placeFallingBlock();
  }

  GameState _placeFallingBlock() {
    if (fallingBlock == null) return this;

    // Create a new grid with the falling block placed
    final newGrid = List.generate(
      gridHeight,
      (y) => List.generate(
        gridWidth,
        (x) => grid[y][x],
      ),
    );

    // If the block landed at position (0,0), game is over
    if (fallingBlock!.y == 0) {
      return copyWith(status: GameStatus.gameOver);
    }

    newGrid[fallingBlock!.y][fallingBlock!.x] = fallingBlock;

    // Check for matches and clear them
    return _checkForMatches(newGrid, fallingBlock!.x, fallingBlock!.y);
  }

  GameState _checkForMatches(List<List<GameBlock?>> newGrid, int landedX, int landedY) {
    int newScore = currentScore;
    int newMatches = matchesInCurrentLevel;
    bool foundMatches = false;
    
    // Process matches in a cascade until no more matches are found
    do {
      foundMatches = false;
      
      // Check all rows for matches
      for (int row = 0; row < gridHeight; row++) {
        for (int x1 = 0; x1 < gridWidth; x1++) {
          if (newGrid[row][x1] == null) continue;
          
          int rowSum = 0;
          int rx2 = -1;
          
          for (int x2 = x1; x2 < gridWidth; x2++) {
            if (newGrid[row][x2] == null) break;
            
            rowSum += newGrid[row][x2]!.value;
            
            if (rowSum == targetSum) {
              // Found a match!
              foundMatches = true;
              rx2 = x2;
              
              // Clear the matched blocks
              for (int x = x1; x <= rx2; x++) {
                newGrid[row][x] = null;
              }
              
              newScore += targetSum;
              newMatches++;
              
              print('Found row match from ($x1,$row) to ($rx2,$row) with sum $targetSum');
              break;
            } else if (rowSum > targetSum) {
              // Exceeded target, no match
              break;
            }
          }
          
          // Skip ahead if we found a match
          if (rx2 != -1) {
            x1 = rx2;
          }
        }
      }
      
      // Check all columns for matches
      for (int col = 0; col < gridWidth; col++) {
        for (int y1 = 0; y1 < gridHeight; y1++) {
          if (newGrid[y1][col] == null) continue;
          
          int colSum = 0;
          int ry2 = -1;
          
          for (int y2 = y1; y2 < gridHeight; y2++) {
            if (newGrid[y2][col] == null) break;
            
            colSum += newGrid[y2][col]!.value;
            
            if (colSum == targetSum) {
              // Found a match!
              foundMatches = true;
              ry2 = y2;
              
              // Clear the matched blocks
              for (int y = y1; y <= ry2; y++) {
                newGrid[y][col] = null;
              }
              
              newScore += targetSum;
              newMatches++;
              
              print('Found column match from ($col,$y1) to ($col,$ry2) with sum $targetSum');
              break;
            } else if (colSum > targetSum) {
              // Exceeded target, no match
              break;
            }
          }
          
          // Skip ahead if we found a match
          if (ry2 != -1) {
            y1 = ry2;
          }
        }
      }
      
      // Apply gravity if matches were found
      if (foundMatches) {
        newGrid = _applyGravity(newGrid);
        print('Applied gravity, checking for cascade matches...');
      }
      
    } while (foundMatches); // Continue as long as new matches are found
    
    // Check for level progression
    if (newMatches >= matchesToNextLevel) {
      // Level up
      print('Level up! New level: ${currentLevel + 1}');
      return copyWith(
        grid: newGrid,
        fallingBlock: null,
        currentScore: newScore,
        currentLevel: currentLevel + 1,
        matchesInCurrentLevel: 0,
        targetSum: targetSum + 3,
        maxNumber: maxNumber + 2,
      ).spawnNewBlock();
    }
    
    return copyWith(
      grid: newGrid,
      fallingBlock: null,
      currentScore: newScore,
      matchesInCurrentLevel: newMatches,
    ).spawnNewBlock();
  }

  List<List<GameBlock?>> _applyGravity(List<List<GameBlock?>> newGrid) {
    // For each column
    for (int x = 0; x < gridWidth; x++) {
      // Start from the bottom and move up
      for (int bottomY = gridHeight - 1; bottomY > 0; bottomY--) {
        if (newGrid[bottomY][x] == null) {
          // Find the closest block above
          for (int topY = bottomY - 1; topY >= 0; topY--) {
            if (newGrid[topY][x] != null) {
              // Move the block down
              newGrid[bottomY][x] = GameBlock(
                value: newGrid[topY][x]!.value,
                x: x,
                y: bottomY,
              );
              newGrid[topY][x] = null;
              break;
            }
          }
        }
      }
    }
    return newGrid;
  }
}