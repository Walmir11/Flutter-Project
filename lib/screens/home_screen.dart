import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/atividades_controller.dart';
import '../models/atividade_estudo.dart';
import '../widgets/tarefa_item.dart';
import '../widgets/texto_padrao.dart';
import 'cadastro_screen.dart';
import 'detalhes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _abrirTelaCadastro(BuildContext context) async {
    final novaTarefa = await Navigator.push<AtividadeEstudo>(
      context,
      MaterialPageRoute(builder: (context) => const CadastroScreen()),
    );

    if (!context.mounted || novaTarefa == null) {
      return;
    }

    try {
      await context.read<AtividadesController>().adicionar(novaTarefa);

      if (context.mounted) {
        _mostrarMensagemSucesso(context, 'Atividade cadastrada com sucesso!');
      }
    } catch (_) {
      if (context.mounted) {
        _mostrarMensagemErro(
          context,
          'Não foi possível cadastrar a atividade.',
        );
      }
    }
  }

  void _abrirDetalhes(BuildContext context, AtividadeEstudo atividade) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesScreen(atividade: atividade),
      ),
    );
  }

  Future<void> _abrirTelaEdicao(
    BuildContext context,
    AtividadeEstudo atividade,
  ) async {
    final tarefaEditada = await Navigator.push<AtividadeEstudo>(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroScreen(atividade: atividade),
      ),
    );

    if (!context.mounted || tarefaEditada == null) {
      return;
    }

    try {
      await context.read<AtividadesController>().atualizar(tarefaEditada);

      if (context.mounted) {
        _mostrarMensagemSucesso(context, 'Atividade atualizada com sucesso!');
      }
    } catch (_) {
      if (context.mounted) {
        _mostrarMensagemErro(
          context,
          'Não foi possível atualizar a atividade.',
        );
      }
    }
  }

  Future<void> _confirmarRemocao(
    BuildContext context,
    AtividadeEstudo tarefa,
  ) async {
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

    if (!context.mounted) {
      return;
    }

    if (deveRemover == true) {
      await _removerTarefa(context, tarefa);
    }
  }

  Future<void> _removerTarefa(
    BuildContext context,
    AtividadeEstudo tarefa,
  ) async {
    try {
      await context.read<AtividadesController>().remover(tarefa.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Atividade removida: ${tarefa.titulo}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        _mostrarMensagemErro(context, 'Não foi possível remover a atividade.');
      }
    }
  }

  void _mostrarMensagemSucesso(BuildContext context, String mensagem) {
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

  void _mostrarMensagemErro(BuildContext context, String mensagem) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.clearSnackBars();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 4),
        content: Text(mensagem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final total = context.select<AtividadesController, int>(
      (controller) => controller.atividades.length,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Minha Agenda de Estudos')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PainelResumo(total: total),
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
                    onPressed: () => _abrirTelaCadastro(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(child: _ListaAtividades(homeScreen: this)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListaAtividades extends StatelessWidget {
  final HomeScreen homeScreen;

  const _ListaAtividades({required this.homeScreen});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AtividadesController>();
    final colorScheme = Theme.of(context).colorScheme;
    final tarefas = controller.atividades;

    if (controller.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.erro != null && tarefas.isEmpty) {
      return _EstadoErro(
        mensagem: controller.erro!,
        onTentarNovamente: controller.carregarAtividades,
      );
    }

    if (tarefas.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colorScheme.secondary.withValues(alpha: 0.12),
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
      );
    }

    return ListView.builder(
      itemCount: tarefas.length,
      itemBuilder: (context, index) {
        final tarefa = tarefas[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TarefaItem(
            atividade: tarefa,
            onEditar: () => homeScreen._abrirTelaEdicao(context, tarefa),
            onAbrirDetalhes: () => homeScreen._abrirDetalhes(context, tarefa),
            onRemover: () => homeScreen._confirmarRemocao(context, tarefa),
          ),
        );
      },
    );
  }
}

class _EstadoErro extends StatelessWidget {
  final String mensagem;
  final VoidCallback onTentarNovamente;

  const _EstadoErro({required this.mensagem, required this.onTentarNovamente});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 42, color: colorScheme.error),
          const SizedBox(height: 12),
          TextoPadrao(
            mensagem,
            fontSize: 16,
            color: colorScheme.error,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onTentarNovamente,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
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
