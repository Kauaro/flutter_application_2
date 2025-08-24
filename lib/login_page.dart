import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _rmController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rmController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  String? _validateRM(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu RM';
    }
    if (value.length < 5) {
      return 'RM deve ter pelo menos 5 dígitos';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'RM deve conter apenas números';
    }
    return null;
  }

  String? _validateSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua senha';
    }
    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
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

    // Simular processo de login
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navegar para a próxima tela
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login realizado com sucesso!'),
          backgroundColor: Color(0xFF5e17eb),
        ),
      );
      
      // Navegar para a HomePage
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Ícone
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5e17eb).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 50,
                      color: Color(0xFF5e17eb),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Título
                  const Text(
                    "Bem-vindo!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5e17eb),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Faça login para continuar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Campo RM
                  TextFormField(
                    controller: _rmController,
                    keyboardType: TextInputType.number,
                    validator: _validateRM,
                    decoration: InputDecoration(
                      labelText: "RM",
                      prefixIcon: const Icon(Icons.person, color: Color(0xFF5e17eb)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF5e17eb), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Campo Senha
                  TextFormField(
                    controller: _senhaController,
                    obscureText: _obscurePassword,
                    validator: _validateSenha,
                    decoration: InputDecoration(
                      labelText: "Senha",
                      prefixIcon: const Icon(Icons.lock, color: Color(0xFF5e17eb)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF5e17eb), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Botão de Login
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5e17eb),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              "Entrar",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Link "Esqueci minha senha"
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Funcionalidade em desenvolvimento'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                    child: const Text(
                      "Esqueci minha senha",
                      style: TextStyle(
                        color: Color(0xFF5e17eb),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
