# Minha Agenda de Estudos

Aplicativo Flutter para cadastro e gerenciamento de atividades de estudo. O projeto funciona como uma agenda de tarefas, permitindo que cada usuário organize seus compromissos acadêmicos por data, horário e status.

## Descrição geral

O projeto **Minha Agenda de Estudos** é uma aplicação mobile desenvolvida em Flutter com persistência local em SQLite. A proposta é ajudar estudantes a registrar atividades, acompanhar tarefas pendentes e manter um histórico simples das tarefas concluídas.

O sistema resolve o problema de organização básica de estudos, centralizando em um único aplicativo as atividades que o usuário precisa realizar. Ele foi pensado principalmente para estudantes que precisam controlar tarefas acadêmicas, revisões, leituras, trabalhos e horários de estudo.

O anexo do Projeto Integrador solicita uma aplicação Flutter com tema livre, organização em camadas, gerenciamento de estado global e uso de dados locais estruturados ou API externa. Este projeto atende a essa proposta usando:

- tema de agenda de estudos;
- arquitetura organizada por telas, controllers, repositories, models, widgets e database;
- gerenciamento de estado com Provider;
- persistência local estruturada com SQLite.

## Funcionalidades principais

### Cadastro de usuário

Permite criar uma conta local informando nome de usuário, e-mail e senha. O sistema valida campos obrigatórios, formato simples de e-mail e tamanho mínimo da senha.

### Login

Permite acessar o aplicativo usando nome de usuário ou e-mail, junto com a senha cadastrada. Após a autenticação, o usuário é direcionado para a tela principal.

### Listagem de tarefas

Exibe as atividades cadastradas pelo usuário logado. A tela principal separa as tarefas em duas abas:

- **Ativas**: tarefas pendentes.
- **Concluídas**: tarefas já finalizadas.

Ao carregar os dados do SQLite, as tarefas são consultadas por usuário e ordenadas por data e horário.

### Cadastro de tarefas

Permite criar uma nova atividade de estudo com:

- título da atividade;
- descrição detalhada opcional;
- data de execução;
- horário de execução.

Toda nova tarefa é cadastrada inicialmente como pendente.

### Edição de tarefas

Permite alterar os dados de uma atividade existente. A tela de cadastro é reaproveitada em modo de edição, preenchendo os campos com os dados atuais da tarefa.

### Exclusão de tarefas

Permite remover tarefas pendentes ou concluídas. Antes da exclusão, o sistema exibe uma caixa de confirmação para evitar remoções acidentais.

### Marcação como concluída

Permite marcar uma tarefa ativa como concluída. Após essa ação, a tarefa sai da aba **Ativas** e passa para a aba **Concluídas**.

### Visualização de detalhes

Permite abrir uma tela específica com os detalhes da atividade, exibindo título, data, horário e descrição, quando houver descrição cadastrada.

### Resumo do usuário

Na tela principal, o sistema mostra:

- usuário logado;
- total de tarefas pendentes;
- total de tarefas concluídas.

### Logout

Permite sair da conta atual, limpar o estado das tarefas carregadas e retornar para a tela de login.

### Funcionalidades não implementadas

Pelo código atual, não foram identificadas as seguintes funcionalidades:

- busca textual de tarefas;
- filtro por prioridade;
- cadastro de prioridade;
- categorias;
- notificações;
- sincronização com API externa;
- opção para reabrir uma tarefa concluída.

## Telas do sistema

### Tela de Login

**Arquivo:** `lib/screens/login_screen.dart`

**Objetivo:** autenticar o usuário e permitir o acesso à agenda.

**Campos disponíveis:**

- Usuário ou e-mail.
- Senha.

**Botões existentes:**

- **Entrar**: valida os campos e tenta autenticar o usuário.
- **Cadastrar**: abre a tela de cadastro de usuário.

**Ações e resultados esperados:**

- Ao informar credenciais válidas, o usuário é redirecionado para a tela principal.
- Ao informar credenciais inválidas, o sistema exibe uma mensagem de erro.
- Ao deixar campos obrigatórios vazios, o formulário mostra mensagens de validação.

