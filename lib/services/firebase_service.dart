import 'package:firebase_database/firebase_database.dart';

import '../models/tarefa.dart';

class FirebaseService {
  final String uid;
  FirebaseService(this.uid);
  DatabaseReference get _tarefas =>
      FirebaseDatabase.instance.ref('tarefas/$uid');

  Stream<List<Tarefa>> acompanhar() => _tarefas.onValue.map((evento) {
        final tarefas = evento.snapshot.children
            .map(
              (item) => Tarefa.fromMap(
                item.key!,
                Map<Object?, Object?>.from(item.value as Map),
              ),
            )
            .toList();
        tarefas.sort((a, b) => a.dataVencimento.compareTo(b.dataVencimento));
        return tarefas;
      });

  Future<void> salvar(Tarefa tarefa) {
    final ref = tarefa.id.isEmpty ? _tarefas.push() : _tarefas.child(tarefa.id);
    return ref.set(tarefa.toMap());
  }

  Future<void> excluir(Tarefa tarefa) => _tarefas.child(tarefa.id).remove();
}
