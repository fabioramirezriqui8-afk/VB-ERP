import 'package:flutter/material.dart';
import '../data/theme_storage.dart';
import 'theme_controller.dart';
import 'theme_settings_body.dart';

/// Solo scaffold + navegación — sin lógica ni estado
class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key, required this.controller});
  final ThemeController controller;

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apariencia'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ThemeSettingsBody(controller: widget.controller),
    );
  }
}
