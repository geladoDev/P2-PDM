import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tarefa.dart';
import '../services/firebase_service.dart';
import '../widgets/drawer_menu.dart';
import 'cadastro_tarefa_screen.dart';

class TarefasScreen extends StatelessWidget {
  const TarefasScreen({super.key});

  Color _corPrioridade(String prioridade) {
    switch (prioridade) {
      case 'Alta':
        return Colors.redAccent;
      case 'Média':
        return Colors.orange;
      case 'Baixa':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _iconePrioridade(String prioridade) {
    switch (prioridade) {
      case 'Alta':
        return Icons.priority_high;
      case 'Média':
        return Icons.trending_flat;
      case 'Baixa':
        return Icons.arrow_downward;
      default:
        return Icons.flag_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService();
    final formatoData = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
      ),
      drawer: const DrawerMenu(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CadastroTarefaScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Tarefa'),
      ),
      body: StreamBuilder<List<Tarefa>>(
        stream: firebaseService.listarTarefasStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tarefas = snapshot.data ?? [];
          if (tarefas.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Nenhuma tarefa cadastrada ainda.\nToque em "Nova Tarefa" para começar!',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tarefas.length,
            itemBuilder: (context, index) {
              final tarefa = tarefas[index];
              final corPrio = _corPrioridade(tarefa.prioridade);

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  onTap: () => _mostrarDetalhesTarefa(context, tarefa, formatoData),
                  leading: Checkbox(
                    value: tarefa.concluida,
                    onChanged: (_) => firebaseService.alternarSituacao(tarefa),
                  ),
                  title: Text(
                    tarefa.titulo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: tarefa.concluida ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today, size: 14),
                            const SizedBox(width: 4),
                            Text(formatoData.format(tarefa.dataVencimento)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: corPrio.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: corPrio),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_iconePrioridade(tarefa.prioridade), size: 14, color: corPrio),
                              const SizedBox(width: 4),
                              Text(
                                tarefa.prioridade,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: corPrio,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          tarefa.concluida ? 'Concluída' : 'Pendente',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: tarefa.concluida ? Colors.green : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (acao) async {
                      if (acao == 'editar') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CadastroTarefaScreen(tarefaExistente: tarefa),
                          ),
                        );
                      } else if (acao == 'excluir') {
                        await firebaseService.excluirTarefa(tarefa.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tarefa excluída com sucesso.')),
                          );
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'editar',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 20),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'excluir',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                            SizedBox(width: 8),
                            Text('Excluir', style: TextStyle(color: Colors.redAccent)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _mostrarDetalhesTarefa(
    BuildContext context,
    Tarefa tarefa,
    DateFormat formatoData,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tarefa.titulo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição:', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(tarefa.descricao.isEmpty ? 'Sem descrição.' : tarefa.descricao),
            const SizedBox(height: 12),
            Text('Data de Vencimento: ${formatoData.format(tarefa.dataVencimento)}'),
            const SizedBox(height: 6),
            Text('Prioridade: ${tarefa.prioridade}'),
            const SizedBox(height: 6),
            Text('Situação: ${tarefa.concluida ? "Concluída" : "Pendente"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CadastroTarefaScreen(tarefaExistente: tarefa),
                ),
              );
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Editar'),
          ),
        ],
      ),
    );
  }
}
