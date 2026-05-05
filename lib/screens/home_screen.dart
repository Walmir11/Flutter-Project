import 'package:flutter/material.dart';

import '../models/atividade_estudo.dart';
import '../widgets/tarefa_item.dart';
import '../widgets/texto_padrao.dart';
import 'cadastro_screen.dart';
import 'detalhes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<AtividadeEstudo> tarefas = [];

  Future<void> _abrirTelaCadastro() async {
    final novaTarefa = await Navigator.push<AtividadeEstudo>(
      context,
      MaterialPageRoute(builder: (context) => const CadastroScreen()),
    );

    if (!mounted || novaTarefa == null) {
      return;
    }

    setState(() {
      tarefas.add(novaTarefa);
    });

    _mostrarMensagemSucesso('Atividade cadastrada com sucesso!');
  }

  void _abrirDetalhes(AtividadeEstudo atividade) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesScreen(atividade: atividade),
      ),
    );
  }

  Future<void> _abrirTelaEdicao(int index) async {
    final tarefaEditada = await Navigator.push<AtividadeEstudo>(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroScreen(atividade: tarefas[index]),
      ),
    );

    if (!mounted || tarefaEditada == null) {
      return;
    }

    setState(() {
      tarefas[index] = tarefaEditada;
    });

    _mostrarMensagemSucesso('Atividade atualizada com sucesso!');
  }

  Future<void> _confirmarRemocao(int index) async {
    final tarefa = tarefas[index];
    final deveRemover = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remover atividade'),
          content: Text('Deseja remover "${tarefa.titulo}" da sua agenda?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (deveRemover == true) {
      _removerTarefa(index);
    }
  }

  void _removerTarefa(int index) {
    final tarefaRemovida = tarefas[index];

    setState(() {
      tarefas.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Atividade removida: ${tarefaRemovida.titulo}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _mostrarMensagemSucesso(String mensagem) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.clearSnackBars();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF0F766E),
        duration: const Duration(seconds: 4),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                mensagem,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Minha Agenda de Estudos')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PainelResumo(total: tarefas.length),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextoPadrao(
                      'Próximas atividades',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  FilledButton.icon(
                    key: const Key('botaoAdicionarAtividade'),
                    onPressed: _abrirTelaCadastro,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: tarefas.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: colorScheme.secondary.withValues(
                                  alpha: 0.12,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.event_note,
                                size: 34,
                                color: colorScheme.secondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const TextoPadrao(
                              'Nenhuma atividade cadastrada.',
                              fontSize: 16,
                              color: Color(0xFF607D8B),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: tarefas.length,
                        itemBuilder: (context, index) {
                          final tarefa = tarefas[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TarefaItem(
                              atividade: tarefa,
                              onEditar: () => _abrirTelaEdicao(index),
                              onAbrirDetalhes: () => _abrirDetalhes(tarefa),
                              onRemover: () => _confirmarRemocao(index),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PainelResumo extends StatelessWidget {
  final int total;

  const _PainelResumo({required this.total});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.18),
            offset: const Offset(0, 10),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextoPadrao(
                  'Plano de estudos',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                const SizedBox(height: 6),
                TextoPadrao(
                  'Total de atividades: $total',
                  fontSize: 15,
                  color: const Color(0xFFD7E6EF),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