### Tela de Cadastro de Usuário

**Arquivo:** `lib/screens/cadastro_usuario_screen.dart`

**Objetivo:** permitir que um novo usuário crie uma conta local.

**Campos disponíveis:**

- Nome de usuário.
- E-mail.
- Senha.

**Botões existentes:**

- **Cadastrar**: salva o usuário no banco local.

**Ações e resultados esperados:**

- Ao preencher os dados corretamente, o usuário é cadastrado e o app retorna para a tela de login.
- Se o nome de usuário ou e-mail já estiver cadastrado, o sistema exibe uma mensagem de erro.
- Se o e-mail não contiver `@`, o formulário informa que o e-mail é inválido.
- Se a senha tiver menos de 4 caracteres, o formulário impede o cadastro.

### Tela Principal / Home

**Arquivo:** `lib/screens/home_screen.dart`

**Objetivo:** listar, acompanhar e gerenciar as atividades do usuário logado.

**Elementos disponíveis:**

- Barra superior com o título **Minha Agenda de Estudos**.
- Botão de logout.
- Abas **Ativas** e **Concluídas**.
- Painel de resumo com usuário logado, pendências e tarefas concluídas.
- Lista de atividades.
- Botão **Adicionar**.

**Botões e ações:**

- **Adicionar**: abre a tela de cadastro de atividade.
- **Sair**: encerra a sessão e retorna para o login.
- **Ícone de detalhes**: abre a tela de detalhes da atividade.
- **Ícone de concluir**: marca uma tarefa ativa como concluída.
- **Ícone de remover**: abre uma confirmação antes de excluir a atividade.
- **Toque no item da lista**: abre a tela de edição da atividade.

**Resultado esperado:**

- As tarefas pendentes aparecem na aba **Ativas**.
- As tarefas concluídas aparecem na aba **Concluídas**.
- Quando não há tarefas, o sistema mostra uma mensagem de lista vazia.

### Tela de Cadastro e Edição de Atividade

**Arquivo:** `lib/screens/cadastro_screen.dart`

**Objetivo:** cadastrar uma nova atividade ou editar uma atividade existente.

**Campos disponíveis:**

- Atividade.
- Descrição.
- Data.
- Horário.

**Botões existentes:**

- **Selecionar data**: abre o seletor de data.
- **Selecionar horário**: abre o seletor de horário.
- **Salvar atividade**: usado no cadastro.
- **Salvar alterações**: usado na edição.

**Ações e resultados esperados:**

- Ao cadastrar uma atividade válida, ela é salva como pendente e aparece na aba **Ativas**.
- Ao editar uma atividade, os dados são atualizados no SQLite e na lista exibida.
- O título, a data e o horário são obrigatórios.
- A descrição é opcional.
- Para novas atividades, o seletor de data considera a data atual como início e permite datas até três anos à frente.

### Tela de Detalhes da Atividade

**Arquivo:** `lib/screens/detalhes_screen.dart`

**Objetivo:** exibir informações completas de uma atividade.

**Informações exibidas:**

- Título da atividade.
- Data.
- Hora.
- Descrição, quando cadastrada.

**Ações disponíveis:**

- Voltar para a tela anterior usando a navegação padrão do app.

**Resultado esperado:**

- O usuário consegue conferir os dados da atividade sem editar o registro.

## Fluxo de uso

1. O usuário abre o aplicativo e visualiza a tela de login.
2. Caso ainda não tenha conta, toca em **Cadastrar**.
3. Na tela de cadastro de usuário, informa nome de usuário, e-mail e senha.
4. Após o cadastro, retorna para o login.
5. Informa usuário/e-mail e senha.
6. Ao autenticar, entra na tela principal da agenda.
7. Na tela principal, visualiza o resumo e as abas de tarefas ativas e concluídas.
8. Toca em **Adicionar** para criar uma nova atividade.
9. Preenche título, descrição, data e horário.
10. Salva a atividade e retorna para a listagem.
11. Na lista, pode editar, ver detalhes, concluir ou remover a atividade.
12. Ao concluir uma tarefa, ela é movida para a aba **Concluídas**.
13. Ao sair, o app limpa o estado da sessão atual e retorna para o login.

