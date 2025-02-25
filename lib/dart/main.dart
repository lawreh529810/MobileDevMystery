import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  void setValue(int newValue) {
    value = newValue;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Color getBackgroundColor(int age) {
    if (age <= 12) return Colors.lightBlue;
    if (age <= 19) return Colors.lightGreen;
    if (age <= 30) return Colors.yellow;
    if (age <= 50) return Colors.orange;
    return Colors.grey;
  }

  String getAgeMessage(int age) {
    if (age <= 12) return "You're a child!";
    if (age <= 19) return "Teenager time!";
    if (age <= 30) return "You're a young adult!";
    if (age <= 50) return "You're an adult now!";
    return "Golden years!";
  }

  Color getProgressBarColor(int age) {
    if (age <= 33) return Colors.green;
    if (age <= 67) return Colors.yellow;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Age Counter')),
      body: Consumer<Counter>(
        builder: (context, counter, child) {
          return Container(
            color: getBackgroundColor(counter.value),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Your current age is:'),
                  Text(
                    '${counter.value}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    getAgeMessage(counter.value),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: counter.value.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: counter.value.toString(),
                    onChanged: (double newValue) {
                      context.read<Counter>().setValue(newValue.toInt());
                    },
                  ),
                  Container(
                    width: 300,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300,
                    ),
                    child: FractionallySizedBox(
                      widthFactor: counter.value / 99,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: getProgressBarColor(counter.value),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
