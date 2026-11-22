class Tarefa {
  String id;
  String titulo;
  String descricao;
  DateTime dataVencimento;
  String prioridade; // 'Baixa', 'Média', 'Alta'
  bool concluida;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.dataVencimento,
    required this.prioridade,
    this.concluida = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'dataVencimento': dataVencimento.toIso8601String(),
      'prioridade': prioridade,
      'concluida': concluida,
    };
  }

  factory Tarefa.fromMap(Map<dynamic, dynamic> map, String id) {
    return Tarefa(
      id: id,
      titulo: map['titulo']?.toString() ?? '',
      descricao: map['descricao']?.toString() ?? '',
      dataVencimento: DateTime.tryParse(map['dataVencimento']?.toString() ?? '') ?? DateTime.now(),
      prioridade: map['prioridade']?.toString() ?? 'Média',
      concluida: map['concluida'] == true,
    );
  }
}
