import 'package:flutter/material.dart';

class AtividadeEstudo {
  final String id;
  final String titulo;
  final DateTime data;
  final TimeOfDay horario;

  const AtividadeEstudo({
    required this.id,
    required this.titulo,
    required this.data,
    required this.horario,
  });

  factory AtividadeEstudo.criar({
    String? id,
    required String titulo,
    required DateTime data,
    required TimeOfDay horario,
  }) {
    return AtividadeEstudo(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      titulo: titulo,
      data: data,
      horario: horario,
    );
  }

  factory AtividadeEstudo.fromMap(Map<String, dynamic> map) {
    return AtividadeEstudo(
      id: map['id'] as String,
      titulo: map['titulo'] as String,
      data: DateTime.fromMillisecondsSinceEpoch(map['data'] as int),
      horario: TimeOfDay(
        hour: map['hora'] as int,
        minute: map['minuto'] as int,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'data': DateUtils.dateOnly(data).millisecondsSinceEpoch,
      'hora': horario.hour,
      'minuto': horario.minute,
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

  DateTime get dataHora {
    return DateTime(
      data.year,
      data.month,
      data.day,
      horario.hour,
      horario.minute,
    );
  }
}
