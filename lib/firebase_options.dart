import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

// Identificadores de cliente obtidos no console do projeto tarefas-p2-pedro.
// A autorização dos dados é feita pelas regras do Realtime Database.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    if (defaultTargetPlatform == TargetPlatform.android) return android;
    throw UnsupportedError('Este projeto está configurado para Android e Web.');
  }

  static const web = FirebaseOptions(
    apiKey: 'AIzaSyDI-L8DTdygF1fI9JzW6-PJik6dsUVOUp4',
    appId: '1:438546456323:web:f6a466cb2435650e26d336',
    messagingSenderId: '438546456323',
    projectId: 'tarefas-p2-pedro',
    authDomain: 'tarefas-p2-pedro.firebaseapp.com',
    databaseURL: 'https://tarefas-p2-pedro-default-rtdb.firebaseio.com',
    storageBucket: 'tarefas-p2-pedro.firebasestorage.app',
  );

  static const android = FirebaseOptions(
    apiKey: 'AIzaSyDI-L8DTdygF1fI9JzW6-PJik6dsUVOUp4',
    appId: '1:438546456323:android:2eab170e5915455026d336',
    messagingSenderId: '438546456323',
    projectId: 'tarefas-p2-pedro',
    databaseURL: 'https://tarefas-p2-pedro-default-rtdb.firebaseio.com',
    storageBucket: 'tarefas-p2-pedro.firebasestorage.app',
  );
}
