import 'package:flutter_test/flutter_test.dart';
import 'package:tarefas_p2/models/tarefa.dart';

void main() {
  test('serialização mantém todos os campos usados pelo CRUD', () {
    for (final prioridade in Prioridade.values) {
      final original = Tarefa(
        id: 'id-1',
        titulo: 'Apresentar P2',
        descricao: 'Demonstrar o aplicativo',
        dataVencimento: DateTime(2026, 11, 30),
        prioridade: prioridade,
        concluida: false,
      );
      final recuperada = Tarefa.fromMap(original.id, original.toMap());
      expect(recuperada.id, original.id);
      expect(recuperada.toMap(), original.toMap());
      expect(recuperada.comSituacao(true).concluida, isTrue);
      expect(recuperada.comSituacao(true).titulo, original.titulo);
      expect(recuperada.concluida, isFalse);
    }
  });
}
