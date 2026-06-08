import 'package:hive/hive.dart';

import '../models/atividade_estudo.dart';

abstract class AtividadeEstudoRepository {
  Future<List<AtividadeEstudo>> listar();
  Future<void> salvar(AtividadeEstudo atividade);
  Future<void> remover(String id);
}

class HiveAtividadeEstudoRepository implements AtividadeEstudoRepository {
  static const boxName = 'atividades_estudo';

  final Box<dynamic> box;

  const HiveAtividadeEstudoRepository(this.box);

  @override
  Future<List<AtividadeEstudo>> listar() async {
    final atividades = box.values.map((valor) {
      return AtividadeEstudo.fromMap(Map<String, dynamic>.from(valor as Map));
    }).toList();

    atividades.sort((a, b) => a.dataHora.compareTo(b.dataHora));
    return atividades;
  }

  @override
  Future<void> salvar(AtividadeEstudo atividade) {
    return box.put(atividade.id, atividade.toMap());
  }

  @override
  Future<void> remover(String id) {
    return box.delete(id);
  }
}
