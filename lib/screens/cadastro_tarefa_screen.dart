import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';

String formatarData(DateTime data) =>
    '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

class CadastroTarefaScreen extends StatefulWidget {
  final FirebaseService service;
  final Tarefa? tarefa;
  const CadastroTarefaScreen({super.key, required this.service, this.tarefa});
  @override
  State<CadastroTarefaScreen> createState() => _CadastroTarefaScreenState();
}

class _CadastroTarefaScreenState extends State<CadastroTarefaScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _titulo;
  late final TextEditingController _descricao;
  late DateTime _data;
  late Prioridade _prioridade;
  late bool _concluida;
  bool _salvando = false;
  @override
  void initState() {
    super.initState();
    final t = widget.tarefa;
    _titulo = TextEditingController(text: t?.titulo);
    _descricao = TextEditingController(text: t?.descricao);
    _data = t?.dataVencimento ?? DateUtils.dateOnly(DateTime.now());
    _prioridade = t?.prioridade ?? Prioridade.media;
    _concluida = t?.concluida ?? false;
  }

  @override
  void dispose() {
    _titulo.dispose();
    _descricao.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _salvando = true);
    try {
      await widget.service.salvar(
        Tarefa(
          id: widget.tarefa?.id ?? '',
          titulo: _titulo.text.trim(),
          descricao: _descricao.text.trim(),
          dataVencimento: _data,
          prioridade: _prioridade,
          concluida: _concluida,
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(mensagemErro(e))));
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.tarefa == null ? 'Nova tarefa' : 'Editar tarefa'),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Form(
              key: _form,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TextFormField(
                    controller: _titulo,
                    enabled: !_salvando,
                    maxLength: 120,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? 'Informe o título.' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descricao,
                    enabled: !_salvando,
                    maxLength: 2000,
                    minLines: 3,
                    maxLines: 6,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    validator: (v) => (v ?? '').trim().isEmpty
                        ? 'Informe a descrição.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_month),
                    title: const Text('Data de vencimento'),
                    subtitle: Text(formatarData(_data)),
                    trailing: const Icon(Icons.edit_calendar),
                    onTap: _salvando
                        ? null
                        : () async {
                            final escolhida = await showDatePicker(
                              context: context,
                              initialDate: _data,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2200),
                            );
                            if (escolhida != null) {
                              setState(() => _data = escolhida);
                            }
                          },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Prioridade>(
                    initialValue: _prioridade,
                    decoration: const InputDecoration(labelText: 'Prioridade'),
                    items: Prioridade.values
                        .map(
                          (p) =>
                              DropdownMenuItem(value: p, child: Text(p.rotulo)),
                        )
                        .toList(),
                    onChanged: _salvando
                        ? null
                        : (p) => setState(() => _prioridade = p!),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Tarefa concluída'),
                    subtitle: Text(_concluida ? 'Concluída' : 'Pendente'),
                    value: _concluida,
                    onChanged: _salvando
                        ? null
                        : (v) => setState(() => _concluida = v),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _salvando ? null : _salvar,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(_salvando ? 'Salvando...' : 'Salvar tarefa'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
