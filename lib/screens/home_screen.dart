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

    if (novaTarefa == null) {
      return;
    }

    setState(() {
      tarefas.add(novaTarefa);
    });
  }

  void _abrirDetalhes(AtividadeEstudo atividade) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesScreen(atividade: atividade),
      ),
    );
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
                    : ListView.separated(
                        itemCount: tarefas.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final tarefa = tarefas[index];

                          return TarefaItem(
                            atividade: tarefa,
                            onAbrirDetalhes: () => _abrirDetalhes(tarefa),
                            onRemover: () => _removerTarefa(index),
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
