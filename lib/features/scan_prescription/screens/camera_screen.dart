// Camera screen: lets the user photograph or pick a prescription image.
// Accessible design with large tap targets for elderly users.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _picking = false;

  Future<void> _pickImage(ImageSource source) async {
    if (_picking) return;
    setState(() => _picking = true);
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: source,
        imageQuality: 90,
        maxWidth: 2048,
        maxHeight: 2048,
      );
      if (file != null && mounted) {
        context.push(AppRoutes.review, extra: file.path);
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Fotografa la ricetta')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.document_scanner_outlined,
                size: 96,
                color: Color(0xFF1565C0),
              ),
              const SizedBox(height: 20),
              Text(
                'Fotografa la ricetta',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "L'AI estrarrà automaticamente i farmaci,\nle dosi e gli orari.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 56),
              _ActionButton(
                icon: Icons.camera_alt,
                label: 'Fotografa ora',
                onPressed: _picking ? null : () => _pickImage(ImageSource.camera),
              ),
              const SizedBox(height: 16),
              _ActionButton(
                icon: Icons.photo_library_outlined,
                label: 'Scegli dalla galleria',
                onPressed: _picking ? null : () => _pickImage(ImageSource.gallery),
                outlined: true,
              ),
              if (_picking) ...[
                const SizedBox(height: 40),
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text(
                      'Apertura fotocamera…',
                      style: TextStyle(fontSize: AppConstants.labelFontSize),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.outlined = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool outlined;

  static const _height = AppConstants.minButtonHeight + 8.0; // 64dp
  static const _textStyle = TextStyle(
    fontSize: AppConstants.bodyFontSize,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return SizedBox(
        height: _height,
        child: OutlinedButton.icon(
          icon: Icon(icon, size: 30),
          label: Text(label, style: _textStyle),
          onPressed: onPressed,
        ),
      );
    }
    return SizedBox(
      height: _height,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 30),
        label: Text(label, style: _textStyle),
        onPressed: onPressed,
      ),
    );
  }
}
