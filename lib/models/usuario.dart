import 'package:firebase_auth/firebase_auth.dart';

class Usuario {
  final String uid;
  final String nome;
  final String email;
  const Usuario({required this.uid, required this.nome, required this.email});

  factory Usuario.fromFirebase(User user) => Usuario(
        uid: user.uid,
        nome: user.displayName?.trim().isNotEmpty == true
            ? user.displayName!
            : (user.email?.split('@').first ?? 'Usuário'),
        email: user.email ?? '',
      );
}
