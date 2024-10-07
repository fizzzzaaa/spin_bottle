import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SpinBottleGame());
}

class SpinBottleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddPlayersScreen(),
    );
  }
}

class AddPlayersScreen extends StatefulWidget {
  @override
  _AddPlayersScreenState createState() => _AddPlayersScreenState();
}

class _AddPlayersScreenState extends State<AddPlayersScreen> {
  // Initialize player names directly
  List<String> playerNames = [
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

  List<String> addedPlayers = [];
  int currentPlayerIndex = 0; // To keep track of the current player index

  void addPlayer() {
    if (addedPlayers.length < playerNames.length) {
      setState(() {
        addedPlayers.add(playerNames[addedPlayers.length]);
      });
    }
  }

  void startGame() {
    if (addedPlayers.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SpinBottleHome(playerNames: addedPlayers),
        ),
      );
    } else {
      // Optionally, show a message if no players are added
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one player')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Players"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Players to add:"),
            SizedBox(height: 10),
            // Display added players behind the button
            Expanded(
              child: ListView.builder(
                itemCount: addedPlayers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${index + 1}. ${addedPlayers[index]}"),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: addPlayer,
              child: Text("Add Player"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startGame,
              child: Text("Start the Game"),
            ),
          ],
        ),
      ),
    );
  }
}

class SpinBottleHome extends StatefulWidget {
  final List<String> playerNames;

  SpinBottleHome({required this.playerNames});

  @override
  _SpinBottleHomeState createState() => _SpinBottleHomeState();
}

class _SpinBottleHomeState extends State<SpinBottleHome>
    with SingleTickerProviderStateMixin {
  final List<Color> playerColors = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.tealAccent,
    Colors.indigoAccent,
    Colors.pinkAccent,
    Colors.brown,
  ];

  bool spinning = false;
  String selectedPlayer = "";
  String challenge = "";

  AnimationController? _controller;
  double _currentRotation = 0;
  double _targetRotation = 0;

  // Challenges for players
  final List<String> challenges = [
    "Do 10 push-ups!",
    "Sing a song!",
    "Tell a joke!",
    "Dance for 30 seconds!",
    "Do an impression!",
    "Share a secret!",
    "Give a compliment to everyone!",
    "Do a silly walk!",
    "Act like an animal!",
    "Imitate a famous person!",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..addListener(() {
      setState(() {
        _currentRotation = _controller!.value * _targetRotation;
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void spinBottle() {
    setState(() {
      spinning = true;
      Random random = Random();
      double randomAngle = random.nextDouble() * 2 * pi;
      _targetRotation = _currentRotation + 4 * pi + randomAngle;

      _controller?.reset();
      _controller?.forward().then((value) {
        setState(() {
          spinning = false;
          double stopAngle = _targetRotation % (2 * pi);
          int selectedPlayerIndex = ((stopAngle - pi / 20) / (2 * pi) * widget.playerNames.length).floor() % widget.playerNames.length;
          selectedPlayer = widget.playerNames[selectedPlayerIndex];
          challenge = challenges[selectedPlayerIndex]; // Get challenge based on player index
        });
      });
    });
  }

  Widget buildWheel() {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(widget.playerNames.length, (index) {
        final angle = (index / widget.playerNames.length) * 2 * pi;
        return Transform.translate(
          offset: Offset(
            120 * cos(angle),
            120 * sin(angle),
          ),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: playerColors[index],
            child: Text(
              "${index + 1}. ${widget.playerNames[index]}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Spin the Bottle Game",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  // Right side: Wheel and bottle
                  Expanded(
                    flex: 2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        buildWheel(),
                        Transform.rotate(
                          angle: _currentRotation - 0.1, // Slight anticlockwise adjustment
                          child: Image.asset(
                            'images/bottle.png', // Ensure the image path is correct
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Left side: Player Names
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: widget.playerNames.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              "${index + 1}. ${widget.playerNames[index]}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Bottom: Result Display
            Text(
              selectedPlayer.isNotEmpty
                  ? "$selectedPlayer is selected! Challenge: $challenge"
                  : "No player selected yet",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.blueGrey,
                elevation: 10,
                shadowColor: Colors.blueAccent,
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: spinning ? null : spinBottle,
              child: spinning
                  ? CircularProgressIndicator(
                color: Colors.white,
              )
                  : Text(
                "Spin",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
