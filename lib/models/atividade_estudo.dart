import 'package:flutter/material.dart';

class AtividadeEstudo {
  final int? id;
  final String titulo;
  final String descricao;
  final DateTime data;
  final TimeOfDay horario;
  final bool concluida;

  const AtividadeEstudo({
    this.id,
    required this.titulo,
    this.descricao = '',
    required this.data,
    required this.horario,
    this.concluida = false,
  });

  AtividadeEstudo copyWith({
    int? id,
    String? titulo,
    String? descricao,
    DateTime? data,
    TimeOfDay? horario,
    bool? concluida,
  }) {
    return AtividadeEstudo(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      data: data ?? this.data,
      horario: horario ?? this.horario,
      concluida: concluida ?? this.concluida,
    );
  }

  factory AtividadeEstudo.fromMap(Map<String, Object?> map) {
    final horarioBanco = (map['horario_execucao'] as String).split(':');

    return AtividadeEstudo(
      id: map['id'] as int?,
      titulo: map['descricao'] as String,
      descricao: map['descricao_detalhada'] as String? ?? '',
      data: DateTime.parse(map['data_execucao'] as String),
      horario: TimeOfDay(
        hour: int.parse(horarioBanco[0]),
        minute: int.parse(horarioBanco[1]),
      ),
      concluida: map['situacao'] == 'Concluida',
    );
  }

  Map<String, Object?> toMap({required int usuarioId}) {
    return {
      'usuario_id': usuarioId,
      'descricao': titulo,
      'descricao_detalhada': descricao,
      'data_execucao': _dataBanco,
      'horario_execucao': horarioFormatado,
      'situacao': concluida ? 'Concluida' : 'Pendente',
    };
  }

  String get dataFormatada {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }

  String get horarioFormatado {
    final hora = horario.hour.toString().padLeft(2, '0');
    final minuto = horario.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  String get _dataBanco {
    final mes = data.month.toString().padLeft(2, '0');
    final dia = data.day.toString().padLeft(2, '0');
    return '${data.year}-$mes-$dia';
  }
}
