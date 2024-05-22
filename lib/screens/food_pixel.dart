import 'package:flutter/material.dart';

class FoodPixel extends StatelessWidget {
  FoodPixel({super.key});
  Color foodColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
            color: foodColor, borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}
