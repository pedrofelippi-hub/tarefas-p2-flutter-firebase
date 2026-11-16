import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import 'cadastro_tarefa_screen.dart';

class TarefasScreen extends StatelessWidget {
  final List<Tarefa> tarefas;
  final FirebaseService service;
  const TarefasScreen({
    super.key,
    required this.tarefas,
    required this.service,
  });
  @override
  Widget build(BuildContext context) {
    if (tarefas.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.playlist_add, size: 64),
              SizedBox(height: 16),
              Text('Nenhuma tarefa ainda.'),
              Text('Toque em Nova tarefa para começar.'),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
      itemCount: tarefas.length,
      itemBuilder: (context, index) => _TarefaCard(
        key: ValueKey(tarefas[index].id),
        tarefa: tarefas[index],
        service: service,
      ),
    );
  }
}

class _TarefaCard extends StatefulWidget {
  final Tarefa tarefa;
  final FirebaseService service;
  const _TarefaCard({super.key, required this.tarefa, required this.service});
  @override
  State<_TarefaCard> createState() => _TarefaCardState();
}

class _TarefaCardState extends State<_TarefaCard> {
  bool _ocupado = false;
  Future<void> _executar(Future<void> Function() acao) async {
    setState(() => _ocupado = true);
    try {
      await acao();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(mensagemErro(e))));
      }
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  void _detalhes() {
    final t = widget.tarefa;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.titulo),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(t.descricao),
              const SizedBox(height: 20),
              Text('Vencimento: ${formatarData(t.dataVencimento)}'),
              Text('Prioridade: ${t.prioridade.rotulo}'),
              Text('Situação: ${t.concluida ? 'Concluída' : 'Pendente'}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _excluir() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir tarefa?'),
        content: Text(
          'Excluir "${widget.tarefa.titulo}"? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmar == true && mounted) {
      await _executar(() => widget.service.excluir(widget.tarefa));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tarefa;
    final cor = switch (t.prioridade) {
      Prioridade.baixa => Colors.green,
      Prioridade.media => Colors.orange,
      Prioridade.alta => Colors.red,
    };
    return Card(
      child: Column(
        children: [
          ListTile(
            isThreeLine: true,
            leading: Checkbox(
              value: t.concluida,
              onChanged: _ocupado
                  ? null
                  : (v) => _executar(
                        () => widget.service.salvar(t.comSituacao(v!)),
                      ),
            ),
            title: Text(
              t.titulo,
              style: TextStyle(
                decoration: t.concluida ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              'Vence em ${formatarData(t.dataVencimento)}\n${t.concluida ? 'Concluída' : 'Pendente'}',
            ),
            onTap: _detalhes,
            trailing: Tooltip(
              message: 'Prioridade ${t.prioridade.rotulo}',
              child: Icon(Icons.flag, color: cor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
            child: Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Prioridade ${t.prioridade.rotulo}'),
                TextButton.icon(
                  onPressed: _ocupado
                      ? null
                      : () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => CadastroTarefaScreen(
                                service: widget.service,
                                tarefa: t,
                              ),
                            ),
                          ),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Editar'),
                ),
                TextButton.icon(
                  onPressed: _ocupado ? null : _excluir,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Excluir'),
                ),
                if (_ocupado)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
