import 'package:flutter/material.dart';

class RepeatRefactorCode extends StatelessWidget {

  final VoidCallback onPressed;
  final Color colors;
  final Widget? cardwidget;
  RepeatRefactorCode({required this.colors, this.cardwidget, required  this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: colors,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: cardwidget,
      ),

    );
  }
}