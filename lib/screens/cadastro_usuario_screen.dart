import 'package:flutter/material.dart';

import 'login_screen.dart';

class CadastroUsuarioScreen extends StatelessWidget {
  const CadastroUsuarioScreen({super.key});
  @override
  Widget build(BuildContext context) => const AutenticacaoForm(cadastro: true);
}
