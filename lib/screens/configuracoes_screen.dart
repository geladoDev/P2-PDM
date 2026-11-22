import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: PreferencesService.themeNotifier,
        builder: (context, themeMode, _) {
          final isDark = themeMode == ThemeMode.dark;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: SwitchListTile(
                  secondary: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                  ),
                  title: const Text('Tema Escuro (Dark Mode)'),
                  subtitle: const Text(
                    'Altera a aparência de todas as telas e salva sua preferência no dispositivo (SharedPreferences).',
                  ),
                  value: isDark,
                  onChanged: (valor) {
                    PreferencesService.setDarkTheme(valor);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
