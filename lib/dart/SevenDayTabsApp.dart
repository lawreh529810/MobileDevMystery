import 'package:flutter/material.dart';

void main() {
  runApp(SevenDayApp());
}

class SevenDayApp extends StatelessWidget {
  const SevenDayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SevenDayHome(),
    );
  }
}

class SevenDayHome extends StatelessWidget {
  const SevenDayHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: Text("7-Day Planner"),
          bottom: TabBar(
            isScrollable: true,
            tabs: List.generate(7, (index) => Tab(text: "Day ${index + 1}")),
          ),
        ),
        body: TabBarView(
          children: List.generate(
              7, (index) => Center(child: Text("Tasks for Day ${index + 1}"))),
        ),
      ),
    );
  }
}
