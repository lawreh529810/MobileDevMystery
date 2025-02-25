import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatelessWidget {
  final List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  final Random random = Random();

  WeatherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7, // 7 days of the week
      child: Scaffold(
        appBar: AppBar(
          title: Text("7-Day Weather Forecast"),
          bottom: TabBar(
            isScrollable: true,
            tabs: days.map((day) => Tab(text: day)).toList(),
          ),
        ),
        body: TabBarView(
          children: days.map((day) {
            int temp = 15 +
                random.nextInt(15); // Random temperature between 15°C and 30°C
            String condition = ["Sunny", "Cloudy", "Rainy"][random.nextInt(3)];
            return WeatherInfo(
                day: day, temperature: temp, condition: condition);
          }).toList(),
        ),
      ),
    );
  }
}

class WeatherInfo extends StatelessWidget {
  final String day;
  final int temperature;
  final String condition;

  const WeatherInfo(
      {super.key,
      required this.day,
      required this.temperature,
      required this.condition});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "$temperature°C - $condition",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
