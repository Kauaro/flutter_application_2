import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '9:41',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5e17eb),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Título principal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Row(
                children: [
                  Text(
                    'Projetos',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5e17eb),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Cards de projetos (scrolláveis)
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _buildProjectCard(index);
                },
              ),
            ),

            // Indicadores de página
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == 0
                        ? const Color(0xFF5e17eb)
                        : Colors.grey[300],
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),

            // Segunda seção de projetos
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Row(
                children: [
                  Text(
                    'Projetos',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5e17eb),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Descrição dos projetos
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Sistema completo para avaliação de projetos de TCC. Escaneie códigos ou faça login para acessar funcionalidades exclusivas e gerenciar suas avaliações.',
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
              ),
            ),

            const Spacer(),

            // Botão de ação principal
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/qr-scanner');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5e17eb),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.qr_code,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Inserir Código do Projeto',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Barra de navegação inferior
            Container(height: 1, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(int index) {
    final projects = [
      {
        'title': 'Sistema de Gestão Escolar',
        'subtitle': 'Aplicativo para gerenciar notas e frequência',
        'color': const Color(0xFFF5F5DC), // Bege claro
        'textColor': Colors.black,
        'icon': Icons.school,
      },
      {
        'title': 'App Delivery Sustentável',
        'subtitle': 'Plataforma com veículos elétricos',
        'color': const Color(0xFFE8F5E8), // Verde claro
        'textColor': Colors.black,
        'icon': Icons.delivery_dining,
      },
      {
        'title': 'Monitoramento Saúde IoT',
        'subtitle': 'Sensores para sinais vitais em tempo real',
        'color': const Color(0xFFE3F2FD), // Azul claro
        'textColor': Colors.black,
        'icon': Icons.monitor_heart,
      },
      {
        'title': 'Rede Social Estudantes',
        'subtitle': 'Compartilhamento de conhecimento acadêmico',
        'color': const Color(0xFFF3E5F5), // Roxo claro
        'textColor': Colors.black,
        'icon': Icons.people,
      },
    ];

    final project = projects[index];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: project['color'] as Color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF5e17eb).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  project['icon'] as IconData,
                  color: const Color(0xFF5e17eb),
                  size: 24,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF5e17eb),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'TCC',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            project['title'] as String,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: project['textColor'] as Color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            project['subtitle'] as String,
            style: TextStyle(
              fontSize: 14,
              color: (project['textColor'] as Color).withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
