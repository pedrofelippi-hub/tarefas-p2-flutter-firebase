# Validação da interface Web — 16/11/2026

Executada com o build de produção Flutter Web e Firebase real.

| Cenário | Resultado observado |
| --- | --- |
| Cadastro | Conta de demonstração criada; nome apresentado no início e Drawer |
| Duas tarefas | Contagens: 2 cadastradas, 1 pendente, 1 concluída |
| ListView | Duas tarefas com título, data, prioridade e situação |
| Edição | Título alterado e prioridade de Média para Alta; lista atualizada |
| Detalhes | Diálogo aberto com dados da tarefa |
| Exclusão | Confirmação exibida; tarefa de demonstração removida; lista com uma tarefa |
| Tema | Tema escuro aplicado; recarga manteve tema e sessão |
| Logout | Retorno ao login em tema escuro |
| Erro de login | Credenciais incorretas exibiram mensagem adequada |
| Login | Conta controlada de teste autenticada pela interface |
| Isolamento | Segunda conta mostrou zero tarefas, sem revelar dados da primeira |

Limites: o teste foi Web; não equivale a execução Android. O vídeo obrigatório ainda não foi gravado. A transmissão simultânea entre duas instâncias da mesma conta não foi verificada visualmente.

As contas são exclusivas de teste. Não use os e-mails de demonstração para recuperação de conta.
