import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String display = "";

  // Method to handle button presses
  void buttonPressed(String value) {
    setState(() {
      // Prevent multiple decimal points in a number
      if (value == "." && !display.contains(".")) {
        display += value;
      } else if (value != ".") {
        display += value;
      }
    });
  }

  // Method to calculate the result
  void calculate() {
    try {
      if (display.contains("/0")) {
        throw Exception("Cannot divide by zero");
      }
      final expression = Expression.parse(display);
      final evaluator = ExpressionEvaluator();
      final result = evaluator.eval(expression, {});
      setState(() {
        display = result.toString();
      });
    } catch (e) {
      // If there's an error (like division by zero), show 'Error' in the display
      setState(() {
        display = 'Error';
      });

      // Reset display after a brief moment
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          display = "";
        });
      });
    }
  }

  // Method to clear the display
  void clear() {
    setState(() {
      display = "";
    });
  }

  // Method to handle backspace
  void backspace() {
    setState(() {
      if (display.isNotEmpty) {
        display = display.substring(0, display.length - 1);
      }
    });
  }

  // UI layout
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Calculator App"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Display area
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                display,
                style: TextStyle(fontSize: 40),
              ),
            ),
            // Buttons
            Column(
              children: [
                // First row of numbers and operations
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    calculatorButton("7"),
                    calculatorButton("8"),
                    calculatorButton("9"),
                    calculatorButton("/"),
                  ],
                ),
                // Second row of numbers and operations
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    calculatorButton("4"),
                    calculatorButton("5"),
                    calculatorButton("6"),
                    calculatorButton("*"),
                  ],
                ),
                // Third row of numbers and operations
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    calculatorButton("1"),
                    calculatorButton("2"),
                    calculatorButton("3"),
                    calculatorButton("-"),
                  ],
                ),
                // Fourth row of numbers and operations
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    calculatorButton("0"),
                    calculatorButton("."),
                    calculatorButton("="),
                    calculatorButton("+"),
                  ],
                ),
                // Row with Clear and Backspace buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    calculatorButton("C", isSpecial: true), // Clear button
                    calculatorButton("←", isSpecial: true), // Backspace button
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Reusable calculator button
  Widget calculatorButton(String value, {bool isSpecial = false}) {
    return ElevatedButton(
      onPressed: () {
        if (value == "=") {
          calculate(); // Call the calculate method when "=" is pressed
        } else if (value == "C") {
          clear(); // Call the clear method when "C" is pressed
        } else if (value == "←") {
          backspace(); // Call the backspace method when "←" is pressed
        } else {
          buttonPressed(
              value); // Handle other button presses (numbers, operators, etc.)
        }
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(70, 70),
        backgroundColor: isSpecial ? Colors.blueAccent : null,
        shape: CircleBorder(),
        padding: EdgeInsets.all(20), // Special color for Clear and Backspace
      ),
      child: Text(
        value,
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
