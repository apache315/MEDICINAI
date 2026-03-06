import 'package:flutter/material.dart';

class MedicationDetailScreen extends StatelessWidget {
  const MedicationDetailScreen({super.key, required this.medicationId});

  final int medicationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dettaglio farmaco')),
      body: Center(child: Text('Farmaco #$medicationId — in costruzione')),
    );
  }
}
