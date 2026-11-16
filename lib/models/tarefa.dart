enum Prioridade {
  baixa('Baixa'),
  media('Média'),
  alta('Alta');

  final String rotulo;
  const Prioridade(this.rotulo);
}

class Tarefa {
  final String id;
  final String titulo;
  final String descricao;
  final DateTime dataVencimento;
  final Prioridade prioridade;
  final bool concluida;

  const Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.dataVencimento,
    required this.prioridade,
    required this.concluida,
  });

  factory Tarefa.fromMap(String id, Map<Object?, Object?> map) => Tarefa(
        id: id,
        titulo: map['titulo'] as String,
        descricao: map['descricao'] as String,
        dataVencimento: DateTime.parse(map['dataVencimento'] as String),
        prioridade: Prioridade.values.byName(map['prioridade'] as String),
        concluida: map['concluida'] as bool,
      );

  Map<String, Object> toMap() => {
        'titulo': titulo,
        'descricao': descricao,
        'dataVencimento': dataVencimento.toIso8601String(),
        'prioridade': prioridade.name,
        'concluida': concluida,
      };

  Tarefa comSituacao(bool valor) => Tarefa(
        id: id,
        titulo: titulo,
        descricao: descricao,
        dataVencimento: dataVencimento,
        prioridade: prioridade,
        concluida: valor,
      );
}
