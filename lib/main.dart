import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'avaliacao_page.dart';
import 'intro_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App TCC',
      theme: ThemeData(
        primaryColor: const Color(0xFF5e17eb),
        scaffoldBackgroundColor: const Color(0xFFF3E9F7),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/avaliacao': (context) => const AvaliacaoPage(),
      },
    );
  }
}
