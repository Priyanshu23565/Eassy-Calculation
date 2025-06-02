import 'package:flutter/material.dart';
import 'dart:math';
import 'soundtable.dart';
import 'package:flutter/services.dart';
import 'package:hello_world/quiz_game.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';

void _showResult(BuildContext context, String result) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final textColor = Theme.of(context).textTheme.bodyLarge?.color;

      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 40, color: Colors.green),
            const SizedBox(height: 10),
            Text(
              'Result',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              result,
              style: TextStyle(fontSize: 18, color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: result));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // Share.share(result);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

void main() {
  runApp(const MyApp());
}

// Main MyApp Widget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EASY CALCULATION',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          elevation: 5,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        primaryColor: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          elevation: 5,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary: Colors.deepPurpleAccent,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MathHomePage(toggleTheme: toggleTheme),
    );
  }
}

class MathHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const MathHomePage({super.key, required this.toggleTheme});

  @override
  State<MathHomePage> createState() => _MathHomePageState();
}

class _MathHomePageState extends State<MathHomePage> with TickerProviderStateMixin {
  String selectedOption = 'Multiplication Table';

  final TextEditingController inputController = TextEditingController();
  final TextEditingController rangeController = TextEditingController();
  final TextEditingController percentValueController = TextEditingController();
  final TextEditingController totalValueController = TextEditingController();
  final TextEditingController num1Controller = TextEditingController();
  final TextEditingController num2Controller = TextEditingController();

  List<String> result = [];

