import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'xylophone_key.dart'; // Import the XylophoneKey widget

void main() {
  runApp(XylophoneApp());
}

class XylophoneApp extends StatefulWidget {
  @override
  _XylophoneAppState createState() => _XylophoneAppState();
}

class _XylophoneAppState extends State<XylophoneApp> {
  // Define colors for two themes
  List<Color> themeOneColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.indigo,
    Colors.orange,
    Colors.pink,
    Colors.purple,
  ];

  List<Color> themeTwoColors = [
    Colors.cyan,
    Colors.lime,
    Colors.amber,
    Colors.yellow,
    Colors.teal,
    Colors.brown,
    Colors.grey,
  ];

  // Define sounds for two themes
  List<String> themeOneSounds = [
    'n1.wav',
    'note2.wav',
    'note3.wav',
    'note4.wav',
    'note5.wav',
    'note6.wav',
    'note7.wav',
  ];

  List<String> themeTwoSounds = [
    'n1.wav',
    'n2.wav',
    'n3.wav',
    'n4.wav',
    'n5.wav',
    'n6.wav',
    'n7.wav',
  ];

  bool isThemeOne = true;
  List<Color> currentColors = [];
  List<String> currentSounds = [];
  AudioPlayer player = AudioPlayer(); // Use AudioPlayer

  @override
  void initState() {
    super.initState();
    // Set default theme
    currentColors = List.from(themeOneColors); // Use List.from to create a new list
    currentSounds = List.from(themeOneSounds); // Use List.from for sounds
  }

  // Function to switch themes
  void switchTheme() {
    setState(() {
      isThemeOne = !isThemeOne;
      currentColors = isThemeOne ? List.from(themeOneColors) : List.from(themeTwoColors);
      currentSounds = isThemeOne ? List.from(themeOneSounds) : List.from(themeTwoSounds);
    });
  }

  // Function to create a key
  Widget buildKey(int index) {
    return XylophoneKey(
      color: currentColors[index],
      sound: currentSounds[index],
      onPressed: () {
        player.play(AssetSource(currentSounds[index])); // Use AssetSource for new audioplayers version
      },
      onChangeTheme: (Color newColor) {
        setState(() {
          currentColors[index] = newColor; // Set the new color
        });
      },
      onChangeSound: (String newSound) {
        setState(() {
          currentSounds[index] = newSound; // Set the new sound
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Xylophone'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Increased width for keys container
              Container(
                width: 600, // Increased container width
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100], // Set a different background color
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8.0), // Padding inside the box
                child: Row(
                  mainAxisSize: MainAxisSize.max, // Use max size for row
                  children: List.generate(7, (index) {
                    return Expanded( // Use Expanded to distribute space evenly
                      child: buildKey(index), // Adjust the key width dynamically
                    );
                  }),
                ),
              ),
              SizedBox(height: 20), // Space between keys and button
              // Theme button with adjusted size
              Container(
                // Center the button and give it a specific width
                child: MouseRegion(
                  onEnter: (_) => setState(() {
                    // Change the color when hovered
                    hoverColor = Colors.purpleAccent;
                  }),
                  onExit: (_) => setState(() {
                    // Revert to original color when not hovered
                    hoverColor = Colors.deepPurpleAccent;
                  }),
                  child: GestureDetector(
                    onTap: switchTheme,
                    child: Container(
                      width: 200, // Fixed width for the button
                      padding: EdgeInsets.symmetric(vertical: 10), // Adjusted vertical padding
                      decoration: BoxDecoration(
                        color: hoverColor, // Set the color based on hover state
                        borderRadius: BorderRadius.circular(30), // Rounded shape
                      ),
                      child: Center( // Center the button text
                        child: Text(
                          'Change Global Theme',
                          style: TextStyle(color: Colors.white), // Keep text color white
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color hoverColor = Colors.deepPurpleAccent; // Default button color
} 