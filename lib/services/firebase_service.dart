import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/tarefa.dart';

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  DatabaseReference _tarefasRef() {
    final uid = _uid;
    if (uid == null) {
      throw Exception('Usuário não autenticado.');
    }
    return _db.child('tarefas').child(uid);
  }

  // Listener em tempo real das tarefas do usuário autenticado (RF07)
  Stream<List<Tarefa>> listarTarefasStream() {
    final uid = _uid;
    if (uid == null) return Stream.value([]);

    return _db.child('tarefas').child(uid).onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data is! Map) return <Tarefa>[];

      final List<Tarefa> lista = [];
      data.forEach((key, value) {
        if (value is Map) {
          lista.add(Tarefa.fromMap(value, key.toString()));
        }
      });

      lista.sort((a, b) => a.dataVencimento.compareTo(b.dataVencimento));
      return lista;
    });
  }

  Future<void> adicionarTarefa(Tarefa tarefa) async {
    final ref = _tarefasRef().push();
    tarefa.id = ref.key ?? DateTime.now().millisecondsSinceEpoch.toString();
    await ref.set(tarefa.toMap());
  }

  Future<void> atualizarTarefa(Tarefa tarefa) async {
    await _tarefasRef().child(tarefa.id).update(tarefa.toMap());
  }

  Future<void> alternarSituacao(Tarefa tarefa) async {
    await _tarefasRef().child(tarefa.id).update({
      'concluida': !tarefa.concluida,
    });
  }

  Future<void> excluirTarefa(String tarefaId) async {
    await _tarefasRef().child(tarefaId).remove();
  }
}
