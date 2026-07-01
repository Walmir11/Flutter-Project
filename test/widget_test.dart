import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:lista_tarefas/controllers/tarefa_controller.dart';
import 'package:lista_tarefas/models/atividade_estudo.dart';
import 'package:lista_tarefas/repositories/tarefa_repository.dart';
import 'package:lista_tarefas/screens/cadastro_screen.dart';
import 'package:lista_tarefas/screens/home_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'cadastra, edita, abre detalhes e remove uma atividade de estudo',
    (WidgetTester tester) async {
      final tarefaRepository = _TarefaRepositoryFake();
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => TarefaController(tarefaRepository: tarefaRepository),
          child: const MaterialApp(
            home: HomeScreen(usuarioId: 1, usuarioLogado: 'aluno'),
          ),
        ),
      );

      await _pumpAteEncontrar(
        tester,
        find.byKey(const Key('botaoAdicionarAtividade')),
      );

      expect(find.text('Pendentes: 0 • Concluídas: 0'), findsOneWidget);
      expect(find.text('Usuário logado: aluno'), findsOneWidget);
      expect(find.text('Nenhuma atividade pendente.'), findsOneWidget);

      await tester.tap(find.byKey(const Key('botaoAdicionarAtividade')));
      await _pumpAteEncontrar(tester, find.byKey(const Key('campoAtividade')));

      await tester.enterText(
        find.byKey(const Key('campoAtividade')),
        'Estudar Flutter',
      );
      await tester.enterText(
        find.byKey(const Key('campoDescricaoAtividade')),
        'Ler capítulos 1 e 2 antes de praticar.',
      );
      await tester.tap(find.byKey(const Key('botaoSelecionarData')));
      await _pumpAteEncontrar(tester, find.text('OK'));
      await tester.tap(find.text('OK'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.byKey(const Key('botaoSelecionarHorario')));
      await _pumpAteEncontrar(tester, find.text('OK'));
      await tester.tap(find.text('OK'));
      await tester.pump(const Duration(milliseconds: 300));

      await _tocarBotaoSalvarAtividade(tester);
      await _pumpAteEncontrar(
        tester,
        find.byKey(const Key('botaoAdicionarAtividade')),
      );

      expect(find.text('Pendentes: 1 • Concluídas: 0'), findsOneWidget);
      expect(find.text('Estudar Flutter'), findsOneWidget);
      expect(find.text('Ler capítulos 1 e 2 antes de praticar.'), findsNothing);

      await tester.tap(find.text('Estudar Flutter'));
      await _pumpAteEncontrar(tester, find.text('Editar atividade'));

      expect(find.text('Editar atividade'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('campoAtividade')),
        'Revisar Flutter',
      );
      await _tocarBotaoSalvarAtividade(tester);
      await _pumpAteEncontrar(
        tester,
        find.byKey(const Key('botaoAdicionarAtividade')),
      );

      expect(find.text('Revisar Flutter'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.check_circle_outline));
      await _pumpAteEncontrar(
        tester,
        find.text('Pendentes: 0 • Concluídas: 1'),
      );

      expect(find.text('Pendentes: 0 • Concluídas: 1'), findsOneWidget);

      await tester.tap(find.text('Concluídas'));
      await tester.pump(const Duration(seconds: 1));
      await _pumpAteEncontrar(tester, find.text('Revisar Flutter'));

      await tester.tap(find.byIcon(Icons.info_outline));
      await _pumpAteEncontrar(tester, find.text('Detalhes da atividade'));

      expect(find.text('Detalhes da atividade'), findsOneWidget);
      expect(find.text('Data'), findsOneWidget);
      expect(find.text('Hora'), findsOneWidget);
      expect(find.text('Descrição'), findsOneWidget);
      expect(
        find.text('Ler capítulos 1 e 2 antes de praticar.'),
        findsOneWidget,
      );

      await tester.pageBack();
      await _pumpAteEncontrar(tester, find.text('Revisar Flutter'));

      await tester.tap(find.byIcon(Icons.delete));
      await _pumpAteEncontrar(tester, find.text('Remover atividade'));

      expect(find.text('Remover atividade'), findsOneWidget);

      await tester.tap(find.text('Remover'));
      await _pumpAteEncontrar(
        tester,
        find.text('Pendentes: 0 • Concluídas: 0'),
      );

      expect(find.text('Pendentes: 0 • Concluídas: 0'), findsOneWidget);
      expect(tarefaRepository.tarefas, isEmpty);

      await tester.tap(find.byKey(const Key('botaoLogout')));
      await _pumpAteEncontrar(tester, find.text('Entrar'));

      expect(find.text('Agenda de Estudos'), findsOneWidget);
    },
  );

  testWidgets('abre o seletor de data ao editar atividade com data passada', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CadastroScreen(
          atividade: AtividadeEstudo(
            id: 1,
            titulo: 'Revisar conteúdo antigo',
            data: DateTime(2000, 1, 2),
            horario: const TimeOfDay(hour: 8, minute: 30),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('botaoSelecionarData')));
    await tester.pumpAndSettle();

    expect(find.text('OK'), findsOneWidget);
  });
}

Future<void> _pumpAteEncontrar(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  final limite = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(limite)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) {
      await tester.pump(const Duration(milliseconds: 500));
      return;
    }
  }

  expect(finder, findsOneWidget);
}

Future<void> _tocarBotaoSalvarAtividade(WidgetTester tester) async {
  final botaoSalvar = find.byKey(const Key('botaoSalvarAtividade'));
  await tester.ensureVisible(botaoSalvar);
  await tester.pump(const Duration(milliseconds: 300));
  await tester.tap(botaoSalvar);
}

class _TarefaRepositoryFake extends TarefaRepository {
  final List<AtividadeEstudo> tarefas = [];
  int _proximoId = 1;

  @override
  Future<List<AtividadeEstudo>> listarPorUsuario(int usuarioId) async {
    return List.of(tarefas);
  }

  @override
  Future<int> adicionar({
    required int usuarioId,
    required AtividadeEstudo atividade,
  }) async {
    final id = _proximoId++;
    tarefas.add(atividade.copyWith(id: id));
    return id;
  }

  @override
  Future<void> atualizar({
    required int usuarioId,
    required AtividadeEstudo atividade,
  }) async {
    final index = tarefas.indexWhere((tarefa) => tarefa.id == atividade.id);
    tarefas[index] = atividade;
  }

  @override
  Future<void> remover({required int usuarioId, required int tarefaId}) async {
    tarefas.removeWhere((tarefa) => tarefa.id == tarefaId);
  }
}
