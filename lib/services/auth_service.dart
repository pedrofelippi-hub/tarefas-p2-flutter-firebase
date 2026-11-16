import 'package:firebase_auth/firebase_auth.dart';

import '../models/usuario.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get alteracoes => _auth.userChanges();
  Usuario get usuario => Usuario.fromFirebase(_auth.currentUser!);

  Future<void> cadastrar(String nome, String email, String senha) async {
    final resultado = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
    await resultado.user!.updateDisplayName(nome);
  }

  Future<void> entrar(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> sair() => _auth.signOut();
}

String mensagemErro(Object erro) {
  if (erro is FirebaseAuthException) {
    return switch (erro.code) {
      'email-already-in-use' => 'Este e-mail já está cadastrado.',
      'invalid-email' => 'Informe um e-mail válido.',
      'weak-password' => 'Use uma senha com pelo menos 6 caracteres.',
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' =>
        'E-mail ou senha incorretos.',
      'user-disabled' => 'Esta conta foi desativada.',
      'too-many-requests' => 'Muitas tentativas. Aguarde e tente novamente.',
      'network-request-failed' => 'Sem conexão. Verifique sua internet.',
      'operation-not-allowed' =>
        'Ative o provedor E-mail/senha no Firebase Authentication.',
      _ => 'Não foi possível autenticar. Tente novamente.',
    };
  }
  return 'Não foi possível concluir a operação. Verifique a conexão e as permissões do banco.';
}
