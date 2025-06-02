import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SoundTableScreen extends StatefulWidget {
  @override
  _SoundTableScreenState createState() => _SoundTableScreenState();
}

class _SoundTableScreenState extends State<SoundTableScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _rangeController = TextEditingController();

  final FlutterTts flutterTts = FlutterTts();

  int? number;
  int range = 10; // default 10
  List<String> table = [];

  double _speechRate = 0.9; // Default speech rate

  bool isDarkMode = false;  // Dark mode flag

  void generateTable() {
    final numInput = int.tryParse(_numberController.text);
    final rangeInput = int.tryParse(_rangeController.text);

    if (numInput == null) {
      setState(() {
        table = ['Please enter a valid number'];
      });
      return;
    }
    if (rangeInput == null || rangeInput <= 0) {
      setState(() {
        table = ['Please enter a valid range (greater than 0)'];
      });
      return;
    }

    final List<String> numberWords = [
      "ones", "twos", "threes", "fours", "fives",
      "sixes", "sevens", "eights", "nines", "tens",
      // add more if range > 10
    ];

    setState(() {
      number = numInput;
      range = rangeInput;
      table = List.generate(range, (index) {
        int multiplier = index + 1;
        int result = number! * multiplier;
        String word = index < numberWords.length ? numberWords[index] : "x${multiplier}";
        return "$number $word are $result";
      });
    });
  }

  Future<void> speakTable() async {
    await flutterTts.setLanguage("hi-IN");
    var voices = await flutterTts.getVoices;
    print('Available voices: $voices');

    await flutterTts.setVoice({"name": "hi-in-x-hie-local", "locale": "hi-IN"});
    await flutterTts.setSpeechRate(_speechRate);
    await flutterTts.setPitch(1.0);

    for (String line in table) {
      bool isSpeaking = true;

      flutterTts.setCompletionHandler(() {
        isSpeaking = false;
      });

      await flutterTts.speak(line);

      while (isSpeaking) {
        await Future.delayed(Duration(milliseconds: 100));
      }
    }
  }

  void stopSpeaking() {
    flutterTts.stop();
  }

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    _numberController.dispose();
    _rangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sound Table'),
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
              onPressed: toggleDarkMode,
              tooltip: isDarkMode ? "Light Mode" : "Dark Mode",
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Apna Number Dalo:', style: TextStyle(fontSize: 22)),
              SizedBox(height: 10),
              TextField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Yahan number likho',
                ),
              ),

              SizedBox(height: 15),

              Text('Table ki Range Dalo (Jaise 50, 100):', style: TextStyle(fontSize: 22)),
              SizedBox(height: 10),
              TextField(
                controller: _rangeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Yahan range likho',
                ),
              ),

              SizedBox(height: 15),

              Row(
                children: [
                  ElevatedButton(
                    onPressed: generateTable,
                    child: Text('Show Table'),
                  ),
                  SizedBox(width: 10),
                  if (table.isNotEmpty) ...[
                    ElevatedButton.icon(
                      onPressed: speakTable,
                      icon: Icon(Icons.volume_up),
                      label: Text('Sound'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: stopSpeaking,
                      icon: Icon(Icons.stop),
                      label: Text('Stop'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ],
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Text("Speed:", style: TextStyle(fontSize: 18)),
                  Expanded(
                    child: Slider(
                      value: _speechRate,
                      onChanged: (newRate) {
                        setState(() {
                          _speechRate = newRate;
                        });
                      },
                      min: 0.3,
                      max: 1.2,
                      divisions: 9,
                      label: _speechRate.toStringAsFixed(1),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15),

              if (table.isNotEmpty) ...[
                Text(
                  'Multiplication Table for $number:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: table.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(table[index], style: TextStyle(fontSize: 18)),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
