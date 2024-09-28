import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

// Define the main application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spin the Bottle Game',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomeScreen(),
    );
  }
}

// Define the Home Screen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Spin the Bottle Game',
          style: TextStyle(color: Colors.orangeAccent), // Blue title text
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Spin the Bottle Game',
              style: TextStyle(color: Colors.black), // Blue text
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayerInputScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent), // Blue button
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200], // Light grey background
    );
  }
}

// Define the Player Input Screen
class PlayerInputScreen extends StatefulWidget {
  @override
  _PlayerInputScreenState createState() => _PlayerInputScreenState();
}

class _PlayerInputScreenState extends State<PlayerInputScreen> {
  final List<String> _players = [];
  final List<String> _generatedPlayerNames = [
    'Ayat',
    'Mirha',
    'Aahil',
    'Wasif',
    'Hourain',
    'Meerab',
    'Mavra',
    'Minhal',
    'Abdul Mannan',
    'Fiza'
  ];

  void _addPlayer() {
    if (_players.length < 10) {
      setState(() {
        _players.add(_generatedPlayerNames[_players.length]);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 10 players allowed')),
      );
    }
  }

  void _startGame() {
    if (_players.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(
            players: _players,
            challenges: [
              'sing a poem with ending word of monkey',
              'Sing a song without any rythm',
              'tell your one wmbarrasing moment that no one knows about',
              'Dance for 1 minute',
              'Imitate a celebrity',
              'Share a fun fact',
              'Do an impression',
              'Act like an animal',
              'Make a funny face',
              'Tell a funny story',
            ],
            customChallenge: '',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Player Names',
          style: TextStyle(color: Colors.blueAccent), // Blue title text
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Generate player names (up to 10):',
              style: TextStyle(color: Colors.black), // Blue text
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addPlayer,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white), // Blue button
              child: const Text('Add Player'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _players.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${index + 1}. ${_players[index]}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent), // Blue button
              child: const Text('Start Game'),

            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200], // Light grey background
    );
  }
}

// Define the Game Screen
class GameScreen extends StatefulWidget {
  final List<String> players;
  final List<String> challenges;
  final String customChallenge;

  GameScreen({
    required this.players,
    required this.challenges,
    required this.customChallenge,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GlobalKey<_BottleSpinState> _bottleSpinKey = GlobalKey<_BottleSpinState>();
  String? _selectedPlayer;
  int _selectedNumber = 0;
  String? _selectedChallenge;

  void _spinBottle() {
    setState(() {
      _selectedNumber = Random().nextInt(widget.players.length); // Select a random player index
      _selectedPlayer = widget.players[_selectedNumber]; // Get the player based on the random number
      _selectedChallenge = widget.challenges[Random().nextInt(widget.challenges.length)]; // Random challenge
      if (widget.customChallenge.isNotEmpty) {
        _selectedChallenge = widget.customChallenge; // Use custom challenge if provided
      }
    });

    double anglePerNumber = 1 / widget.players.length; // Each number corresponds to 1/nth of a full circle
    double randomRotation = (Random().nextDouble() * 2) + 5; // Add extra rotations (between 5 and 7 full spins)
    double endRotation = randomRotation + (_selectedNumber * anglePerNumber);

    _bottleSpinKey.currentState?.spinBottle(endRotation);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        // Update the selected player's score (if needed)
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Game Screen',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.deepPurpleAccent), // Blue title text
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(400, 400), // Increased size for the circle
                  painter: CirclePainter(rewards: List.generate(10, (index) => index + 1), players: widget.players, selectedNumber: _selectedNumber),
                ),
                BottleSpin(key: _bottleSpinKey),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _spinBottle,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white), // Blue button
              child: const Text('Spin Bottle'),
            ),
            if (_selectedPlayer != null) ...[ // Display selected player name instead of reward
              const SizedBox(height: 20),
              Text('Selected Player: $_selectedPlayer', style: const TextStyle(color: Colors.deepPurpleAccent)), // Blue text
              Text('Challenge: $_selectedChallenge', style: const TextStyle(color: Colors.deepPurpleAccent)), // Blue text
            ],
          ],
        ),
      ),
      backgroundColor: Colors.grey[200], // Light grey background
    );
  }
}

// Define the BottleSpin widget
class BottleSpin extends StatefulWidget {
  const BottleSpin({Key? key}) : super(key: key);

  @override
  _BottleSpinState createState() => _BottleSpinState();
}

class _BottleSpinState extends State<BottleSpin> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // Bottle spin duration
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: Image.asset('images/pic.png', width: 100, height: 100), // Replace with your bottle image path
    );
  }

  void spinBottle(double endRotation) {
    _animationController.forward(from: 0);
    // Here you can implement the rotation animation based on endRotation if needed
  }
}

// Custom Painter for Circle
class CirclePainter extends CustomPainter {
  final List<int> rewards;
  final List<String> players;
  final int selectedNumber;

  CirclePainter({required this.rewards, required this.players, required this.selectedNumber});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    for (int i = 0; i < players.length; i++) {
      final double startAngle = (i * 2 * pi) / players.length;
      final double sweepAngle = (2 * pi) / players.length;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint..color = i == selectedNumber ? Colors.purpleAccent : Colors.lightBlueAccent, // Highlight selected slice
      );

      // Draw player numbers inside the circle
      final textPainter = TextPainter(
        text: TextSpan(
          text: players[i],
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final double x = centerX + (radius / 2) * cos(startAngle + sweepAngle / 2);
      final double y = centerY + (radius / 2) * sin(startAngle + sweepAngle / 2);
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Redraw on every frame
  }
}