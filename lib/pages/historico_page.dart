import 'package:flutter/material.dart';
import '../models/avaliacao.dart';
import '../services/avaliacao_service.dart';

class HistoricoPage extends StatefulWidget {
  final String matricula;
  final String nome;

  const HistoricoPage({super.key, required this.matricula, required this.nome});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  List<Avaliacao> _avaliacoes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarAvaliacoes();
  }

  Future<void> _carregarAvaliacoes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final avaliacoes = await AvaliacaoService.getAvaliacoesPorMatricula(
        widget.matricula,
      );
      setState(() {
        _avaliacoes = avaliacoes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar avaliações: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  Color _getNotaColor(int estrelas) {
    if (estrelas >= 4) return Colors.green;
    if (estrelas >= 3) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Avaliações'),
        backgroundColor: const Color(0xFF5e17eb),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarAvaliacoes,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF5e17eb)),
            )
          : _avaliacoes.isEmpty
          ? _buildEmptyState()
          : _buildAvaliacoesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Nenhuma avaliação encontrada',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Você ainda não avaliou nenhum projeto.',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(Icons.qr_code),
            label: const Text('Inserir Código'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5e17eb),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvaliacoesList() {
    return Column(
      children: [
        // Header com informações do usuário
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5e17eb), Color(0xFF7c3aed)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Icon(Icons.person, size: 50, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                widget.nome,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Matrícula: ${widget.matricula}',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                'Total de avaliações: ${_avaliacoes.length}',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),

        // Lista de avaliações
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _avaliacoes.length,
            itemBuilder: (context, index) {
              final avaliacao = _avaliacoes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cabeçalho com nome do projeto e nota
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              avaliacao.projetoNome,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5e17eb),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getNotaColor(avaliacao.estrelas),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${avaliacao.estrelas}/5',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Data da avaliação
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Avaliado em: ${_formatarData(avaliacao.dataAvaliacao)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      // Feedback (se houver)
                      if (avaliacao.descricao.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text(
                          'Descrição:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          avaliacao.descricao,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