  final List<String> options = [
    'Multiplication Table',
    'Additive Table',
    'Square',
    'Cube',
    'Root',
    'Percentage',
    'Arithmetic',
  ];

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _animationController.dispose();
    inputController.dispose();
    rangeController.dispose();
    percentValueController.dispose();
    totalValueController.dispose();
    num1Controller.dispose();
    num2Controller.dispose();
    super.dispose();
  }

  void generate() {
    List<String> output = [];
    double num;
    int range;

    switch (selectedOption) {
      case 'Multiplication Table':
        num = double.tryParse(inputController.text) ?? 0;
        range = int.tryParse(rangeController.text) ?? 10;
        for (int i = 1; i <= range; i++) {
          output.add('$num × $i = ${num * i}');
        }
        break;
      case 'Additive Table':
        num = double.tryParse(inputController.text) ?? 0;
        range = int.tryParse(rangeController.text) ?? 10;
        double sum = 0;
        for (int i = 1; i <= range; i++) {
          sum += num;
          output.add(sum.toStringAsFixed(0));
        }
        break;
      case 'Square':
        num = double.tryParse(inputController.text) ?? 0;
        output.add('Square of $num = ${num * num}');
        break;
      case 'Cube':
        num = double.tryParse(inputController.text) ?? 0;
        output.add('Cube of $num = ${num * num * num}');
        break;
      case 'Root':
        num = double.tryParse(inputController.text) ?? 0;
        if (num < 0) {
          output.add('Root of negative number is not real');
        } else {
          output.add('√$num = ${sqrt(num).toStringAsFixed(3)}');
        }
        break;
      case 'Percentage':
        double total = double.tryParse(totalValueController.text) ?? 0;
        double percent = double.tryParse(percentValueController.text) ?? 0;
        double res = (total * percent) / 100;
        output.add('$percent% of $total = ${res.toStringAsFixed(3)}');
        break;
      case 'Arithmetic':
        output.add('Enter numbers and press operation button');
        break;
    }

    _animationController.forward(from: 0);
    setState(() {
      result = output;
    });
  }

  void doAddition() {
    double a = double.tryParse(num1Controller.text) ?? 0;
    double b = double.tryParse(num2Controller.text) ?? 0;
    setState(() {
      result = ['Addition: $a + $b = ${a + b}'];
    });
  }

  void doSubtraction() {
    double a = double.tryParse(num1Controller.text) ?? 0;
    double b = double.tryParse(num2Controller.text) ?? 0;
    setState(() {
      result = ['Subtraction: $a - $b = ${a - b}'];
    });
  }

  void doMultiplication() {
    double a = double.tryParse(num1Controller.text) ?? 0;
    double b = double.tryParse(num2Controller.text) ?? 0;
    setState(() {
      result = ['Multiplication: $a × $b = ${a * b}'];
    });
  }

  void doDivision() {
    double a = double.tryParse(num1Controller.text) ?? 0;
    double b = double.tryParse(num2Controller.text) ?? 0;
    setState(() {
      if (b == 0) {
        result = ['Division by zero not allowed!'];
      } else {
        result = ['Division: $a ÷ $b = ${(a / b).toStringAsFixed(3)}'];
      }
    });
  }

  Widget buildInputFields() {
    switch (selectedOption) {
      case 'Multiplication Table':
      case 'Additive Table':
        return Column(
          children: [
            TextField(
              controller: inputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calculate),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: rangeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter range',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.format_list_numbered),
              ),
            ),
          ],
        );
      case 'Square':
      case 'Cube':
      case 'Root':
        return TextField(
          controller: inputController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Enter number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.numbers),
          ),
        );
      case 'Percentage':
        return Column(
          children: [
            TextField(
              controller: totalValueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter total value',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.stacked_line_chart),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: percentValueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter percentage (%)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.percent),
              ),
            ),
          ],
        );
      case 'Arithmetic':
        return Column(
          children: [
            TextField(
              controller: num1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'First number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.looks_one),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: num2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Second number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.looks_two),
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Widget buildArithmeticButtons() {
    if (selectedOption != 'Arithmetic') return Container();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Wrap(
        spacing: 15,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add'),
            onPressed: doAddition,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.remove),
            label: const Text('Subtract'),
            onPressed: doSubtraction,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.clear),
            label: const Text('Multiply'),
            onPressed: doMultiplication,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.horizontal_rule),
            label: const Text('Divide'),
            onPressed: doDivision,
          ),
        ],
      ),
    );
  }

  void openCalculatorPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => _buildCalculatorPanel(context),
    );
  }


  Widget _buildCalculatorPanel(BuildContext context) {
    final List<Map<String, dynamic>> tools = [
      {'label': 'Table', 'icon': Icons.table_chart},
      {'label': 'Square', 'icon': Icons.square_foot},
      {'label': 'Factorial', 'icon': Icons.exposure_plus_1},
      {'label': 'Fibonacci', 'icon': Icons.filter_9_plus},
      {'label': 'Armstrong', 'icon': Icons.fingerprint},
      {'label': 'Palindrome', 'icon': Icons.sync},
      {'label': 'Multiply', 'icon': Icons.clear},
      {'label': 'Divide', 'icon': Icons.horizontal_rule},
      {'label': 'Dark Mode', 'icon': Icons.dark_mode},
      {'label': 'Quiz', 'icon': Icons.quiz},
      {'label': 'Sound', 'icon': Icons.volume_up},
    ];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1,
          ),
          itemCount: tools.length,
          itemBuilder: (_, index) {
            final item = tools[index];
            return GestureDetector(
              onTap: () async {
                Navigator.pop(context);

                if (item['label'] == 'Dark Mode') {
                  widget.toggleTheme();
                  return;
                }

                if (item['label'] == 'Quiz') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizGame()),
                  );
                  return;
                }
                if (item['label'] == 'Sound') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SoundTableScreen()),
                  );
                  return;
                }


                final input = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    final controller = TextEditingController();
                    return AlertDialog(
                      title: Text('Enter number for ${item['label']}'),
                      content: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Enter a number'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, controller.text),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );

                if (input == null || input.isEmpty) return;

                final numValue = int.tryParse(input);
                if (numValue == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid input')),
                  );
                  return;
                }

                String output;
                switch (item['label']) {
                  case 'Square':
                    output = 'Square of $numValue is ${numValue * numValue}';
                    break;
                  case 'Factorial':
                    int fact = 1;
                    for (int i = 1; i <= numValue; i++) {
                      fact *= i;
                    }
                    output = 'Factorial of $numValue is $fact';
                    break;
                  case 'Fibonacci':
                    List<int> fib = [0, 1];
                    for (int i = 2; i < numValue; i++) {
                      fib.add(fib[i - 1] + fib[i - 2]);
                    }
                    output = 'First $numValue Fibonacci numbers: ${fib.take(numValue).join(', ')}';
                    break;
                  case 'Armstrong':
                    int sum = 0, temp = numValue;
                    int digits = numValue.toString().length;
                    while (temp > 0) {
                      sum += pow(temp % 10, digits).toInt();
                      temp ~/= 10;
                    }
                    output = numValue == sum
                        ? '$numValue is an Armstrong number'
                        : '$numValue is not an Armstrong number';
                    break;
                  case 'Palindrome':
                    String reversed = input.split('').reversed.join();
                    output = input == reversed
                        ? '$input is a Palindrome'
                        : '$input is not a Palindrome';
                    break;
                  case 'Multiply':
                    final secondInput = await _getSecondInput(context, 'Multiply');
                    if (secondInput == null) return;
                    final mulResult = numValue * secondInput;
                    output = '$numValue × $secondInput = $mulResult';
                    break;
                  case 'Divide':
                    final secondInput = await _getSecondInput(context, 'Divide');
                    if (secondInput == null || secondInput == 0) {
                      output = 'Cannot divide by zero!';
                    } else {
                      final divResult = numValue / secondInput;
                      output = '$numValue ÷ $secondInput = ${divResult.toStringAsFixed(3)}';
                    }
                    break;
                  case 'Table':
                    output = 'Use main UI to generate multiplication table';
                    break;
                  default:
                    output = 'Not implemented';
                }

                if (output.isNotEmpty) {
                  _showResult(context, output);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'], size: 40, color: Colors.white),
                    const SizedBox(height: 10),
                    Text(
                      item['label'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  Future<int?> _getSecondInput(BuildContext context, String operation) async {
    final TextEditingController controller = TextEditingController();
    final result = await showDialog<int>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Enter second number for $operation'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Second number'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final val = int.tryParse(controller.text);
                Navigator.pop(context, val);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EASY CALCULATION'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedOption,
                items: options
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val == null) return;
                  setState(() {
                    selectedOption = val;
                    // Clear inputs and result when changing option
                    inputController.clear();
                    rangeController.clear();
                    percentValueController.clear();
                    totalValueController.clear();
                    num1Controller.clear();
                    num2Controller.clear();
                    result = [];
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Operation',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.settings),
                ),
              ),
              const SizedBox(height: 20),
              buildInputFields(),
              buildArithmeticButtons(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: generate,
                child: const Text('Generate'),
              ),
              const SizedBox(height: 20),
              SizeTransition(
                sizeFactor: _animationController,
                axisAlignment: -1,
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: result.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, index) {
                    return Text(
                      result[index],
                      style: const TextStyle(fontSize: 18),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Open Calculator Panel',
        onPressed: openCalculatorPanel,
        child: const Icon(Icons.calculate),
      ),
    );
  }
}
