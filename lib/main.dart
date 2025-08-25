import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'pages/qr_scanner_page.dart';
import 'pages/avaliacao_page.dart';
import 'pages/historico_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema de Avaliação TCC',
      theme: ThemeData(
        primaryColor: const Color(0xFF5e17eb),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5e17eb)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/qr-scanner': (context) => const QRScannerPage(),
        '/avaliar': (context) => const AvaliacaoPage(),
        '/historico': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          if (args != null) {
            return HistoricoPage(
              matricula: args['matricula'] ?? '',
              nome: args['nome'] ?? 'Usuário',
            );
          }
          return const HomePage();
        },
      },
    );
  }
}