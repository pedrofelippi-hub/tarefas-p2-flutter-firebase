import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas_p2/main.dart';
import 'package:tarefas_p2/services/preferences_service.dart';

void main() {
  testWidgets('configuração pendente é exibida no tema salvo', (tester) async {
    SharedPreferences.setMockInitialValues({'tema_escuro': true});
    final preferencias = PreferencesService(
      await SharedPreferences.getInstance(),
    );
    await tester.pumpWidget(
      TarefasApp(
        preferencias: preferencias,
        erroConfiguracao: 'Conecte seu Firebase.',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Conecte seu Firebase.'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.text('Conecte seu Firebase.'))).brightness,
      Brightness.dark,
    );
  });
}
