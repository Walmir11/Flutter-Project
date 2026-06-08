import 'package:flutter/foundation.dart';

import '../models/atividade_estudo.dart';
import '../repositories/atividade_estudo_repository.dart';

class AtividadesController extends ChangeNotifier {
  final AtividadeEstudoRepository repository;

  AtividadesController({required this.repository});

  final List<AtividadeEstudo> _atividades = [];
  bool _carregando = false;
  String? _erro;

  List<AtividadeEstudo> get atividades => List.unmodifiable(_atividades);
  bool get carregando => _carregando;
  String? get erro => _erro;

  Future<void> carregarAtividades() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final atividades = await repository.listar();
      _atividades
        ..clear()
        ..addAll(atividades);
    } catch (_) {
      _erro = 'Não foi possível carregar as atividades.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> adicionar(AtividadeEstudo atividade) async {
    await _executar(() async {
      await repository.salvar(atividade);
      _atividades.add(atividade);
      _ordenarAtividades();
    }, 'Não foi possível cadastrar a atividade.');
  }

  Future<void> atualizar(AtividadeEstudo atividade) async {
    await _executar(() async {
      await repository.salvar(atividade);

      final index = _atividades.indexWhere((item) => item.id == atividade.id);
      if (index >= 0) {
        _atividades[index] = atividade;
      }

      _ordenarAtividades();
    }, 'Não foi possível atualizar a atividade.');
  }

  Future<void> remover(String id) async {
    await _executar(() async {
      await repository.remover(id);
      _atividades.removeWhere((atividade) => atividade.id == id);
    }, 'Não foi possível remover a atividade.');
  }

  Future<void> _executar(
    Future<void> Function() acao,
    String mensagemErro,
  ) async {
    _erro = null;

    try {
      await acao();
    } catch (_) {
      _erro = mensagemErro;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  void _ordenarAtividades() {
    _atividades.sort((a, b) => a.dataHora.compareTo(b.dataHora));
  }
}
