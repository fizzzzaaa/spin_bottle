import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(CoinFlipApp());

class CoinFlipApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Flip Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CoinFlipHome(),
    );
  }
}

class CoinFlipHome extends StatefulWidget {
  @override
  _CoinFlipHomeState createState() => _CoinFlipHomeState();
}

class _CoinFlipHomeState extends State<CoinFlipHome> with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Declare as late
  late Animation<double> _flipAnimation; // Rotation animation on X-axis
  late Animation<double> _bounceAnimation; // Vertical bounce animation
  bool isFlipping = false;
  String coinFace = 'Heads'; // Default face is heads
  int points = 0;
  String message = 'Guess Heads or Tails!';

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with faster speed
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800), // Faster animation
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isFlipping = false;
          _controller.reset();
        });
      }
    });

    // Tween for vertical translation (Y-axis bounce)
    _bounceAnimation = Tween<double>(begin: 0, end: -200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Tween for rotation on the X-axis (forward flip)
    _flipAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void flipCoin(String guess) {
    if (isFlipping) return;

    setState(() {
      isFlipping = true;
      message = 'Flipping...';
    });

    _controller.forward().then((_) {
      Random random = Random();
      bool isHeads = random.nextBool();
      String result = isHeads ? 'Heads' : 'Tails';

      setState(() {
        coinFace = result;
        if (guess == result) {
          points += 1;
          message = 'Correct! You guessed $guess';
        } else {
          message = 'Wrong! It was $result';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Flip Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..translate(0.0, _bounceAnimation.value, 0.0) // Vertical movement
                    ..rotateX(_flipAnimation.value), // Rotate on X-axis for forward flip
                  child: Image.asset(
                    coinFace == 'Heads' ? 'images/heads.jpeg' : 'images/tails.jpeg',
                    width: 100, // Reduced image width
                    height: 100, // Reduced image height
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => flipCoin('Heads'),
                  child: Text('Heads'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => flipCoin('Tails'),
                  child: Text('Tails'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Points: $points',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
