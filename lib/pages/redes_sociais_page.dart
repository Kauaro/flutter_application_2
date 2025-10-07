import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RedesSociaisPage extends StatelessWidget {
  const RedesSociaisPage({super.key});

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
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9C6ADE), Color(0xFF6A1B9A)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9C6ADE).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
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
            
            // Título
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9C6ADE), Color(0xFF6A1B9A)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9C6ADE).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.connect_without_contact,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Conecte-se Conosco',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9C6ADE),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Siga nossas redes e visite nossa escola',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Cards
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildCard(
                      icon: Icons.camera_alt,
                      title: 'Instagram',
                      subtitle: '@sla_belval1',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE4405F), Color(0xFFF56040)],
                      ),
                      onTap: () => HapticFeedback.lightImpact(),
                    ),
                    _buildCard(
                      icon: Icons.school,
                      title: 'Site da Escola',
                      subtitle: 'www.fieb.edu.br',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9C6ADE), Color(0xFF6A1B9A)],
                      ),
                      onTap: () => HapticFeedback.lightImpact(),
                    ),
                    _buildCard(
                      icon: Icons.location_on,
                      title: 'Localização',
                      subtitle: 'Bela Vista, Salvador - BA',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4285F4), Color(0xFF34A853)],
                      ),
                      onTap: () => HapticFeedback.lightImpact(),
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

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF9C6ADE).withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9C6ADE).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: gradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF9C6ADE).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF9C6ADE),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}