import 'package:flutter/material.dart';

import '../models/atividade_estudo.dart';
import '../widgets/texto_padrao.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _atividadeController = TextEditingController();
  DateTime? _dataSelecionada;
  TimeOfDay? _horarioSelecionado;

  @override
  void dispose() {
    _atividadeController.dispose();
    super.dispose();
  }

  void _salvarAtividade() {
    final atividade = _atividadeController.text.trim();

    if (atividade.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite uma atividade de estudo.')),
      );
      return;
    }

    if (_dataSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma data para a atividade.')),
      );
      return;
    }

    if (_horarioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um horário para a atividade.')),
      );
      return;
    }

    Navigator.pop(
      context,
      AtividadeEstudo(
        titulo: atividade,
        data: _dataSelecionada!,
        horario: _horarioSelecionado!,
      ),
    );
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();
    final dataEscolhida = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? hoje,
      firstDate: hoje,
      lastDate: DateTime(hoje.year + 3),
    );

    if (dataEscolhida == null) {
      return;
    }

    setState(() {
      _dataSelecionada = dataEscolhida;
    });
  }

  Future<void> _selecionarHorario() async {
    final horarioEscolhido = await showTimePicker(
      context: context,
      initialTime: _horarioSelecionado ?? TimeOfDay.now(),
    );

    if (horarioEscolhido == null) {
      return;
    }

    setState(() {
      _horarioSelecionado = horarioEscolhido;
    });
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }

  String _formatarHorario(TimeOfDay horario) {
    final hora = horario.hour.toString().padLeft(2, '0');
    final minuto = horario.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar atividade')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.edit_calendar,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: TextoPadrao(
                        'Nova atividade de estudo',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        key: const Key('campoAtividade'),
                        controller: _atividadeController,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Atividade',
                          hintText: 'Ex: Estudar Flutter',
                          prefixIcon: Icon(Icons.menu_book),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _BotaoSelecao(
                        key: const Key('botaoSelecionarData'),
                        icon: Icons.calendar_month,
                        titulo: 'Data',
                        valor: _dataSelecionada == null
                            ? 'Selecionar data'
                            : _formatarData(_dataSelecionada!),
                        onPressed: _selecionarData,
                      ),
                      const SizedBox(height: 12),
                      _BotaoSelecao(
                        key: const Key('botaoSelecionarHorario'),
                        icon: Icons.schedule,
                        titulo: 'Horário',
                        valor: _horarioSelecionado == null
                            ? 'Selecionar horário'
                            : _formatarHorario(_horarioSelecionado!),
                        onPressed: _selecionarHorario,
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        key: const Key('botaoSalvarAtividade'),
                        onPressed: _salvarAtividade,
                        icon: const Icon(Icons.save),
                        label: const Text('Salvar atividade'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotaoSelecao extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String valor;
  final VoidCallback onPressed;

  const _BotaoSelecao({
    super.key,
    required this.icon,
    required this.titulo,
    required this.valor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.secondary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colorScheme.secondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextoPadrao(
                  titulo,
                  fontSize: 13,
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 2),
                TextoPadrao(valor, fontSize: 16, fontWeight: FontWeight.w600),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: colorScheme.secondary),
        ],
      ),
    );
  }
}
