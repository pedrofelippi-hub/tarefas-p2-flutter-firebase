import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService extends ChangeNotifier {
  final SharedPreferences _prefs;
  PreferencesService(this._prefs);
  bool get escuro => _prefs.getBool('tema_escuro') ?? false;
  ThemeMode get themeMode => escuro ? ThemeMode.dark : ThemeMode.light;
  Future<void> alterarTema(bool valor) async {
    if (!await _prefs.setBool('tema_escuro', valor)) {
      throw StateError('Não foi possível salvar o tema.');
    }
    notifyListeners();
  }
}
