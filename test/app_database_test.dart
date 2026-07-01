import 'package:flutter_test/flutter_test.dart';
import 'package:lista_tarefas/database/app_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('cria as tabelas e persiste usuário e tarefa', () async {
    await AppDatabase.instance.deleteDatabase();

    final usuarioId = await AppDatabase.instance.insertUsuario({
      'nome_usuario': 'aluno',
      'email': 'aluno@teste.com',
      'senha': '123456',
    });

    expect(usuarioId, greaterThan(0));

    final tarefaId = await AppDatabase.instance.insertTarefa({
      'usuario_id': usuarioId,
      'descricao': 'Estudar Flutter',
      'descricao_detalhada': 'Ler documentação sobre widgets.',
      'data_execucao': '2026-07-01',
      'horario_execucao': '19:00',
      'situacao': 'Pendente',
    });

    expect(tarefaId, greaterThan(0));

    final tarefas = await AppDatabase.instance.listarTarefasPorUsuario(
      usuarioId,
    );
    expect(tarefas, hasLength(1));
    expect(tarefas.first['descricao'], 'Estudar Flutter');
    expect(
      tarefas.first['descricao_detalhada'],
      'Ler documentação sobre widgets.',
    );

    await AppDatabase.instance.updateTarefa(
      id: tarefaId,
      usuarioId: usuarioId,
      data: {
        'usuario_id': usuarioId,
        'descricao': 'Estudar Flutter e SQLite',
        'descricao_detalhada': 'Praticar persistência local com sqflite.',
        'data_execucao': '2026-07-02',
        'horario_execucao': '20:00',
        'situacao': 'Concluida',
      },
    );

    final tarefasAtualizadas = await AppDatabase.instance
        .listarTarefasPorUsuario(usuarioId);
    expect(tarefasAtualizadas, hasLength(1));
    expect(tarefasAtualizadas.first['descricao'], 'Estudar Flutter e SQLite');
    expect(
      tarefasAtualizadas.first['descricao_detalhada'],
      'Praticar persistência local com sqflite.',
    );
    expect(tarefasAtualizadas.first['situacao'], 'Concluida');

    await AppDatabase.instance.deleteTarefa(id: tarefaId, usuarioId: usuarioId);

    final tarefasRemovidas = await AppDatabase.instance.listarTarefasPorUsuario(
      usuarioId,
    );
    expect(tarefasRemovidas, isEmpty);
  });
}
