import 'package:flutter/material.dart';

class AtividadeEstudo {
  final String titulo;
  final DateTime data;
  final TimeOfDay horario;

  const AtividadeEstudo({
    required this.titulo,
    required this.data,
    required this.horario,
  });

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
}
