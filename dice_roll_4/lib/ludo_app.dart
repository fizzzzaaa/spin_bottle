import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(DiceApp());

class DiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ludo App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: DiceScreen(),
    );
  }
}

class DiceScreen extends StatefulWidget {
  @override
  _DiceScreenState createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> with TickerProviderStateMixin {
  // Dice values
  int _diceNumber1 = 1;
  int _diceNumber2 = 1;
  int _diceNumber3 = 1;
  int _diceNumber4 = 1;

  // Player scores
  int _score1 = 0;
  int _score2 = 0;
  int _score3 = 0;
  int _score4 = 0;

  int _currentTurn = 1; // Start with Player 1's turn
  int _turnsTaken = 0; // Track the number of turns taken

  late AnimationController _controller1;
  late Animation<double> _animation1;

  late AnimationController _controller2;
  late Animation<double> _animation2;

  late AnimationController _controller3;
  late Animation<double> _animation3;

  late AnimationController _controller4;
  late Animation<double> _animation4;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation1 = Tween<double>(begin: 0, end: 2 * pi).animate(_controller1);

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation2 = Tween<double>(begin: 0, end: 2 * pi).animate(_controller2);

    _controller3 = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation3 = Tween<double>(begin: 0, end: 2 * pi).animate(_controller3);

    _controller4 = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation4 = Tween<double>(begin: 0, end: 2 * pi).animate(_controller4);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  // Roll dice based on the current turn and update the player's score
  void _rollDice() async {
    if (_turnsTaken < 4) {
      bool isSix = false;

      switch (_currentTurn) {
        case 1:
          _controller1.forward(from: 0);
          await Future.delayed(Duration(milliseconds: 300));
          setState(() {
            _diceNumber1 = Random().nextInt(6) + 1;
            _score1 += _diceNumber1; // Update Player 1's score
            isSix = _diceNumber1 == 6;
          });
          break;
        case 2:
          _controller2.forward(from: 0);
          await Future.delayed(Duration(milliseconds: 300));
          setState(() {
            _diceNumber2 = Random().nextInt(6) + 1;
            _score2 += _diceNumber2; // Update Player 2's score
            isSix = _diceNumber2 == 6;
          });
          break;
        case 3:
          _controller3.forward(from: 0);
          await Future.delayed(Duration(milliseconds: 300));
          setState(() {
            _diceNumber3 = Random().nextInt(6) + 1;
            _score3 += _diceNumber3; // Update Player 3's score
            isSix = _diceNumber3 == 6;
          });
          break;
        case 4:
          _controller4.forward(from: 0);
          await Future.delayed(Duration(milliseconds: 300));
          setState(() {
            _diceNumber4 = Random().nextInt(6) + 1;
            _score4 += _diceNumber4; // Update Player 4's score
            isSix = _diceNumber4 == 6;
          });
          break;
      }

      // If dice result is not 6, move to the next player's turn
      if (!isSix) {
        setState(() {
          _currentTurn = (_currentTurn % 4) + 1; // Rotate between 1 to 4
          _turnsTaken++; // Increment the number of turns taken
        });
      }

      // Check if all turns are completed
      if (_turnsTaken >= 4) {
        _showWinner();
      }
    }
  }

  // Show winner based on scores
  void _showWinner() {
    int highestScore = max(max(_score1, _score2), max(_score3, _score4));
    List<String> winners = [];

    if (_score1 == highestScore) winners.add('Player 1');
    if (_score2 == highestScore) winners.add('Player 2');
    if (_score3 == highestScore) winners.add('Player 3');
    if (_score4 == highestScore) winners.add('Player 4');

    String winnerText = winners.join(' and ');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over!'),
          content: Text('Winner(s): $winnerText with a score of $highestScore!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Reset the game state if needed
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  // Reset the game state
  void _resetGame() {
    setState(() {
      _diceNumber1 = 1;
      _diceNumber2 = 1;
      _diceNumber3 = 1;
      _diceNumber4 = 1;
      _score1 = 0;
      _score2 = 0;
      _score3 = 0;
      _score4 = 0;
      _currentTurn = 1;
      _turnsTaken = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ludo App'),
        backgroundColor: Colors.deepOrange,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.deepOrangeAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDiceColumn(
                  'Player 1: $_diceNumber1',
                  'Score: $_score1',
                  'images/dice-$_diceNumber1.png',
                  _animation1,
                  1,
                ),
                SizedBox(width: 50),
                _buildDiceColumn(
                  'Player 2: $_diceNumber2',
                  'Score: $_score2',
                  'images/dice-$_diceNumber2.png',
                  _animation2,
                  2,
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDiceColumn(
                  'Player 3: $_diceNumber3',
                  'Score: $_score3',
                  'images/dice-$_diceNumber3.png',
                  _animation3,
                  3,
                ),
                SizedBox(width: 50),
                _buildDiceColumn(
                  'Player 4: $_diceNumber4',
                  'Score: $_score4',
                  'images/dice-$_diceNumber4.png',
                  _animation4,
                  4,
                ),
              ],
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: _rollDice,
              child: Text('Roll Dice for Player $_currentTurn'),
            ),
          ],
        ),
      ),
    );
  }

  // Build each dice column with player roll result, image, and score
  Widget _buildDiceColumn(String playerText, String scoreText, String imagePath, Animation<double> animation, int playerNumber) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: animation.value,
              child: Image.asset(
                imagePath,
                width: 50,
                height: 50,
              ),
            );
          },
        ),
        Text(playerText),
        Text(scoreText),
      ],
    );
  }
}
