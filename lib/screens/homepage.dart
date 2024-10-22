import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snake/blankpixel.dart';
import 'package:snake/screens/food_pixel.dart';
import 'package:snake/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Snake_Direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //initialize startup
  int rowSize = 10;
  int totalSquares = 100;
  var currentDirection = Snake_Direction.RIGHT;
  bool pausestatus = false;
  int score = 0;
  bool gamestarted = false;
  //snake-position
  List<int> snakePos = [0, 1, 2];

  //food position
  int foodPos = 55;

  //start game method
  startGame() {
    gamestarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        if (pausestatus == false) {
          moveSnake();
          //check if game over
          if (gameOver()) {
            timer.cancel();

            //display alert dialog
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      'Game Over!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    content: Column(
                      children: [
                        Text(
                          'You current score is $score',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const TextField(
                            decoration: InputDecoration(
                          hintText: 'Enter your name',
                        ))
                      ],
                    ),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          submitScore();
                          Navigator.pop(context);
                          newGame();
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  );
                });
          }
        } else {
          timer.cancel();
        }
      });
    });
  }

  void submitScore() {}

  void newGame() {
    setState(() {
      snakePos = [0, 1, 2];
      foodPos = 55;
      score = 0;
      currentDirection = Snake_Direction.RIGHT;
      gamestarted = false;
      score = 0;
    });
  }

  void pause() {
    pausestatus == true;
  }

  void reset() {
    snakePos = [0, 1, 2];
    foodPos = 55;
    score = 0;
    currentDirection = Snake_Direction.RIGHT;
    gamestarted = false;
  }

  void eatFood() {
    //increase current score
    score++;
    //make sure food does not pop up where snake body is
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(99);
    }
  }

  void moveSnake() {
    pausestatus == false;
    switch (currentDirection) {
      case Snake_Direction.RIGHT:
        {
          //avoid snake moving to  next line
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          }
          //add head
          else {
            snakePos.add(snakePos.last + 1);
          }
        }

        break;
      case Snake_Direction.LEFT:
        {
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }

        break;
      case Snake_Direction.UP:
        {
          if (snakePos.last < 9) {
            snakePos.add(snakePos.last + rowSize * 10);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case Snake_Direction.DOWN:
        {
          if (snakePos.last > 90) {
            snakePos.add(snakePos.last - rowSize * 10);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
      default:
    }

    if (snakePos.last == foodPos) {
      eatFood();
    }
    //otherwise remove tail
    else {
      snakePos.removeAt(0);
    }
  }

  bool gameOver() {
    //game is over when the snake runs into itself
    //create a sublist
    List<int> bodysnake = snakePos.sublist(0, snakePos.length - 1);
    if (bodysnake.contains(snakePos.last)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        elevation: 8,
        title: const Text('Snake Game',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          //scroes
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Score: $score',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'Highscore: ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21),
              )
            ],
          )),

          //main game
          Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0 &&
                      currentDirection != Snake_Direction.UP) {
                    //move down
                    currentDirection = Snake_Direction.DOWN;
                    print('swiped down');
                  } else if (details.delta.dy < 0 &&
                      currentDirection != Snake_Direction.DOWN) {
                    //move up
                    currentDirection = Snake_Direction.UP;
                    print('swipe up');
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0 &&
                      currentDirection != Snake_Direction.LEFT) {
                    print('swipe right');
                    //move right
                    currentDirection = Snake_Direction.RIGHT;
                  } else if (details.delta.dx < 0 &&
                      currentDirection != Snake_Direction.RIGHT) {
                    print('swipe left');
                    //move left
                    currentDirection = Snake_Direction.LEFT;
                  }
                },
                child: GridView.builder(
                  itemCount: totalSquares,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowSize),
                  itemBuilder: (context, index) {
                    if (snakePos.contains(index)) {
                      return const SnakePixel();
                    } else if (foodPos == index) {
                      return FoodPixel();
                    } else {
                      return const BlankPixel();
                    }
                  },
                ),
              )),

          //play button
          Expanded(
              child: Center(
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: gamestarted ? () {} : startGame,
                  child: const Text('PLAY')),
              ElevatedButton(onPressed: pause, child: const Text('PAUSE')),
              ElevatedButton(onPressed: reset, child: const Text('RESET'))
            ],
          )))
        ],
      ),
    );
  }
}
