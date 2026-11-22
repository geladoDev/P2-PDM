import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/preferences_service.dart';
import 'themes/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/cadastro_usuario_screen.dart';
import 'screens/home_screen.dart';
import 'screens/tarefas_screen.dart';
import 'screens/configuracoes_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCaRep_bn60j8ebpWT8DhxV0xKFNeF5aXE",
      appId: "1:782880117297:android:83043bbed34a6f597abb10",
      messagingSenderId: "782880117297",
      projectId: 'prova-pdm-532ff',
      databaseURL: 'https://prova-pdm-532ff-default-rtdb.firebaseio.com',
    ),
  );
  await PreferencesService.init();
  runApp(const GerenciadorTarefasApp());
}

class GerenciadorTarefasApp extends StatelessWidget {
  const GerenciadorTarefasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: PreferencesService.themeNotifier,
      builder: (context, currentThemeMode, _) {
        return MaterialApp(
          title: 'Gerenciador de Tarefas',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentThemeMode,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasData && snapshot.data != null) {
                return const HomeScreen();
              }
              return const LoginScreen();
            },
          ),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/cadastro_usuario': (context) => const CadastroUsuarioScreen(),
            '/home': (context) => const HomeScreen(),
            '/tarefas': (context) => const TarefasScreen(),
            '/configuracoes': (context) => const ConfiguracoesScreen(),
          },
        );
      },
    );
  }
}
