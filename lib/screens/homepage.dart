import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
  int rowSize = 10;
  int totalSquares = 100;
  bool foodVisible = false;
  var currentDirection = Snake_Direction.RIGHT;

  //snake-position
  List<int> snakePos = [0, 1, 2];

  //food position
  int foodPos = 55;

  //start game method
  startGame() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        //add new head
        snakePos.add(snakePos.last + 1);
        //remove tail
        snakePos.removeAt(0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 8,
        title: Text('Snake Game',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          //scroes
          Expanded(child: Container()),

          //main game
          Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dx > 0) {
                    //move down
                    currentDirection = Snake_Direction.DOWN;
                  } else {
                    //move up
                    currentDirection = Snake_Direction.UP;
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0) {
                    //move right
                    currentDirection = Snake_Direction.RIGHT;
                  } else {
                    //move left
                    currentDirection = Snake_Direction.LEFT;
                  }
                },
                child: GridView.builder(
                  itemCount: totalSquares,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowSize),
                  itemBuilder: (context, index) {
                    if (snakePos.contains(index)) {
                      return SnakePixel();
                    } else if (foodPos == index) {
                      return FoodPixel();
                    } else
                      return BlankPixel();
                  },
                ),
              )),

          //play button
          Expanded(
              child: Center(
                  child: MaterialButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'PLAY',
                            style: TextStyle(color: Colors.white, fontSize: 23),
                          ),
                        ],
                      ),
                      onPressed: startGame())))
        ],
      ),
    );
  }
}
