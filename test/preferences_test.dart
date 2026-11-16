import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas_p2/services/preferences_service.dart';

void main() {
  test('tema escuro é recuperado em uma nova instância', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final service = PreferencesService(prefs);
    expect(service.themeMode, ThemeMode.light);
    await service.alterarTema(true);
    expect(PreferencesService(prefs).themeMode, ThemeMode.dark);
    await service.alterarTema(false);
    expect(PreferencesService(prefs).themeMode, ThemeMode.light);
  });
}
