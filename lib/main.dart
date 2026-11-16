import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'services/preferences_service.dart';
import 'themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferencias = PreferencesService(
    await SharedPreferences.getInstance(),
  );
  String? erro;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    erro =
        'A conexão com o Firebase ainda não está pronta.\n\nSiga o README: crie o projeto, ative Authentication e Realtime Database e execute flutterfire configure.';
  }
  runApp(TarefasApp(preferencias: preferencias, erroConfiguracao: erro));
}

class TarefasApp extends StatelessWidget {
  final PreferencesService preferencias;
  final String? erroConfiguracao;
  const TarefasApp({
    super.key,
    required this.preferencias,
    this.erroConfiguracao,
  });

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: preferencias,
        builder: (context, _) => MaterialApp(
          title: 'Tarefas P2',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: preferencias.themeMode,
          locale: const Locale('pt', 'BR'),
          supportedLocales: const [Locale('pt', 'BR')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: erroConfiguracao != null
              ? Scaffold(
                  appBar: AppBar(title: const Text('Configurar Firebase')),
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: SelectableText(erroConfiguracao!),
                    ),
                  ),
                )
              : StreamBuilder(
                  stream: AuthService().alteracoes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Scaffold(
                        body: Center(
                          child: Text(
                            'Erro ao recuperar a sessão. Reinicie o aplicativo.',
                          ),
                        ),
                      );
                    }
                    return snapshot.data == null
                        ? const LoginScreen()
                        : HomeScreen(
                            key: ValueKey(snapshot.data!.uid),
                            preferencias: preferencias,
                          );
                  },
                ),
        ),
      );
}
