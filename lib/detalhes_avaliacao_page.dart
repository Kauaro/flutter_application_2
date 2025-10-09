import 'package:flutter/material.dart';

class DetalhesAvaliacaoPage extends StatelessWidget {
  final Map<String, dynamic> projeto;
  const DetalhesAvaliacaoPage({super.key, required this.projeto});

  Widget _buildStarRating(int avaliacao) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < avaliacao ? Icons.star : Icons.star_border,
          size: 22,
          color: index < avaliacao ? const Color(0xFF6A1B9A) : const Color(0xFF718096),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header moderno
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'imagens/LOGO.png',
                        color: const Color(0xFF6A1B9A),
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Botão Voltar
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C6ADE),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Voltar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Conteúdo principal
              Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6A1B9A).withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ícone e título
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9C6ADE), Color(0xFF6A1B9A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF9C6ADE).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.assignment_turned_in_outlined,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Título
                      const Text(
                        'Detalhes da Avaliação',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        projeto['nome'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A1B9A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Responsável: ${projeto['responsavel']}',
                        style: const TextStyle(fontSize: 18, color: Color(0xFF718096)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tema: ${projeto['tema']}',
                        style: const TextStyle(fontSize: 18, color: Color(0xFF6A1B9A)),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildStarRating(projeto['avaliacao']),
                          const SizedBox(width: 8),
                          Text(
                            '${projeto['avaliacao']}/5',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6A1B9A)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Data da avaliação: ${projeto['dataAvaliacao']}',
                        style: const TextStyle(fontSize: 16, color: Color(0xFF718096)),
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
