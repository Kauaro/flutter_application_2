import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'intro_page.dart';
import 'user_type_page.dart';
import 'pages/qr_scanner_page.dart';
import 'pages/avaliacao_page.dart';
import 'pages/historico_page.dart';
import 'pages/redes_sociais_page.dart';

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
        scaffoldBackgroundColor: const Color(0xFFF3E9F7),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5e17eb)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroPage(),
        '/user-type': (context) => const UserTypePage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/codigo': (context) => const QRScannerPage(),
        '/avaliar': (context) => const AvaliacaoPage(),
        '/redes-sociais': (context) => const RedesSociaisPage(),
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