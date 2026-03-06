import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MediRemind')),
      body: const Center(child: Text('Schermata principale — in costruzione')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.scan),
        icon: const Icon(Icons.document_scanner_outlined),
        label: const Text('Scansiona ricetta'),
      ),
    );
  }
}
