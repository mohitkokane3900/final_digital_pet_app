import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: DigitalPetApp()));
}

class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({super.key});
  @override
  State<DigitalPetApp> createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "My Pet";
  int happiness = 50;
  int hunger = 50;
  int energy = 60;

  void _play() {
    setState(() {
      happiness = (happiness + 10).clamp(0, 100);
      hunger = (hunger + 5).clamp(0, 100);
      energy = (energy - 10).clamp(0, 100);
    });
  }

  void _feed() {
    setState(() {
      hunger = (hunger - 10).clamp(0, 100);
      energy = (energy + 5).clamp(0, 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Digital Pet")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, size: 100),
            const SizedBox(height: 16),
            Text("Name: $petName", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text("Happiness: $happiness"),
            Text("Hunger: $hunger"),
            Text("Energy: $energy"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _play, child: const Text("Play")),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: _feed, child: const Text("Feed")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
