import 'package:flutter/material.dart';

void main() {
  runApp(DigitalPetApp());
}

class DigitalPetApp extends StatelessWidget {
  const DigitalPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PetHomePage(),
    );
  }
}

class PetHomePage extends StatefulWidget {
  const PetHomePage({super.key});

  @override
  _PetHomePageState createState() => _PetHomePageState();
}

class _PetHomePageState extends State<PetHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of pets/tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text("Digital Pet App"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Dog"),
              Tab(text: "Cat"),
              Tab(text: "Bird"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PetInfo(
                petName: "Dog", description: "Loyal and friendly companion."),
            PetInfo(petName: "Cat", description: "Independent and loving pet."),
            PetInfo(
                petName: "Bird", description: "Chirpy and fun to have around."),
          ],
        ),
      ),
    );
  }
}

class PetInfo extends StatelessWidget {
  final String petName;
  final String description;

  const PetInfo({super.key, required this.petName, required this.description});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              petName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
