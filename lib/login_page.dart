import 'package:flutter/material.dart';
import 'services/login_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _matriculaController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _matriculaController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  String? _validateMatricula(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua matrícula';
    }
    return null;
  }

  String? _validateSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua senha';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final usuario = LoginService.autenticar(
      _matriculaController.text,
      _senhaController.text,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (usuario != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bem-vindo, ${usuario['nome']}!'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
        
        Navigator.pushReplacementNamed(
          context,
          '/historico',
          arguments: {
            'matricula': usuario['matricula'],
            'nome': usuario['nome'],
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Matrícula ou senha incorretos'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9F7),
      body: SafeArea(
        child: Column(
          children: [
            // Header com logo e botão voltar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  // Botão Voltar
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
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
            
            // Conteúdo principal
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ícone e título
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9C6ADE), Color(0xFF6A1B9A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9C6ADE).withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Bem-vindo de volta!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9C6ADE),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Faça login para continuar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                  
                          // Campo Matricula
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF9C6ADE).withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _matriculaController,
                              keyboardType: TextInputType.text,
                              validator: _validateMatricula,
                              style: const TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                labelText: 'Matrícula',
                                labelStyle: const TextStyle(
                                  color: Color(0xFF9C6ADE),
                                  fontWeight: FontWeight.w500,
                                ),
                                prefixIcon: const Icon(
                                  Icons.badge,
                                  color: Color(0xFF9C6ADE),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF9C6ADE),
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Colors.red),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                  
                          // Campo Senha
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF9C6ADE).withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _senhaController,
                              obscureText: _obscurePassword,
                              validator: _validateSenha,
                              style: const TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                labelStyle: const TextStyle(
                                  color: Color(0xFF9C6ADE),
                                  fontWeight: FontWeight.w500,
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color(0xFF9C6ADE),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color(0xFF9C6ADE),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF9C6ADE),
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Colors.red),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                  
                          // Botão Entrar
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF9C6ADE), Color(0xFF6A1B9A)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
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
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: _isLoading ? null : _handleLogin,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Botão Cadastre-se
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF9C6ADE),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF9C6ADE).withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: const Text(
                                'Cadastre-se',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9C6ADE),
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
            ),
          ],
        ),
      ),
    );
  }
}
