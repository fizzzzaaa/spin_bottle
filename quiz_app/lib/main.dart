import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  List<Question> questionList = [
    Question('Flutter is developed by Google?', true),
    Question('Flutter is used for web development?', false),
    Question('Dart is the programming language used by Flutter?', true),
    Question('Widgets in Flutter are mutable?', false),
    Question('Flutter is open source?', true),
    Question('Flutter uses Java as its main language?', false),
    Question('StatelessWidget can be rebuilt?', false),
    Question('setState() is used in StatelessWidget?', false),
    Question('Hot reload is a feature of Flutter?', true),
    Question('Flutter supports both Android and iOS?', true),
  ];

  void checkAnswer(bool userAnswer) {
    if (questionList[currentQuestionIndex].correctAnswer == userAnswer) {
      correctAnswers++;
    }

    setState(() {
      currentQuestionIndex++;
    });

    if (currentQuestionIndex >= questionList.length) {
      // Show result after last question
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(correctAnswers: correctAnswers),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Quiz'),
      ),
      body: currentQuestionIndex < questionList.length
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${currentQuestionIndex + 1}. ${questionList[currentQuestionIndex].questionText}',
              style: TextStyle(fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => checkAnswer(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen, // Lighter green background
                    foregroundColor: Colors.white, // White text
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Rectangular shape
                    ),
                    elevation: 0, // Remove shadow
                  ),
                  child: Text('True'),
                ),
                ElevatedButton(
                  onPressed: () => checkAnswer(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // Lighter red background
                    foregroundColor: Colors.white, // White text
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Rectangular shape
                    ),
                    elevation: 0, // Remove shadow
                  ),
                  child: Text('False'),
                ),
              ],
            ),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator()), // Loading indicator
    );
  }
}

class Question {
  final String questionText;
  final bool correctAnswer;

  Question(this.questionText, this.correctAnswer);
}

class ResultPage extends StatelessWidget {
  final int correctAnswers;

  ResultPage({required this.correctAnswers});

  @override
  Widget build(BuildContext context) {
    String resultText = correctAnswers > 6 ? 'Pass' : 'Fail';
    Color backgroundColor = Colors.lightBlue[100]!;

    return Scaffold(
      body: Container(
        color: backgroundColor, // Light blue background
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You got $correctAnswers correct answers!',
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 20.0),
              Text(
                'You $resultText',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: resultText == 'Pass' ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Restart the quiz by navigating back to QuizPage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue background
                  foregroundColor: Colors.white, // White text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Square shape
                  ),
                  elevation: 0, // Remove shadow
                ),
                child: Text('Restart Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
