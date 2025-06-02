import 'package:flutter/material.dart';

class QuizGame extends StatefulWidget {
  const QuizGame({super.key});

  @override
  State<QuizGame> createState() => _QuizGameState();
}

class _QuizGameState extends State<QuizGame> {
  int unlockedLevel = 1;
  int selectedLevel = 1;
  int currentQuestionIndex = 0;
  int score = 0;

  final Map<int, List<Map<String, dynamic>>> levelQuestions = {
    1: [
      {'question': '2 + 2 = ?', 'answer': 4},
      {'question': '3 + 1 = ?', 'answer': 4},
    ],
    2: [
      {'question': '10 - 6 = ?', 'answer': 4},
      {'question': '8 + 2 = ?', 'answer': 10},
    ],
    3: [
      {'question': '6 × 7 = ?', 'answer': 42},
      {'question': '12 × 3 = ?', 'answer': 36},
    ],
    4: [
      {'question': '√81 = ?', 'answer': 9},
      {'question': '100 ÷ 4 = ?', 'answer': 25},
    ],
  };

  final TextEditingController answerController = TextEditingController();

  void selectLevel(int level) {
    setState(() {
      selectedLevel = level;
      currentQuestionIndex = 0;
      score = 0;
      answerController.clear();
    });
  }

  void checkAnswer() {
    final questions = levelQuestions[selectedLevel]!;
    final userAnswer = int.tryParse(answerController.text);

    if (userAnswer == questions[currentQuestionIndex]['answer']) {
      setState(() {
        score++;
        currentQuestionIndex++;
        answerController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wrong Answer! Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = levelQuestions[selectedLevel]!;

    // All questions answered for this level
    if (currentQuestionIndex >= questions.length) {
      // Unlock next level if available
      if (selectedLevel < 4 && unlockedLevel <= selectedLevel) {
        unlockedLevel = selectedLevel + 1;
      }

      return Scaffold(
        appBar: AppBar(title: const Text('Level Completed')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '🎉 Congratulations!\nYou completed Level $selectedLevel!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentQuestionIndex = 0;
                    score = 0;
                    answerController.clear();
                  });
                },
                child: const Text('Replay Level'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedLevel = 0;
                  });
                },
                child: const Text('Back to Levels'),
              ),
            ],
          ),
        ),
      );
    }

    // If no level selected yet
    if (selectedLevel == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('Select Level')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: List.generate(4, (index) {
              final level = index + 1;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: level <= unlockedLevel
                      ? () => selectLevel(level)
                      : null,
                  child: Text('Level $level'),
                ),
              );
            }),
          ),
        ),
      );
    }

    // Show quiz for selected level
    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
          title: Text('Level $selectedLevel - Question ${currentQuestionIndex + 1}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(currentQuestion['question'], style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 20),
            TextField(
              controller: answerController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Your Answer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkAnswer,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
