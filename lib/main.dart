import 'dart:async';
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
  bool nameSet = false;

  int happiness = 50;
  int hunger = 50;
  int energy = 60;

  final TextEditingController _nameCtrl = TextEditingController();
  Timer? hungerTimer;

  @override
  void initState() {
    super.initState();
    hungerTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!nameSet) return;
      setState(() {
        hunger = (hunger + 5).clamp(0, 100);
      });
    });
  }

  @override
  void dispose() {
    hungerTimer?.cancel();
    _nameCtrl.dispose();
    super.dispose();
  }

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
    if (!nameSet) {
      return Scaffold(
        appBar: AppBar(title: const Text("Digital Pet")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Name your pet:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameCtrl,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: "e.g., Biscuit",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    final n = _nameCtrl.text.trim();
                    setState(() {
                      petName = n.isEmpty ? "My Pet" : n;
                      nameSet = true;
                    });
                  },
                  child: const Text("Confirm"),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
