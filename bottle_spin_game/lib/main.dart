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
          style: TextStyle(color: Colors.orangeAccent),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Spin the Bottle Game',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayerInputScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
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
              'Sing a poem with the ending word of monkey',
              'Sing a song without any rhythm',
              'Tell your one embarrassing moment that no one knows about',
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
          style: TextStyle(color: Colors.blueAccent),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Generate player names (up to 10):',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addPlayer,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
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
  String? _selectedChallenge;

  void _spinBottle() {
    int numberOfPlayers = widget.players.length;
    double rotationPerPlayer = 1 / numberOfPlayers; // Rotation for each player segment

    // Make the bottle spin around the player segments
    double spinAngle = (Random().nextInt(10) + 5) * rotationPerPlayer; // Add more spin to the bottle

    // Calculate the total spin (including full rotations)
    double endRotation = (spinAngle + (numberOfPlayers * rotationPerPlayer)) % 1;

    // Spin the bottle
    _bottleSpinKey.currentState?.spinBottle(endRotation, () {
      setState(() {
        int selectedNumber = (endRotation * numberOfPlayers).floor() % numberOfPlayers; // Find the selected player based on the final rotation
        _selectedPlayer = widget.players[selectedNumber];
        // Select a random challenge.
        _selectedChallenge = widget.challenges[Random().nextInt(widget.challenges.length)];
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
          style: TextStyle(color: Colors.deepPurpleAccent),
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
                  size: const Size(400, 400), // Increased size for the circle.
                  painter: CirclePainter(players: widget.players),
                ),
                BottleSpin(key: _bottleSpinKey),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _spinBottle,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('Spin Bottle'),
            ),
            if (_selectedPlayer != null) ...[
              const SizedBox(height: 20),
              Text('Selected Player: $_selectedPlayer', style: const TextStyle(color: Colors.deepPurpleAccent)),
              Text('Challenge: $_selectedChallenge', style: const TextStyle(color: Colors.deepPurpleAccent)),
            ],
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
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
      duration: const Duration(milliseconds: 5000), // Increased duration for realistic spin
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
      child: Image.asset('images/bottle.png', width: 100, height: 100), // Replace with your bottle image path.
    );
  }

  void spinBottle(double endRotation, VoidCallback onSpinEnd) {
    _animationController.stop();

    double currentRotation = _animation.value;

    // Add randomness to number of spins to make it feel natural.
    double randomSpins = Random().nextInt(5) + 3; // 3 to 7 full spins
    double totalRotation = currentRotation + randomSpins + endRotation;

    // Apply an ease-out curve for smooth deceleration.
    _animation = Tween<double>(begin: currentRotation, end: totalRotation)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward(from: 0).then((_) {
      onSpinEnd();
    });
  }
}

// Custom Painter for Circle (with player names in individual circles)
class CirclePainter extends CustomPainter {
  final List<String> players;

  CirclePainter({required this.players});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 3.2; // Radius for the circle
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    Paint paint = Paint()..color = Colors.blueAccent.withOpacity(0.5);

    // Draw the outer circle
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // Calculate the angle for each player's segment
    final double anglePerPlayer = 2 * pi / players.length;

    for (int i = 0; i < players.length; i++) {
      final double angle = anglePerPlayer * i;
      final double textX = centerX + radius * cos(angle);
      final double textY = centerY + radius * sin(angle);

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: players[i],
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(textX - textPainter.width / 2, textY - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

