import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'widgets/login_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  bool _isLoggedIn = false;

  final List<Map<String, dynamic>> campaigns = [
    {
      'title': 'NO TO RACISM',
      'image': 'imagens/sla1.jpg',
      'backgroundColor': const Color(0xFFF5F5DC), // Bege claro
      'textColor': Colors.black,
      'topText': '',
      'bottomText': '',
    },
    {
      'title': 'STOP HOMOPHOBIA',
      'image': 'imagens/sla3.jpg',
      'backgroundColor': Colors.transparent, // Bandeira do arco-íris
      'textColor': Colors.white,
      'topText': '',
      'bottomText': '',
    },
    {
      'title': 'STOP FEMINICIDE',
      'image': 'imagens/sla4.jpg',
      'backgroundColor': const Color(0xFF8B0000), // Vermelho escuro
      'textColor': Colors.white,
      'topText': '',
      'bottomText': '',
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    // Configurar status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    
    // Iniciar carrossel automático
    _startAutoSlide();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final matricula = prefs.getString('user_matricula');
    setState(() {
      _isLoggedIn = matricula != null;
    });
  }

  void _handleCardTap(String route) {
    if (!_isLoggedIn && (route == '/projetos-avaliados' || route == '/meu-perfil')) {
      Navigator.pushNamed(context, '/login');
    } else {
      Navigator.pushNamed(context, route);
    }
  }
  
  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % campaigns.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9F7),
      body: SafeArea(
        child: Column(
          children: [
            // Header com logo e botão de login
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
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
                  // Botão de login/perfil
                  const LoginButton(),
                ],
              ),
            ),
            
            // Conteúdo principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    
                    // Carrossel de campanhas
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemCount: campaigns.length,
                        itemBuilder: (context, index) {
                          final campaign = campaigns[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: campaign['backgroundColor'],
                              borderRadius: BorderRadius.circular(16),
                              image: campaign['image'] == 'sla1.jpg' 
                                ? const DecorationImage(
                                    image: AssetImage('sla1.jpg'),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            ),
                            child: campaign['image'] == 'sla1.jpg'
                              ? _buildRainbowOverlay(campaign)
                              : _buildCampaignCard(campaign),
                          );
                        },
                      ),
                    ),
                    
                    // Indicadores de página
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        campaigns.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentPage
                                ? const Color(0xFF5e17eb)
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Dashboard Cards
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        _buildModernDashboardCard(
                          'Projetos\nAvaliados',
                          Icons.assignment_turned_in,
                          const LinearGradient(
                            colors: [Color(0xFF9C6ADE), Color(0xFF6A1B9A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          () => _handleCardTap('/projetos-avaliados'),
                        ),
                        _buildModernDashboardCard(
                          'Redes\nSociais',
                          Icons.share,
                          const LinearGradient(
                            colors: [Color(0xFFE4405F), Color(0xFFF56040)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          () => _handleCardTap('/redes-sociais'),
                        ),
                        _buildModernDashboardCard(
                          'Galeria\nda SLA',
                          Icons.photo_library,
                          const LinearGradient(
                            colors: [Color(0xFF4285F4), Color(0xFF34A853)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          () => _handleCardTap('/gallery'),
                        ),
                        _buildModernDashboardCard(
                          'Meu\nPerfil',
                          Icons.person,
                          const LinearGradient(
                            colors: [Color(0xFF9C6ADE), Color(0xFF6A1B9A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          () => _handleCardTap('/meu-perfil'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9C6ADE), Color(0xFF6A1B9A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9C6ADE).withOpacity(0.4),
              spreadRadius: 0,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            if (!_isLoggedIn) {
              Navigator.pushNamed(context, '/login');
            } else {
              Navigator.pushNamed(context, '/codigo');
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.qr_code, size: 30, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCampaignCard(Map<String, dynamic> campaign) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(campaign['image']),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                campaign['topText'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: campaign['textColor'],
                ),
              ),
              Text(
                campaign['bottomText'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: campaign['textColor'],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRainbowOverlay(Map<String, dynamic> campaign) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue,
            Color(0xFF4B0082), // Indigo
            Color(0xFF9400D3), // Violet
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              campaign['topText'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: campaign['textColor'],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF5e17eb),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                campaign['bottomText'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: campaign['textColor'],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernDashboardCard(String title, IconData icon, LinearGradient gradient, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF9C6ADE).withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9C6ADE).withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              spreadRadius: -2,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: gradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return _buildModernDashboardCard(
      title,
      icon,
      LinearGradient(
        colors: [color, color.withOpacity(0.8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onTap,
    );
  }
}
