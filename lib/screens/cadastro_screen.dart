import 'package:flutter/material.dart';

import '../models/atividade_estudo.dart';
import '../widgets/texto_padrao.dart';

class CadastroScreen extends StatefulWidget {
  final AtividadeEstudo? atividade;

  const CadastroScreen({super.key, this.atividade});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _atividadeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  DateTime? _dataSelecionada;
  TimeOfDay? _horarioSelecionado;

  bool get _modoEdicao => widget.atividade != null;

  @override
  void initState() {
    super.initState();

    final atividade = widget.atividade;
    if (atividade != null) {
      _atividadeController.text = atividade.titulo;
      _descricaoController.text = atividade.descricao;
      _dataSelecionada = atividade.data;
      _horarioSelecionado = atividade.horario;
    }
  }

  @override
  void dispose() {
    _atividadeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvarAtividade() {
    final formularioValido = _formKey.currentState?.validate() ?? false;
    if (!formularioValido) {
      return;
    }

    final atividade = _atividadeController.text.trim();
    final descricao = _descricaoController.text.trim();

    Navigator.pop(
      context,
      AtividadeEstudo(
        id: widget.atividade?.id,
        titulo: atividade,
        descricao: descricao,
        data: _dataSelecionada!,
        horario: _horarioSelecionado!,
        concluida: widget.atividade?.concluida ?? false,
      ),
    );
  }

  Future<void> _selecionarData() async {
    final hoje = DateUtils.dateOnly(DateTime.now());
    final dataAtual = _dataSelecionada == null
        ? null
        : DateUtils.dateOnly(_dataSelecionada!);
    final primeiraData = dataAtual != null && dataAtual.isBefore(hoje)
        ? dataAtual
        : hoje;
    final limitePadrao = DateTime(hoje.year + 3, hoje.month, hoje.day);
    final ultimaData = dataAtual != null && dataAtual.isAfter(limitePadrao)
        ? dataAtual
        : limitePadrao;
    final dataEscolhida = await showDatePicker(
      context: context,
      initialDate: dataAtual ?? hoje,
      firstDate: primeiraData,
      lastDate: ultimaData,
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
      appBar: AppBar(
        title: Text(_modoEdicao ? 'Editar atividade' : 'Cadastrar atividade'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
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
                      Expanded(
                        child: TextoPadrao(
                          _modoEdicao
                              ? 'Atualizar atividade de estudo'
                              : 'Nova atividade de estudo',
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
                        TextFormField(
                          key: const Key('campoAtividade'),
                          controller: _atividadeController,
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Atividade',
                            hintText: 'Ex: Estudar Flutter',
                            prefixIcon: Icon(Icons.menu_book),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Informe a atividade de estudo.';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key('campoDescricaoAtividade'),
                          controller: _descricaoController,
                          minLines: 3,
                          maxLines: 5,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            labelText: 'Descrição',
                            hintText: 'Ex: Revisar widgets, Provider e SQLite',
                            prefixIcon: Icon(Icons.notes),
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormField<DateTime>(
                          initialValue: _dataSelecionada,
                          validator: (_) {
                            if (_dataSelecionada == null) {
                              return 'Selecione uma data para a atividade.';
                            }

                            return null;
                          },
                          builder: (field) {
                            return _CampoSelecaoValidado(
                              errorText: field.errorText,
                              child: _BotaoSelecao(
                                key: const Key('botaoSelecionarData'),
                                icon: Icons.calendar_month,
                                titulo: 'Data',
                                valor: _dataSelecionada == null
                                    ? 'Selecionar data'
                                    : _formatarData(_dataSelecionada!),
                                onPressed: () async {
                                  await _selecionarData();
                                  field.didChange(_dataSelecionada);
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        FormField<TimeOfDay>(
                          initialValue: _horarioSelecionado,
                          validator: (_) {
                            if (_horarioSelecionado == null) {
                              return 'Selecione um horário para a atividade.';
                            }

                            return null;
                          },
                          builder: (field) {
                            return _CampoSelecaoValidado(
                              errorText: field.errorText,
                              child: _BotaoSelecao(
                                key: const Key('botaoSelecionarHorario'),
                                icon: Icons.schedule,
                                titulo: 'Horário',
                                valor: _horarioSelecionado == null
                                    ? 'Selecionar horário'
                                    : _formatarHorario(_horarioSelecionado!),
                                onPressed: () async {
                                  await _selecionarHorario();
                                  field.didChange(_horarioSelecionado);
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 18),
                        FilledButton.icon(
                          key: const Key('botaoSalvarAtividade'),
                          onPressed: _salvarAtividade,
                          icon: const Icon(Icons.save),
                          label: Text(
                            _modoEdicao
                                ? 'Salvar alterações'
                                : 'Salvar atividade',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CampoSelecaoValidado extends StatelessWidget {
  final Widget child;
  final String? errorText;

  const _CampoSelecaoValidado({required this.child, required this.errorText});

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              errorText!,
              style: TextStyle(color: errorColor, fontSize: 12),
            ),
          ),
        ],
      ],
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
