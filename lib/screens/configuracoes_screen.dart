import 'package:flutter/material.dart';

import '../services/preferences_service.dart';

class ConfiguracoesScreen extends StatelessWidget {
  final PreferencesService preferencias;
  const ConfiguracoesScreen({super.key, required this.preferencias});
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Deixe do seu jeito',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Tema escuro'),
            subtitle: const Text(
              'A preferência será mantida ao reabrir o aplicativo.',
            ),
            secondary: const Icon(Icons.dark_mode_outlined),
            value: preferencias.escuro,
            onChanged: (valor) async {
              try {
                await preferencias.alterarTema(valor);
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Não foi possível salvar a preferência.'),
                    ),
                  );
                }
              }
            },
          ),
        ],
      );
}
