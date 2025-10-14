import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'detalhes_avaliacao_page.dart';

class ProjetosAvaliadosPage extends StatefulWidget {
  const ProjetosAvaliadosPage({super.key});

  @override
  State<ProjetosAvaliadosPage> createState() => _ProjetosAvaliadosPageState();
}

class _ProjetosAvaliadosPageState extends State<ProjetosAvaliadosPage> {
  List<Map<String, dynamic>> projetosAvaliados = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarAvaliacoes();
  }

  Future<void> _carregarAvaliacoes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final matricula = prefs.getString('user_matricula');
      
      if (matricula == null) {
        setState(() {
          errorMessage = 'Usuário não logado';
          isLoading = false;
        });
        return;
      }

      final url = Uri.parse('https://productclienthub-ld2x.onrender.com/api/Avaliacao/matricula/$matricula');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          projetosAvaliados = data.map((item) => {
            'nome': item['projetoNome'] ?? 'Projeto sem nome',
            'responsavel': 'Autor não informado',
            'avaliacao': item['nota'] ?? 0,
            'dataAvaliacao': 'Data não informada',
            'tema': 'Geral',
            'feedback': item['descricao'] ?? '',
          }).toList().cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erro ao carregar avaliações';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erro de conexão';
        isLoading = false;
      });
    }
  }



  Widget _buildStarRating(int avaliacao) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Container(
          margin: const EdgeInsets.only(right: 2),
          child: Icon(
            index < avaliacao ? Icons.star : Icons.star_border,
            size: 18,
            color: index < avaliacao ? const Color(0xFF6A1B9A) : const Color(0xFF718096),
          ),
        );
      }),
    );
  }

  Color _getCategoryColor(String tema) {
    switch (tema) {
      case 'Neurodivergente': return const Color(0xFF4285F4);
      case 'Homofobia': return const Color(0xFF34A853);
      case 'Racismo': return const Color(0xFFEA4335);
      case 'Social': return const Color(0xFF9C27B0);
      case 'Cultural': return const Color(0xFFFF9800);
      case 'Musicas': return const Color(0xFF00BCD4);
      default: return const Color(0xFF6A1B9A);
    }
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
                      Navigator.pushReplacementNamed(context, '/home');
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
                      Navigator.pushReplacementNamed(context, '/home');
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
                child: Column(
                  children: [
                    // Card principal
                    Container(
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
                            'Projetos Avaliados',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${projetosAvaliados.length} projetos avaliados',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF718096),
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Conteúdo baseado no estado
                          if (isLoading)
                            const CircularProgressIndicator(color: Color(0xFF6A1B9A))
                          else if (errorMessage != null)
                            Text(
                              errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            )
                          else if (projetosAvaliados.isEmpty)
                            const Text(
                              'Nenhuma avaliação encontrada',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF718096),
                              ),
                            )
                          else
                            // Lista de projetos
                            Column(
                              children: projetosAvaliados.map((projeto) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetalhesAvaliacaoPage(projeto: projeto),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF7FAFC),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(0xFFE2E8F0),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Header do projeto
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    projeto['nome'],
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF2D3748),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Responsável - ${projeto['responsavel']}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF718096),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getCategoryColor(projeto['tema']).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                projeto['tema'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: _getCategoryColor(projeto['tema']),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        
                                        // Avaliação e data
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Estrelas
                                            Row(
                                              children: [
                                                _buildStarRating(projeto['avaliacao']),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '${projeto['avaliacao']}/5',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF6A1B9A),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            
                                            // Data
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                projeto['dataAvaliacao'],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF718096),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
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