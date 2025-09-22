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

  String moodText = "Neutral 😐";

  final TextEditingController _nameCtrl = TextEditingController();
  Timer? hungerTimer;
  DateTime? happyStart;

  @override
  void initState() {
    super.initState();
    hungerTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!nameSet) return;
      setState(() {
        hunger = (hunger + 5).clamp(0, 100);
        _recomputeMoodAndCheckWinLoss();
      });
    });
    _recomputeMoodAndCheckWinLoss();
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
      _recomputeMoodAndCheckWinLoss();
    });
  }

  void _feed() {
    setState(() {
      hunger = (hunger - 10).clamp(0, 100);
      energy = (energy + 5).clamp(0, 100);
      _recomputeMoodAndCheckWinLoss();
    });
  }

  void _recomputeMoodAndCheckWinLoss() {
    if (happiness > 70) {
      moodText = "Happy 😊";
    } else if (happiness >= 30) {
      moodText = "Neutral 😐";
    } else {
      moodText = "Unhappy 😢";
    }

    if (happiness > 80) {
      happyStart ??= DateTime.now();
      final held3Min = DateTime.now().difference(happyStart!).inMinutes >= 3;
      if (held3Min) {
        _showMessage("You Win! 🎉", onClose: _resetGame);
        return;
      }
    } else {
      happyStart = null;
    }

    if (hunger >= 100 && happiness <= 10) {
      _showMessage("Game Over 💀", onClose: _resetGame);
      return;
    }
  }

  void _resetGame() {
    setState(() {
      happiness = 50;
      hunger = 50;
      energy = 60;
      happyStart = null;
      _recomputeMoodAndCheckWinLoss();
    });
  }

  void _showMessage(String msg, {VoidCallback? onClose}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onClose != null) onClose();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Color _moodColor(int happinessLevel) {
    if (happinessLevel > 70) return Colors.green;
    if (happinessLevel >= 30) return Colors.yellow;
    return Colors.red;
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _moodColor(happiness),
                  BlendMode.modulate,
                ),
                child: Image.asset(
                  'assets/pet.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text("Name: $petName", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 4),
              Text("Mood: $moodText", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 12),
              Text(
                "Happiness: $happiness",
                style: const TextStyle(fontSize: 16),
              ),
              Text("Hunger: $hunger", style: const TextStyle(fontSize: 16)),
              Text("Energy: $energy", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              SizedBox(
                width: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("Happiness"),
                    LinearProgressIndicator(
                      value: happiness / 100.0,
                      minHeight: 10,
                    ),
                    const SizedBox(height: 8),
                    const Text("Hunger"),
                    LinearProgressIndicator(
                      value: hunger / 100.0,
                      minHeight: 10,
                    ),
                    const SizedBox(height: 8),
                    const Text("Energy"),
                    LinearProgressIndicator(
                      value: energy / 100.0,
                      minHeight: 10,
                    ),
                  ],
                ),
              ),
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
      ),
    );
  }
}
