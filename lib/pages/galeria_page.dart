import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GaleriaPage extends StatelessWidget {
  const GaleriaPage({super.key});

  final List<Map<String, String>> _imagens = const [
    {
      'titulo': 'Laboratório de Informática',
      'descricao': 'Ambiente moderno para desenvolvimento',
      'imagem': 'imagens/lab_info.jpg',
    },
    {
      'titulo': 'Sala de Aula',
      'descricao': 'Espaços equipados para aprendizado',
      'imagem': 'imagens/sala_aula.jpg',
    },
    {
      'titulo': 'Biblioteca',
      'descricao': 'Acervo técnico e científico',
      'imagem': 'imagens/biblioteca.jpg',
    },
    {
      'titulo': 'Pátio Central',
      'descricao': 'Área de convivência dos estudantes',
      'imagem': 'imagens/patio.jpg',
    },
    {
      'titulo': 'Auditório',
      'descricao': 'Espaço para eventos e apresentações',
      'imagem': 'imagens/auditorio.jpg',
    },
    {
      'titulo': 'Quadra Esportiva',
      'descricao': 'Atividades físicas e recreativas',
      'imagem': 'imagens/quadra.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9F7),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/'),
                    child: Image.asset(
                      'imagens/LOGO.png',
                      color: const Color(0xFF6A1B9A),
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/home'),
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



            // Conteúdo com scroll
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Título
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library,
                            size: 60,
                            color: const Color(0xFF6A1B9A),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Projetos e Espaços',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF9C6ADE),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Conheça nossos projetos anteriores',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Grid de imagens
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildImageCard(_imagens[index], context),
                        childCount: _imagens.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(Map<String, String> item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showImageDialog(context, item);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF9C6ADE).withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9C6ADE).withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF9C6ADE).withOpacity(0.3),
                      const Color(0xFF6A1B9A).withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.image,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['titulo']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['descricao']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, Map<String, String> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF9C6ADE).withOpacity(0.3),
                        const Color(0xFF6A1B9A).withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        item['titulo']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['descricao']!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9C6ADE),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Fechar',
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
              ],
            ),
          ),
        );
      },
    );
  }
}