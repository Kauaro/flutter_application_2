import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.login, color: Color(0xFF5e17eb)),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Carrossel
          SizedBox(
            height: 200,
            child: PageView(
              children: [
                Image.network('https://via.placeholder.com/350x150?text=Não+ao+Racismo', fit: BoxFit.cover),
                Image.network('https://via.placeholder.com/350x150?text=Não+à+Homofobia', fit: BoxFit.cover),
                Image.network('https://via.placeholder.com/350x150?text=Não+ao+Feminicídio', fit: BoxFit.cover),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Bem-vindo ao App",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF5e17eb)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5e17eb),
        onPressed: () {},
        child: const Icon(Icons.qr_code, size: 26, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
