import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lista_tarefas/main.dart';
import 'package:lista_tarefas/models/atividade_estudo.dart';
import 'package:lista_tarefas/repositories/atividade_estudo_repository.dart';

void main() {
  testWidgets(
    'cadastra, edita, abre detalhes e remove uma atividade de estudo',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MeuApp(repository: _AtividadeEstudoRepositoryMemoria()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Total de atividades: 0'), findsOneWidget);
      expect(find.text('Nenhuma atividade cadastrada.'), findsOneWidget);

      await tester.tap(find.byKey(const Key('botaoAdicionarAtividade')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('campoAtividade')),
        'Estudar Flutter',
      );
      await tester.tap(find.byKey(const Key('botaoSelecionarData')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('botaoSelecionarHorario')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('botaoSalvarAtividade')));
      await tester.pumpAndSettle();

      expect(find.text('Total de atividades: 1'), findsOneWidget);
      expect(find.text('Estudar Flutter'), findsOneWidget);

      await tester.tap(find.text('Estudar Flutter'));
      await tester.pumpAndSettle();

      expect(find.text('Editar atividade'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('campoAtividade')),
        'Revisar Flutter',
      );
      await tester.tap(find.byKey(const Key('botaoSalvarAtividade')));
      await tester.pumpAndSettle();

      expect(find.text('Revisar Flutter'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();

      expect(find.text('Detalhes da atividade'), findsOneWidget);
      expect(find.text('Data'), findsOneWidget);
      expect(find.text('Hora'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Remover atividade'), findsOneWidget);

      await tester.tap(find.text('Remover'));
      await tester.pumpAndSettle();

      expect(find.text('Total de atividades: 0'), findsOneWidget);
    },
  );
}

class _AtividadeEstudoRepositoryMemoria implements AtividadeEstudoRepository {
  final List<AtividadeEstudo> _atividades = [];

  @override
  Future<List<AtividadeEstudo>> listar() async {
    return List.of(_atividades);
  }

  @override
  Future<void> salvar(AtividadeEstudo atividade) async {
    final index = _atividades.indexWhere((item) => item.id == atividade.id);
    if (index >= 0) {
      _atividades[index] = atividade;
      return;
    }

    _atividades.add(atividade);
  }

  @override
  Future<void> remover(String id) async {
    _atividades.removeWhere((atividade) => atividade.id == id);
  }
}
