import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'cadastro_usuario_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => const AutenticacaoForm(cadastro: false);
}

class AutenticacaoForm extends StatefulWidget {
  final bool cadastro;
  const AutenticacaoForm({super.key, required this.cadastro});
  @override
  State<AutenticacaoForm> createState() => _AutenticacaoFormState();
}

class _AutenticacaoFormState extends State<AutenticacaoForm> {
  final _form = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool _ocupado = false;
  bool _ocultar = true;
  String? _erro;
  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _ocupado = true;
      _erro = null;
    });
    try {
      final auth = AuthService();
      if (widget.cadastro) {
        await auth.cadastrar(
          _nome.text.trim(),
          _email.text.trim(),
          _senha.text,
        );
        if (mounted) Navigator.of(context).pop();
      } else {
        await auth.entrar(_email.text.trim(), _senha.text);
      }
    } catch (e) {
      if (mounted) setState(() => _erro = mensagemErro(e));
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar:
            AppBar(title: Text(widget.cadastro ? 'Criar conta' : 'Tarefas P2')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _form,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.cadastro
                            ? 'Organize seus próximos passos'
                            : 'Suas tarefas, em dia.',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.cadastro
                            ? 'Cadastre-se para começar.'
                            : 'Entre para acessar suas tarefas.',
                      ),
                      const SizedBox(height: 28),
                      if (widget.cadastro) ...[
                        TextFormField(
                          controller: _nome,
                          enabled: !_ocupado,
                          textCapitalization: TextCapitalization.words,
                          maxLength: 80,
                          autofillHints: const [AutofillHints.name],
                          decoration: const InputDecoration(labelText: 'Nome'),
                          validator: (v) => (v ?? '').trim().isEmpty
                              ? 'Informe seu nome.'
                              : null,
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _email,
                        enabled: !_ocupado,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        decoration: const InputDecoration(labelText: 'E-mail'),
                        validator: (v) => RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                                .hasMatch((v ?? '').trim())
                            ? null
                            : 'Informe um e-mail válido.',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _senha,
                        enabled: !_ocupado,
                        obscureText: _ocultar,
                        autofillHints: [
                          widget.cadastro
                              ? AutofillHints.newPassword
                              : AutofillHints.password,
                        ],
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          suffixIcon: IconButton(
                            tooltip:
                                _ocultar ? 'Mostrar senha' : 'Ocultar senha',
                            onPressed: () =>
                                setState(() => _ocultar = !_ocultar),
                            icon: Icon(
                              _ocultar
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (v) => (v ?? '').isEmpty
                            ? 'Informe a senha.'
                            : widget.cadastro && v!.length < 6
                                ? 'Use pelo menos 6 caracteres.'
                                : null,
                        onFieldSubmitted: (_) {
                          if (!_ocupado) _enviar();
                        },
                      ),
                      if (_erro != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _erro!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _ocupado ? null : _enviar,
                        child: _ocupado
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(widget.cadastro ? 'Cadastrar' : 'Entrar'),
                      ),
                      if (!widget.cadastro)
                        TextButton(
                          onPressed: _ocupado
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const CadastroUsuarioScreen(),
                                    ),
                                  );
                                },
                          child: const Text('Não tem conta? Cadastre-se'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
