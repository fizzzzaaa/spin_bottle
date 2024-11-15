import 'dart:async'; // For the timer
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
  int skipsRemaining = 3; // 3 skips allowed
  List<int> skippedQuestions = [];
  Timer? timer;
  int secondsRemaining = 7;

  // Regular quiz questions
  List<Question> questionList = [
    Question('Flutter is developed by Google?', ['Google', 'Microsoft', 'Apple', 'Facebook'], 0),
    Question('Flutter is used for web development?', ['True', 'False', 'Sometimes', 'Never'], 1),
    Question('Dart is the programming language used by Flutter?', ['Java', 'Python', 'Dart', 'Swift'], 2),
    Question('Widgets in Flutter are mutable?', ['Yes', 'No', 'Partially', 'Not Sure'], 1),
    Question('Flutter is open source?', ['Yes', 'No', 'Paid', 'Subscription-based'], 0),
    Question('Flutter uses Java as its main language?', ['Yes', 'No', 'Maybe', 'Depends'], 1),
    Question('StatelessWidget can be rebuilt?', ['Yes', 'No', 'Sometimes', 'Rarely'], 1),
    Question('setState() is used in StatelessWidget?', ['Yes', 'No', 'Occasionally', 'Always'], 1),
    Question('Hot reload is a feature of Flutter?', ['Yes', 'No', 'Only for Web', 'Not Anymore'], 0),
    Question('Flutter supports both Android and iOS?', ['Yes', 'No', 'Android Only', 'iOS Only'], 0),
  ];

  // Additional questions shown on skipping
  List<Question> skippedQuestionList = [
    Question('Who created Dart?', ['Google', 'Microsoft', 'Facebook', 'Amazon'], 0),
    Question('What is the main architecture pattern used in Flutter?', ['MVC', 'MVVM', 'BLoC', 'MVP'], 2),
    Question('Which command is used to create a new Flutter project?', ['flutter init', 'flutter create', 'flutter new', 'flutter project'], 1),
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    secondsRemaining = 7;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          // Time's up, go to the next question
          moveToNextQuestion(false);
        }
      });
    });
  }

  void checkAnswer(int selectedOptionIndex) {
    if (currentQuestionIndex < questionList.length &&
        questionList[currentQuestionIndex].correctAnswerIndex == selectedOptionIndex) {
      correctAnswers++;
    }

    moveToNextQuestion(true);
  }

  void moveToNextQuestion(bool answered) {
    setState(() {
      if (!answered) {
        // If not answered, move to the next question with zero score
      }

      currentQuestionIndex++;
      if (currentQuestionIndex >= questionList.length) {
        timer?.cancel();
        // Navigate to results page after the last question
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(correctAnswers: correctAnswers),
          ),
        );
      } else {
        startTimer(); // Restart timer for the next question
      }
    });
  }

  void skipQuestion() {
    if (skipsRemaining > 0 && skippedQuestions.length < skippedQuestionList.length) {
      setState(() {
        skipsRemaining--;

        // Replace current question with a new one from skippedQuestionList
        int nextSkippedIndex = skippedQuestions.length;
        questionList.insert(currentQuestionIndex, skippedQuestionList[nextSkippedIndex]);
        skippedQuestions.add(currentQuestionIndex);

        // Move to the new skipped question
        moveToNextQuestion(true); // Move to the skipped question
      });
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Timer at the top with increased space
            Padding(
              padding: const EdgeInsets.only(top: 30.0), // Increased space from top
              child: Text(
                'Time remaining: $secondsRemaining seconds',
                style: TextStyle(fontSize: 18.0, color: Colors.red),
              ),
            ),
            SizedBox(height: 20.0), // Space between timer and question
            // Centered question with less distance from options
            Text(
              '${currentQuestionIndex + 1}. ${questionList[currentQuestionIndex].questionText}',
              style: TextStyle(fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Two rows of options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      optionButton(0),
                      optionButton(1),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      optionButton(2),
                      optionButton(3),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // Skip button at the bottom
            if (skipsRemaining > 0 && skippedQuestions.length < skippedQuestionList.length) // Show only if skips are available
              ElevatedButton(
                onPressed: skipQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Orange for skip button
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text('Skip ($skipsRemaining left)'),
              ),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator()), // Loading indicator
    );
  }

  Widget optionButton(int index) {
    return SizedBox(
      width: 150.0, // Set a fixed width for options
      child: ElevatedButton(
        onPressed: () => checkAnswer(index),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlueAccent, // Light blue background
          foregroundColor: Colors.white, // White text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Rectangular shape
          ),
          elevation: 0, // Remove shadow
        ),
        child: Text(questionList[currentQuestionIndex].options[index]),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question(this.questionText, this.options, this.correctAnswerIndex);
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