## Tecnologias utilizadas

### Flutter

Framework principal usado para construir a interface do aplicativo e executar o projeto em diferentes plataformas.

### Dart

Linguagem de programação utilizada pelo Flutter.

### Material Design

Sistema visual usado nos componentes da interface, como `Scaffold`, `AppBar`, `TextFormField`, `Card`, `TabBar`, `FilledButton` e `IconButton`.

### Provider

Biblioteca usada para gerenciamento de estado global. O `TarefaController` é disponibilizado para a aplicação por meio de `ChangeNotifierProvider`.

### SQLite / sqflite

Banco de dados local usado para armazenar usuários e tarefas.

### sqflite_common_ffi

Suporte ao SQLite em plataformas desktop, como Linux, Windows e macOS.

### sqflite_common_ffi_web

Suporte ao SQLite no ambiente web.

### path

Biblioteca usada para montar corretamente o caminho do arquivo do banco de dados local.

### flutter_test

Ferramenta usada para testes automatizados de widgets e persistência.

## Estrutura de pastas

```text
lista_tarefas/
├── lib/
│   ├── controllers/
│   ├── database/
│   ├── models/
│   ├── repositories/
│   ├── screens/
│   ├── widgets/
│   └── main.dart
├── test/
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
├── pubspec.yaml
└── README.md
```

### `lib/main.dart`

Ponto de entrada da aplicação. Configura o tema visual, registra o `TarefaController` com Provider e define a tela inicial como `LoginScreen`.

### `lib/screens/`

Contém as telas do sistema:

- `login_screen.dart`: tela de autenticação;
- `cadastro_usuario_screen.dart`: tela de criação de conta;
- `home_screen.dart`: tela principal com listagem das tarefas;
- `cadastro_screen.dart`: tela de cadastro e edição de atividade;
- `detalhes_screen.dart`: tela de visualização dos detalhes.

### `lib/controllers/`

Contém classes responsáveis por controlar estado e regras de interação.

- `tarefa_controller.dart`: controller ativo no app, gerencia tarefas pendentes, concluídas, carregamento, cadastro, edição, conclusão, remoção e logout.
- `atividades_controller.dart`: arquivo existente no projeto, mas não integrado ao fluxo atual da aplicação.

### `lib/repositories/`

Contém a camada de acesso a dados.

- `usuario_repository.dart`: cadastra e autentica usuários.
- `tarefa_repository.dart`: lista, adiciona, atualiza e remove tarefas no SQLite.
- `atividade_estudo_repository.dart`: arquivo com implementação baseada em Hive, mas não integrado ao fluxo atual do app.

### `lib/database/`

Contém a configuração do banco local.

- `app_database.dart`: cria o banco `agenda_estudos.db`, define as tabelas `usuarios` e `tarefas`, configura SQLite para mobile, desktop e web, e expõe métodos de inserção, consulta, atualização e exclusão.

### `lib/models/`

Contém os modelos de dados.

- `atividade_estudo.dart`: representa uma atividade, com id, título, descrição, data, horário e status de conclusão.

### `lib/widgets/`

Contém componentes reutilizáveis:

- `tarefa_item.dart`: item visual da lista de tarefas;
- `botao_remover.dart`: botão de exclusão;
- `texto_padrao.dart`: componente de texto com estilo padrão.

### `test/`

Contém testes automatizados:

- `app_database_test.dart`: testa criação de usuário, persistência de tarefa, atualização e remoção no SQLite.
- `widget_test.dart`: testa o fluxo de cadastro, edição, detalhes, conclusão, remoção e logout.

## Como executar o projeto

### Pré-requisitos

- Flutter SDK instalado.
- Dart SDK compatível com o Flutter.
- Um emulador Android, dispositivo físico, navegador ou plataforma desktop configurada.

