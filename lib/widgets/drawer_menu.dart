import 'package:flutter/material.dart';

import '../models/usuario.dart';

class DrawerMenu extends StatelessWidget {
  final Usuario usuario;
  final int selecionado;
  final ValueChanged<int> navegar;
  const DrawerMenu({
    super.key,
    required this.usuario,
    required this.selecionado,
    required this.navegar,
  });

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(usuario.nome),
              accountEmail: Text(usuario.email),
              currentAccountPicture:
                  const CircleAvatar(child: Icon(Icons.person)),
            ),
            for (final item in const [
              (Icons.home_outlined, 'Início'),
              (Icons.checklist, 'Minhas tarefas'),
              (Icons.settings_outlined, 'Configurações'),
              (Icons.info_outline, 'Sobre o aplicativo'),
              (Icons.logout, 'Sair'),
            ].indexed)
              ListTile(
                leading: Icon(item.$2.$1),
                title: Text(item.$2.$2),
                selected: selecionado == item.$1,
                onTap: () {
                  Navigator.of(context).pop();
                  navegar(item.$1);
                },
              ),
          ],
        ),
      );
}
