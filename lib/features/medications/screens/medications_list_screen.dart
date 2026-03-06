import 'package:flutter/material.dart';

class MedicationsListScreen extends StatelessWidget {
  const MedicationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('I miei farmaci')),
      body: const Center(child: Text('Lista farmaci — in costruzione')),
    );
  }
}
