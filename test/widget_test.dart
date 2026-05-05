import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lista_tarefas/main.dart';

void main() {
  testWidgets('adiciona, abre detalhes e remove uma atividade de estudo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MeuApp());

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

    expect(find.text('Detalhes da atividade'), findsOneWidget);
    expect(find.text('Data'), findsOneWidget);
    expect(find.text('Hora'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    expect(find.text('Total de atividades: 0'), findsOneWidget);
  });
}
