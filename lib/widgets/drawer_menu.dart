import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final usuario = authService.usuarioAtual;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                (usuario?.nome.isNotEmpty == true)
                    ? usuario!.nome[0].toUpperCase()
                    : 'U',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            accountName: Text(
              usuario?.nome ?? 'Usuário Autenticado',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(usuario?.email ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Início'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text('Minhas tarefas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/tarefas');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/configuracoes');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre o aplicativo'),
            onTap: () {
              Navigator.pop(context);
              _exibirDialogoSobre(context);
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'Sair',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
            ),
            onTap: () async {
              Navigator.pop(context);
              await authService.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _exibirDialogoSobre(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'TaskManager Pro',
      applicationVersion: '1.0.0 (Avaliação P2)',
      applicationIcon: const Icon(Icons.task_alt, size: 40, color: Colors.blue),
      children: const [
        Text(
          'Aplicativo mobile desenvolvido em Flutter para gerenciamento de tarefas pessoais, '
          'utilizando Firebase Authentication, Firebase Realtime Database e SharedPreferences.',
        ),
      ],
    );
  }
}
