import '../database/app_database.dart';
import '../models/atividade_estudo.dart';

class TarefaRepository {
  final AppDatabase _appDatabase;

  TarefaRepository({AppDatabase? appDatabase})
    : _appDatabase = appDatabase ?? AppDatabase.instance;

  Future<List<AtividadeEstudo>> listarPorUsuario(int usuarioId) async {
    final tarefas = await _appDatabase.listarTarefasPorUsuario(usuarioId);
    return tarefas.map(AtividadeEstudo.fromMap).toList();
  }

  Future<int> adicionar({
    required int usuarioId,
    required AtividadeEstudo atividade,
  }) {
    return _appDatabase.insertTarefa(atividade.toMap(usuarioId: usuarioId));
  }

  Future<void> atualizar({
    required int usuarioId,
    required AtividadeEstudo atividade,
  }) async {
    final id = atividade.id;
    if (id == null) {
      throw StateError('Nao foi possivel atualizar uma tarefa sem id.');
    }

    await _appDatabase.updateTarefa(
      id: id,
      usuarioId: usuarioId,
      data: atividade.toMap(usuarioId: usuarioId),
    );
  }

  Future<void> remover({required int usuarioId, required int tarefaId}) async {
    await _appDatabase.deleteTarefa(id: tarefaId, usuarioId: usuarioId);
  }
}