O projeto usa SDK Dart `^3.11.4`, conforme definido no `pubspec.yaml`.

### Instalar dependências

Na raiz do projeto, execute:

```bash
flutter pub get
```

### Executar o aplicativo

Para iniciar o app:

```bash
flutter run
```

Também é possível escolher um dispositivo específico:

```bash
flutter devices
flutter run -d <id_do_dispositivo>
```

### Executar os testes

```bash
flutter test
```

Resultado verificado durante a elaboração desta documentação:

```text
All tests passed!
```

### Banco de dados e configurações

Não há variáveis de ambiente obrigatórias. O banco SQLite é criado automaticamente pelo aplicativo com o nome:

```text
agenda_estudos.db
```

Tabelas criadas:

- `usuarios`;
- `tarefas`.

No ambiente web, o projeto inclui os arquivos `sqlite3.wasm` e `sqflite_sw.js` dentro da pasta `web/`, necessários para o funcionamento do SQLite via `sqflite_common_ffi_web`.

## Regras de negócio

### Usuários

- O usuário precisa estar cadastrado para acessar a agenda.
- O login pode ser feito com nome de usuário ou e-mail.
- Nome de usuário e e-mail são únicos no banco de dados.
- A senha é obrigatória e deve ter pelo menos 4 caracteres.
- O projeto armazena a senha em texto simples no banco local. Isso funciona para fins acadêmicos, mas não é recomendado para produção.

### Tarefas

- Toda tarefa pertence a um usuário.
- Um usuário visualiza apenas as tarefas vinculadas ao seu próprio `usuario_id`.
- Toda nova tarefa é criada com status `Pendente`.
- Uma tarefa pendente pode ser marcada como `Concluida`.
- Tarefas concluídas são exibidas separadamente na aba **Concluídas**.
- O título da atividade é obrigatório.
- A data da atividade é obrigatória.
- O horário da atividade é obrigatório.
- A descrição detalhada é opcional.
- A edição preserva o status atual da atividade.
- A exclusão remove a tarefa do banco local depois da confirmação do usuário.
- As consultas ao banco ordenam as tarefas por data e horário.

### Estados da interface

- Durante o carregamento das tarefas, a tela principal exibe um indicador de progresso.
- Quando não há tarefas, a tela mostra mensagens específicas para lista vazia.
- Operações bem-sucedidas exibem mensagens de confirmação.
- Erros de login e cadastro são apresentados por meio de `SnackBar`.

## Observações técnicas

O fluxo ativo da aplicação utiliza SQLite por meio de `AppDatabase`, `TarefaRepository`, `UsuarioRepository` e `TarefaController`.

Também existem arquivos relacionados a uma implementação com Hive:

- `lib/controllers/atividades_controller.dart`;
- `lib/repositories/atividade_estudo_repository.dart`.

Esses arquivos não estão integrados ao fluxo principal do aplicativo. No estado atual, a análise estática (`flutter analyze`) aponta erros nesses arquivos, como dependência Hive ausente no `pubspec.yaml` e referências a propriedades que não existem mais no modelo `AtividadeEstudo`. Para manter o projeto mais limpo, uma melhoria recomendada é remover esses arquivos ou atualizá-los para a arquitetura SQLite atual.

## Possíveis melhorias futuras

- Adicionar notificações para lembrar o usuário sobre atividades próximas.
- Criar uma visualização em calendário.
- Implementar prioridade de tarefas.
- Permitir categorias ou disciplinas para organizar os estudos.
- Adicionar busca por título ou descrição.
- Criar filtros por data, status, categoria ou prioridade.
- Permitir reabrir uma tarefa concluída.
- Melhorar a autenticação com hash de senha.
- Integrar com uma API externa para sincronização entre dispositivos.
- Criar histórico mais completo de tarefas concluídas.
- Adicionar edição de perfil do usuário.
- Melhorar responsividade para tablets e telas maiores.
- Remover ou corrigir os arquivos não integrados baseados em Hive.
