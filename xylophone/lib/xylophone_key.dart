import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Import color picker package
import 'package:file_picker/file_picker.dart'; // Import file picker package

class XylophoneKey extends StatelessWidget {
  final Color color; // Color of the key
  final String sound; // Sound file associated with the key
  final VoidCallback onPressed; // Callback function when the key is pressed
  final ValueChanged<Color> onChangeTheme; // Callback to change the key color
  final ValueChanged<String> onChangeSound; // Callback to change the key sound

  XylophoneKey({
    required this.color,
    required this.sound,
    required this.onPressed,
    required this.onChangeTheme,
    required this.onChangeSound,
  });

  // List of available sounds
  final List<String> availableSounds = [
    'n1.wav',
    'note2.wav',
    'note3.wav',
    'note4.wav',
    'note5.wav',
    'note6.wav',
    'note7.wav',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed, // Play the sound
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15), // Round corners
            ),
            margin: EdgeInsets.symmetric(horizontal: 5.0), // Space between keys
            height: 200, // Height of each key
          ),
        ),
        SizedBox(height: 10), // Space between key and color icon
        IconButton(
          icon: Icon(Icons.edit, color: Colors.black), // Pencil icon for color change
          onPressed: () {
            _showColorPicker(context); // Show color picker
          },
        ),
        IconButton(
          icon: Icon(Icons.music_note, color: Colors.black), // Music note icon for sound change
          onPressed: () {
            _showSoundPicker(context); // Show sound picker
          },
        ),
      ],
    );
  }

  // Function to show the color picker dialog
  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        Color selectedColor = color; // Initialize selected color

        return AlertDialog(
          title: Text('Pick a Color'),
          content: SingleChildScrollView(
            child: BlockPicker( // Use BlockPicker for color selection
              pickerColor: selectedColor,
              onColorChanged: (color) {
                selectedColor = color; // Update selected color
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Select'),
              onPressed: () {
                onChangeTheme(selectedColor); // Apply the new color
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Function to show the list of available sounds
  void _showSoundPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select a Sound'),
          content: SingleChildScrollView(
            child: ListBody(
              children: availableSounds.map((sound) {
                return ListTile(
                  title: Text(sound), // Display sound names
                  onTap: () {
                    onChangeSound(sound); // Update the sound
                    Navigator.of(context).pop(); // Close the dialog
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
