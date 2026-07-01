import 'package:flutter/foundation.dart';

import '../models/atividade_estudo.dart';
import '../repositories/tarefa_repository.dart';

class TarefaController extends ChangeNotifier {
  final TarefaRepository _tarefaRepository;

  TarefaController({TarefaRepository? tarefaRepository})
    : _tarefaRepository = tarefaRepository ?? TarefaRepository();

  final List<AtividadeEstudo> tarefas = [];
  final List<AtividadeEstudo> tarefasConcluidas = [];

  int? _usuarioId;
  bool carregando = false;

  Future<void> carregar(int usuarioId) async {
    _usuarioId = usuarioId;
    carregando = true;
    notifyListeners();

    final atividades = await _tarefaRepository.listarPorUsuario(usuarioId);

    tarefas
      ..clear()
      ..addAll(atividades.where((atividade) => !atividade.concluida));
    tarefasConcluidas
      ..clear()
      ..addAll(atividades.where((atividade) => atividade.concluida));

    carregando = false;
    notifyListeners();
  }

  Future<void> adicionar(AtividadeEstudo atividade) async {
    final usuarioId = _usuarioIdLogado;
    final atividadePendente = atividade.copyWith(concluida: false);
    final id = await _tarefaRepository.adicionar(
      usuarioId: usuarioId,
      atividade: atividadePendente,
    );

    tarefas.add(atividadePendente.copyWith(id: id));
    notifyListeners();
  }

  Future<void> editar(AtividadeEstudo atividadeEditada) async {
    final usuarioId = _usuarioIdLogado;
    final tarefaId = atividadeEditada.id;
    if (tarefaId == null) {
      throw StateError('Nao foi possivel editar uma tarefa sem id.');
    }

    await _tarefaRepository.atualizar(
      usuarioId: usuarioId,
      atividade: atividadeEditada,
    );

    final lista = atividadeEditada.concluida ? tarefasConcluidas : tarefas;
    final index = lista.indexWhere((tarefa) => tarefa.id == tarefaId);
    if (index == -1) {
      tarefas.removeWhere((tarefa) => tarefa.id == tarefaId);
      tarefasConcluidas.removeWhere((tarefa) => tarefa.id == tarefaId);
      lista.add(atividadeEditada);
    } else {
      lista[index] = atividadeEditada;
    }

    notifyListeners();
  }

  Future<void> remover(int index, {required bool concluida}) async {
    final usuarioId = _usuarioIdLogado;
    if (concluida) {
      await _removerDoBanco(tarefasConcluidas[index], usuarioId);
      tarefasConcluidas.removeAt(index);
    } else {
      await _removerDoBanco(tarefas[index], usuarioId);
      tarefas.removeAt(index);
    }
    notifyListeners();
  }

  Future<AtividadeEstudo> concluir(int index) async {
    final usuarioId = _usuarioIdLogado;
    final tarefa = tarefas[index];
    final tarefaConcluida = tarefa.copyWith(concluida: true);
    await _tarefaRepository.atualizar(
      usuarioId: usuarioId,
      atividade: tarefaConcluida,
    );

    tarefas.removeAt(index);
    tarefasConcluidas.add(tarefaConcluida);
    notifyListeners();
    return tarefaConcluida;
  }

  void sair() {
    _usuarioId = null;
    carregando = false;
    tarefas.clear();
    tarefasConcluidas.clear();
    notifyListeners();
  }

  int get _usuarioIdLogado {
    final usuarioId = _usuarioId;
    if (usuarioId == null) {
      throw StateError('Nenhum usuario logado para salvar tarefas.');
    }
    return usuarioId;
  }

  Future<void> _removerDoBanco(AtividadeEstudo atividade, int usuarioId) async {
    final tarefaId = atividade.id;
    if (tarefaId == null) {
      throw StateError('Nao foi possivel remover uma tarefa sem id.');
    }
    await _tarefaRepository.remover(usuarioId: usuarioId, tarefaId: tarefaId);
  }
}
