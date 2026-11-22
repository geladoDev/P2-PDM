import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tarefa.dart';
import '../services/firebase_service.dart';

class CadastroTarefaScreen extends StatefulWidget {
  final Tarefa? tarefaExistente;

  const CadastroTarefaScreen({super.key, this.tarefaExistente});

  @override
  State<CadastroTarefaScreen> createState() => _CadastroTarefaScreenState();
}

class _CadastroTarefaScreenState extends State<CadastroTarefaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _firebaseService = FirebaseService();

  DateTime _dataVencimento = DateTime.now().add(const Duration(days: 1));
  String _prioridade = 'Média';
  bool _concluida = false;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    final t = widget.tarefaExistente;
    if (t != null) {
      _tituloController.text = t.titulo;
      _descricaoController.text = t.descricao;
      _dataVencimento = t.dataVencimento;
      _prioridade = t.prioridade;
      _concluida = t.concluida;
    }
  }

  Future<void> _selecionarData() async {
    final selecionada = await showDatePicker(
      context: context,
      initialDate: _dataVencimento,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );
    if (selecionada != null) {
      setState(() => _dataVencimento = selecionada);
    }
  }

  Future<void> _salvarTarefa() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);
    try {
      final tarefa = Tarefa(
        id: widget.tarefaExistente?.id ?? '',
        titulo: _tituloController.text.trim(),
        descricao: _descricaoController.text.trim(),
        dataVencimento: _dataVencimento,
        prioridade: _prioridade,
        concluida: _concluida,
      );

      if (widget.tarefaExistente == null) {
        await _firebaseService.adicionarTarefa(tarefa);
      } else {
        await _firebaseService.atualizarTarefa(tarefa);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar tarefa: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.tarefaExistente != null;
    final formatoData = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar Tarefa' : 'Nova Tarefa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título da tarefa',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Informe o título da tarefa.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Informe uma descrição para a tarefa.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _prioridade,
                decoration: const InputDecoration(
                  labelText: 'Prioridade',
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'Baixa', child: Text('Baixa')),
                  DropdownMenuItem(value: 'Média', child: Text('Média')),
                  DropdownMenuItem(value: 'Alta', child: Text('Alta')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _prioridade = val);
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                leading: const Icon(Icons.event),
                title: const Text('Data de Vencimento'),
                subtitle: Text(formatoData.format(_dataVencimento)),
                trailing: TextButton(
                  onPressed: _selecionarData,
                  child: const Text('Alterar'),
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Situação: Tarefa Concluída'),
                subtitle: Text(_concluida ? 'Concluída' : 'Pendente'),
                value: _concluida,
                onChanged: (val) => setState(() => _concluida = val),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _salvando ? null : _salvarTarefa,
                icon: const Icon(Icons.save_outlined),
                label: Text(editando ? 'Salvar Alterações' : 'Cadastrar Tarefa'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
