# Gerenciador de Tarefas — P2

**Aluno:** Pedro Lucas Felippi Santos  
**Curso:** Engenharia de Software — 6º semestre  
**Disciplina:** Programação para Dispositivos Móveis

## Sobre o projeto

Aplicativo desenvolvido em Flutter para gerenciar tarefas pessoais. O usuário pode criar uma conta, fazer login e cadastrar suas tarefas, que ficam salvas no Firebase Realtime Database.

O projeto foi desenvolvido para a avaliação P2 da disciplina.

## Funcionalidades

- Cadastro de usuário com nome, e-mail e senha.
- Login e logout com Firebase Authentication.
- Manutenção da sessão ao fechar e abrir o aplicativo.
- Tela inicial com nome do usuário e quantidade de tarefas.
- Menu lateral com acesso às telas.
- Cadastro, listagem, detalhes, edição e exclusão de tarefas.
- Alteração da situação entre pendente e concluída.
- Atualização das tarefas em tempo real.
- Separação das tarefas por usuário.
- Tema claro e escuro com preferência salva no dispositivo.

Cada tarefa possui título, descrição, data de vencimento, prioridade e situação.

## Tecnologias utilizadas

- Flutter e Dart.
- Firebase Authentication.
- Firebase Realtime Database.
- SharedPreferences.

## Como executar

É necessário ter o Flutter, o Android Studio e o Android SDK instalados.

Abra a pasta do projeto no terminal e execute:

```powershell
flutter pub get
```

Inicie um emulador Android ou conecte um celular com depuração USB ativada. Confira os dispositivos disponíveis:

```powershell
flutter devices
```

Depois, execute:

```powershell
flutter run
```

Para executar no Microsoft Edge:

```powershell
flutter run -d edge
```

## Configuração do Firebase

O aplicativo já está configurado para o projeto `tarefas-p2-pedro`.

A configuração está no arquivo:

```text
lib/firebase_options.dart
```

O projeto utiliza Authentication com e-mail e senha e Realtime Database para armazenar as tarefas.

Para utilizar outro projeto Firebase:

1. Crie um projeto no Firebase Console.
2. Ative o login por e-mail e senha no Authentication.
3. Crie um Realtime Database.
4. Publique as regras do arquivo `database.rules.json`.
5. Configure o FlutterFire:

```powershell
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
```

Selecione Android e Web. Confira se a URL do banco está no campo `databaseURL` do arquivo gerado.

O nome do pacote Android é:

```text
br.com.pedrolucas.tarefas_p2
```

## Organização do código

```text
lib/
├── main.dart
├── firebase_options.dart
├── models/
├── screens/
├── services/
├── widgets/
└── themes/
```

- **models:** classes `Usuario` e `Tarefa`.
- **screens:** telas do aplicativo.
- **services:** autenticação, acesso ao banco e preferências locais.
- **widgets:** menu lateral.
- **themes:** configuração dos temas claro e escuro.

## Armazenamento das tarefas

As tarefas são salvas no Realtime Database neste caminho:

```text
tarefas/uid_do_usuario/id_da_tarefa
```

O UID identifica o usuário e o ID da tarefa é gerado pelo Firebase.

As regras do banco permitem que cada usuário acesse apenas suas próprias tarefas. O aplicativo utiliza `onValue` para acompanhar as alterações em tempo real.

O SharedPreferences salva a preferência de tema. A sessão é gerenciada pelo Firebase Authentication.

## Testes realizados

O aplicativo foi compilado e executado no emulador Android e também testado na Web.

Foram verificados:

- Cadastro, login e logout.
- Cadastro de duas tarefas.
- Listagem e visualização dos detalhes.
- Edição e exclusão.
- Armazenamento dos dados no Firebase.
- Tema escuro após fechar e reabrir o aplicativo.
- Manutenção da sessão.
- Bloqueio de acesso às tarefas de outro usuário.

Para executar os testes automatizados e a análise do código:

```powershell
flutter test
flutter analyze
```

Os três testes automatizados passaram e a análise não encontrou problemas.

## Capturas e vídeo

As capturas de tela estão na pasta:

```text
docs/capturas/
```

O vídeo mostra as funcionalidades do aplicativo no emulador Android e os registros no Firebase. Ele será entregue separadamente do repositório.

## Gerar APK

Para gerar um APK de teste:

```powershell
flutter build apk --debug
```

O arquivo será criado em:

```text
build/app/outputs/flutter-apk/app-debug.apk
```