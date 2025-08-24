import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Principal'),
        backgroundColor: const Color(0xFF5e17eb),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            tooltip: 'Fazer Login',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com boas-vindas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5e17eb), Color(0xFF7c3aed)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.home,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Bem-vindo ao App!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Explore as funcionalidades disponíveis',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Seção de funcionalidades
            const Text(
              'Funcionalidades',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5e17eb),
              ),
            ),
            const SizedBox(height: 16),
            
            // Grid de cards de funcionalidades
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildFeatureCard(
                  context,
                  icon: Icons.school,
                  title: 'Cursos',
                  subtitle: 'Acesse seus cursos',
                  onTap: () => _showFeatureDialog(context, 'Cursos'),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.assignment,
                  title: 'Atividades',
                  subtitle: 'Veja suas tarefas',
                  onTap: () => _showFeatureDialog(context, 'Atividades'),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Calendário',
                  subtitle: 'Eventos e datas',
                  onTap: () => _showFeatureDialog(context, 'Calendário'),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.person,
                  title: 'Perfil',
                  subtitle: 'Suas informações',
                  onTap: () => _showFeatureDialog(context, 'Perfil'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Seção de informações
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informações',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5e17eb),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '• Faça login para acessar funcionalidades exclusivas\n'
                    '• Mantenha seus dados atualizados\n'
                    '• Entre em contato em caso de dúvidas',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/login');
        },
        backgroundColor: const Color(0xFF5e17eb),
        foregroundColor: Colors.white,
        child: const Icon(Icons.login),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: const Color(0xFF5e17eb),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5e17eb),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeatureDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(feature),
          content: Text('Funcionalidade $feature em desenvolvimento. Faça login para acessar!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5e17eb),
                foregroundColor: Colors.white,
              ),
              child: const Text('Fazer Login'),
            ),
          ],
        );
      },
    );
  }
}
