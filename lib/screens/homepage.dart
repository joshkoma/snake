import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snake/blankpixel.dart';
import 'package:snake/screens/food_pixel.dart';
import 'package:snake/snake_pixel.dart';
import 'package:snake/state/game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // game logic and UI state
  final GameLogic _game = GameLogic();
  bool pausestatus = false;
  bool gamestarted = false;

  //start game method
  startGame() {
    gamestarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        if (!pausestatus) {
          _game.moveSnake();
          if (_game.gameOver()) {
            timer.cancel();
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
                          'You current score is ${_game.score}',
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
      _game.newGame();
      gamestarted = false;
    });
  }

  void pause() {
    pausestatus = true;
  }

  void reset() {
    setState(() {
      _game.reset();
      gamestarted = false;
    });
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
                'Score: ${_game.score}',
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
                      _game.currentDirection != SnakeDirection.UP) {
                    //move down
                    _game.setDirection(SnakeDirection.DOWN);
                    print('swiped down');
                  } else if (details.delta.dy < 0 &&
                      _game.currentDirection != SnakeDirection.DOWN) {
                    //move up
                    _game.setDirection(SnakeDirection.UP);
                    print('swipe up');
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0 &&
                      _game.currentDirection != SnakeDirection.LEFT) {
                    print('swipe right');
                    _game.setDirection(SnakeDirection.RIGHT);
                  } else if (details.delta.dx < 0 &&
                      _game.currentDirection != SnakeDirection.RIGHT) {
                    print('swipe left');
                    _game.setDirection(SnakeDirection.LEFT);
                  }
                },
                child: GridView.builder(
                  itemCount: _game.totalSquares,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _game.rowSize),
                  itemBuilder: (context, index) {
                    if (_game.snakePos.contains(index)) {
                      return const SnakePixel();
                    } else if (_game.foodPos == index) {
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
