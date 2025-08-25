import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> campaigns = [
    {
      'title': 'NO TO RACISM',
      'image': 'nao_racismo.jpg',
      'backgroundColor': const Color(0xFFF5F5DC), // Bege claro
      'textColor': Colors.black,
      'topText': 'NO',
      'bottomText': 'TO RACISM',
    },
    {
      'title': 'STOP HOMOPHOBIA',
      'image': 'nao_homofobia.jpg',
      'backgroundColor': Colors.transparent, // Bandeira do arco-íris
      'textColor': Colors.white,
      'topText': 'STOP',
      'bottomText': 'HOMOPHOBIA',
    },
    {
      'title': 'STOP FEMINICIDE',
      'image': 'nao_femicidio.webp',
      'backgroundColor': const Color(0xFF8B0000), // Vermelho escuro
      'textColor': Colors.white,
      'topText': 'STOP',
      'bottomText': 'FEMINICIDE',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Configurar status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar personalizada
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5e17eb),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Conteúdo principal
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título "Campaigns"
                    const Text(
                      'Campaigns',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5e17eb),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
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
                              image: campaign['image'] == 'nao_homofobia.jpg' 
                                ? const DecorationImage(
                                    image: AssetImage('nao_homofobia.jpg'),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            ),
                            child: campaign['image'] == 'nao_homofobia.jpg'
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
                    
                    const SizedBox(height: 32),
                    
                    // Seção de texto
                    const Text(
                      'Campaigns',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5e17eb),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'O Projeto SLA é uma feira cultural que promove a reflexão e o enfrentamento de questões sociais como racismo, homofobia, xenofobia e preconceito religioso. Com uma abordagem prática e educativa, os alunos se tornam protagonistas, desenvolvendo projetos interdisciplinares que transformam as salas de aula em espaços de conscientização.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton.extended(
          onPressed: () {
            // Ação do botão QR code
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Funcionalidade QR Code em desenvolvimento'),
                backgroundColor: Color(0xFF5e17eb),
              ),
            );
          },
          backgroundColor: const Color(0xFF5e17eb),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.qr_code),
          label: const Text('QR Code'),
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
              Colors.black.withValues(alpha: 0.3),
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
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: campaign['textColor'],
                ),
              ),
              Text(
                campaign['bottomText'],
                style: TextStyle(
                  fontSize: 18,
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
                fontSize: 32,
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
                  fontSize: 18,
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
}
