import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../services/preferences_service.dart';
import '../widgets/drawer_menu.dart';
import 'cadastro_tarefa_screen.dart';
import 'configuracoes_screen.dart';
import 'tarefas_screen.dart';

class HomeScreen extends StatefulWidget {
  final PreferencesService preferencias;
  const HomeScreen({super.key, required this.preferencias});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FirebaseService _service;
  late Stream<List<Tarefa>> _stream;
  int _pagina = 0;
  bool _saindo = false;
  @override
  void initState() {
    super.initState();
    _service = FirebaseService(AuthService().usuario.uid);
    _stream = _service.acompanhar();
  }

  Future<void> _navegar(int pagina) async {
    if (pagina != 4) {
      setState(() => _pagina = pagina);
      return;
    }
    if (_saindo) return;
    setState(() => _saindo = true);
    try {
      await AuthService().sair();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(mensagemErro(e))));
      }
    } finally {
      if (mounted) setState(() => _saindo = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = AuthService().usuario;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          [
            'Início',
            'Minhas tarefas',
            'Configurações',
            'Sobre o aplicativo',
          ][_pagina],
        ),
      ),
      drawer: DrawerMenu(
        usuario: usuario,
        selecionado: _pagina,
        navegar: _navegar,
      ),
      floatingActionButton: _pagina <= 1
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => CadastroTarefaScreen(service: _service),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Nova tarefa'),
            )
          : null,
      body: switch (_pagina) {
        2 => ConfiguracoesScreen(preferencias: widget.preferencias),
        3 => ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Icon(Icons.task_alt, size: 64),
              const SizedBox(height: 16),
              Text(
                'Tarefas P2',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Text(
                'Versão 1.0.0\n\nAplicativo de gerenciamento de tarefas pessoais.\n'
                'Desenvolvido por Pedro Lucas Felippi Santos para Programação Mobile.\n\n'
                'Flutter • Firebase Authentication • Realtime Database\n'
                'SharedPreferences • Temas claro e escuro',
              ),
            ],
          ),
        _ => StreamBuilder<List<Tarefa>>(
            stream: _stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_off, size: 48),
                        const SizedBox(height: 16),
                        const Text(
                          'Não foi possível carregar as tarefas. Verifique a internet e as regras do Realtime Database.',
                        ),
                        TextButton(
                          onPressed: () => setState(() {
                            _stream = _service.acompanhar();
                          }),
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final tarefas = snapshot.data!;
              if (_pagina == 1) {
                return TarefasScreen(tarefas: tarefas, service: _service);
              }
              final concluidas = tarefas.where((t) => t.concluida).length;
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                children: [
                  Text(
                    'Olá, ${usuario.nome}!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('Acompanhe suas tarefas e organize seu dia.'),
                  const SizedBox(height: 28),
                  for (final dado in [
                    (Icons.list_alt, 'Cadastradas', tarefas.length),
                    (Icons.schedule, 'Pendentes', tarefas.length - concluidas),
                    (Icons.check_circle_outline, 'Concluídas', concluidas),
                  ])
                    Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Icon(
                          dado.$1,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(dado.$2),
                        trailing: Text(
                          '${dado.$3}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  FilledButton.tonalIcon(
                    onPressed: () => _navegar(1),
                    icon: const Icon(Icons.checklist),
                    label: const Text('Ver minhas tarefas'),
                  ),
                ],
              );
            },
          ),
      },
    );
  }
}
