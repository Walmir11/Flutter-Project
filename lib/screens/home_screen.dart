import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/tarefa_controller.dart';
import '../models/atividade_estudo.dart';
import '../widgets/tarefa_item.dart';
import '../widgets/texto_padrao.dart';
import 'cadastro_screen.dart';
import 'detalhes_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final int usuarioId;
  final String usuarioLogado;

  const HomeScreen({
    super.key,
    required this.usuarioId,
    required this.usuarioLogado,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      if (mounted) {
        context.read<TarefaController>().carregar(widget.usuarioId);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _abrirTelaCadastro() async {
    final novaTarefa = await Navigator.push<AtividadeEstudo>(
      context,
      MaterialPageRoute(builder: (context) => const CadastroScreen()),
    );

    if (!mounted || novaTarefa == null) {
      return;
    }

    await context.read<TarefaController>().adicionar(novaTarefa);

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

  Future<void> _abrirTelaEdicao(int index, bool concluida) async {
    final tarefaController = context.read<TarefaController>();
    final tarefaSelecionada = concluida
        ? tarefaController.tarefasConcluidas[index]
        : tarefaController.tarefas[index];
    final tarefaEditada = await Navigator.push<AtividadeEstudo>(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroScreen(atividade: tarefaSelecionada),
      ),
    );

    if (!mounted || tarefaEditada == null) {
      return;
    }

    await tarefaController.editar(tarefaEditada);

    _mostrarMensagemSucesso('Atividade atualizada com sucesso!');
  }

  Future<void> _confirmarRemocao(int index, {required bool concluida}) async {
    final tarefaController = context.read<TarefaController>();
    final tarefa = concluida
        ? tarefaController.tarefasConcluidas[index]
        : tarefaController.tarefas[index];
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
      await _removerTarefa(index, concluida: concluida);
    }
  }

  Future<void> _removerTarefa(int index, {required bool concluida}) async {
    final tarefaController = context.read<TarefaController>();
    final tarefaRemovida = concluida
        ? tarefaController.tarefasConcluidas[index]
        : tarefaController.tarefas[index];

    await tarefaController.remover(index, concluida: concluida);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Atividade removida: ${tarefaRemovida.titulo}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _concluirTarefa(int index) async {
    final tarefaController = context.read<TarefaController>();
    final titulo = tarefaController.tarefas[index].titulo;

    await tarefaController.concluir(index);

    if (!mounted) {
      return;
    }

    _mostrarMensagemSucesso('Atividade concluída: $titulo');
  }

  void _sair() {
    context.read<TarefaController>().sair();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
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

  Widget _buildLista(List<AtividadeEstudo> lista, {required bool concluida}) {
    final colorScheme = Theme.of(context).colorScheme;
    final vazioTitulo = concluida
        ? 'Nenhuma atividade concluída.'
        : 'Nenhuma atividade pendente.';
    final vazioIcon = concluida ? Icons.check_circle_outline : Icons.event_note;

    if (lista.isEmpty) {
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
              child: Icon(vazioIcon, size: 34, color: colorScheme.secondary),
            ),
            const SizedBox(height: 16),
            TextoPadrao(
              vazioTitulo,
              fontSize: 16,
              color: const Color(0xFF607D8B),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final tarefa = lista[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TarefaItem(
            atividade: tarefa,
            onEditar: () => _abrirTelaEdicao(index, concluida),
            onAbrirDetalhes: () => _abrirDetalhes(tarefa),
            onRemover: () => _confirmarRemocao(index, concluida: concluida),
            onConcluir: concluida ? null : () => _concluirTarefa(index),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tarefaController = context.watch<TarefaController>();
    final tarefas = tarefaController.tarefas;
    final tarefasConcluidas = tarefaController.tarefasConcluidas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Agenda de Estudos'),
        actions: [
          IconButton(
            key: const Key('botaoLogout'),
            tooltip: 'Sair',
            onPressed: _sair,
            icon: const Icon(Icons.logout),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Ativas'),
            Tab(text: 'Concluídas'),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PainelResumo(
                usuarioLogado: widget.usuarioLogado,
                totalPendentes: tarefas.length,
                totalConcluidas: tarefasConcluidas.length,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextoPadrao(
                      'Minhas atividades',
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
                child: tarefaController.carregando
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildLista(tarefas, concluida: false),
                          _buildLista(tarefasConcluidas, concluida: true),
                        ],
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
  final String usuarioLogado;
  final int totalPendentes;
  final int totalConcluidas;

  const _PainelResumo({
    required this.usuarioLogado,
    required this.totalPendentes,
    required this.totalConcluidas,
  });

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
                TextoPadrao(
                  'Resumo de estudos',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                TextoPadrao(
                  'Usuário logado: $usuarioLogado',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.92),
                ),
                const SizedBox(height: 4),
                TextoPadrao(
                  'Pendentes: $totalPendentes • Concluídas: $totalConcluidas',
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
