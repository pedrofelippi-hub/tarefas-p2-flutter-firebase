# Conferência da P2

| Requisito | Implementação |
| --- | --- |
| RF01 Cadastro, login, logout e sessão | AuthService, telas de autenticação, userChanges |
| RF02 Nome e contagens | home_screen e Usuario |
| RF03 Drawer com cinco opções, nome e e-mail | drawer_menu |
| RF04 Campos de cadastro | cadastro_tarefa_screen e Tarefa |
| RF05 ListView, detalhes, prioridade | tarefas_screen |
| RF06 CRUD e troca de situação | FirebaseService e telas de tarefas |
| RF07 Banco em tempo real e isolamento | tarefas/{uid}, onValue, database.rules.json |
| RF08 Preferência local | PreferencesService / SharedPreferences |
| RF09 Temas globais | AppTheme / MaterialApp.themeMode |

## Antes da entrega final

- [ ] Criar Firebase, ativar E-mail/senha e criar Realtime Database.
- [ ] Publicar regras e gerar firebase_options.dart real.
- [ ] Executar em Android e validar os passos abaixo.
- [ ] Adicionar capturas reais, gravar vídeo e preencher docs/ENTREGA.md.
- [ ] Enviar código e evidências ao repositório Git e conferir o link.

## Validação real com Firebase conectado

- [ ] Campos vazios/e-mail inválido/senha de cadastro curta são rejeitados.
- [ ] Cadastro funciona; nome e e-mail aparecem no menu.
- [ ] Login incorreto mostra erro; login correto entra.
- [ ] Fechar/reabrir sem logout mantém sessão.
- [ ] Duas tarefas salvas com todos os campos aparecem no banco e na lista.
- [ ] Total = pendentes + concluídas no Início.
- [ ] Detalhes mostram descrição e demais campos.
- [ ] Editar muda dados no banco e na lista.
- [ ] Checkbox conclui/reabre e atualiza contagens.
- [ ] Cancelar exclusão mantém a tarefa; confirmar remove do banco e da lista.
- [ ] Segunda instância com mesma conta recebe alterações em tempo real.
- [ ] Segunda conta não vê as tarefas da primeira.
- [ ] Simulador de regras: usuário A pode ler/escrever tarefas/A e não tarefas/B; sem autenticação, acesso negado.
- [ ] Tema muda em todas as telas, inclusive login, e persiste ao fechar/reabrir.
- [ ] Todas as cinco opções do Drawer funcionam.

## Capturas em docs/capturas/

| Arquivo sugerido | Conteúdo |
| --- | --- |
| 01_login.png | Login |
| 02_cadastro_usuario.png | Cadastro sem revelar senha |
| 03_inicio.png | Nome e contagens de duas tarefas |
| 04_drawer.png | Menu completo e dados da conta de teste |
| 05_cadastro_tarefa.png | Campos preenchidos |
| 06_lista.png | Duas tarefas e prioridades/situações distintas |
| 07_detalhes_edicao.png | Detalhes ou edição |
| 08_tema_escuro.png | Tema escuro |
| 09_firebase.png | Dados no Realtime Database vinculados ao UID |

Use conta de teste e não exponha senhas/tokens/dados de terceiros. Capturas não foram fabricadas para representar testes não executados.
