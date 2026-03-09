import 'dart:math';

/// Enum representing possible snake movement directions.
enum SnakeDirection { UP, DOWN, LEFT, RIGHT }

class GameLogic {
  /// How many squares per row/column (defaults to 10).
  int rowSize;

  /// Computed total number of squares on the board.
  int get totalSquares => rowSize * rowSize;

  /// Indices occupied by the snake, head is last element.
  List<int> snakePos;

  /// Current food location.
  int foodPos;

  /// Player score (number of food eaten).
  int score;

  /// Current travel direction of the snake.
  SnakeDirection currentDirection;

  GameLogic({
    this.rowSize = 10,
    List<int>? snakePos,
    this.foodPos = 55,
    this.score = 0,
    this.currentDirection = SnakeDirection.RIGHT,
  }) : snakePos = snakePos ?? [0, 1, 2];

  /// Attempts to eat the food if the head has moved onto it.
  void eatFood() {
    score++;
    // make sure food does not pop up where snake body is
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalSquares - 1);
    }
  }

  /// Advances the snake by one square, wrapping at edges.
  ///
  /// The method will also call [eatFood] when the head lands on the
  /// food square and remove the tail when no food was eaten.
  void moveSnake() {
    switch (currentDirection) {
      case SnakeDirection.RIGHT:
        if (snakePos.last % rowSize == rowSize - 1) {
          snakePos.add(snakePos.last + 1 - rowSize);
        } else {
          snakePos.add(snakePos.last + 1);
        }
        break;
      case SnakeDirection.LEFT:
        if (snakePos.last % rowSize == 0) {
          snakePos.add(snakePos.last - 1 + rowSize);
        } else {
          snakePos.add(snakePos.last - 1);
        }
        break;
      case SnakeDirection.UP:
        if (snakePos.last < rowSize) {
          snakePos.add(snakePos.last + rowSize * rowSize);
        } else {
          snakePos.add(snakePos.last - rowSize);
        }
        break;
      case SnakeDirection.DOWN:
        if (snakePos.last >= rowSize * (rowSize - 1)) {
          snakePos.add(snakePos.last - rowSize * rowSize);
        } else {
          snakePos.add(snakePos.last + rowSize);
        }
        break;
    }

    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      snakePos.removeAt(0);
    }
  }

  /// Returns true if the snake has collided with itself.
  bool gameOver() {
    final body = snakePos.sublist(0, snakePos.length - 1);
    return body.contains(snakePos.last);
  }

  /// Resets game state to an initial board.
  void newGame() {
    snakePos = [0, 1, 2];
    foodPos = 55;
    score = 0;
    currentDirection = SnakeDirection.RIGHT;
  }

  /// Plain alias for [newGame], kept for compatibility.
  void reset() => newGame();

  /// Convenience helper for updating the direction, preventing
  /// the snake from reversing directly onto itself.
  void setDirection(SnakeDirection direction) {
    if ((currentDirection == SnakeDirection.LEFT &&
            direction == SnakeDirection.RIGHT) ||
        (currentDirection == SnakeDirection.RIGHT &&
            direction == SnakeDirection.LEFT) ||
        (currentDirection == SnakeDirection.UP &&
            direction == SnakeDirection.DOWN) ||
        (currentDirection == SnakeDirection.DOWN &&
            direction == SnakeDirection.UP)) {
      return; // ignore opposite direction moves
    }
    currentDirection = direction;
  }
}
