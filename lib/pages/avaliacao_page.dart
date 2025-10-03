import 'package:flutter/material.dart';
import '../models/avaliacao.dart';
import '../services/avaliacao_service.dart';

class AvaliacaoPage extends StatefulWidget {
  const AvaliacaoPage({super.key});

  @override
  State<AvaliacaoPage> createState() => _AvaliacaoPageState();
}

class _AvaliacaoPageState extends State<AvaliacaoPage> {
  final _formKey = GlobalKey<FormState>();
  final _matriculaController = TextEditingController();
  final _nomeController = TextEditingController();
  final _feedbackController = TextEditingController();
  
  int _nota = 5;
  bool _isLoading = false;
  late Projeto _projeto;

  @override
  void initState() {
    super.initState();
    // O projeto será passado como argumento da rota
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Projeto) {
        _projeto = args;
      } else {
        // Se não houver projeto, redirecionar para home
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  @override
  void dispose() {
    _matriculaController.dispose();
    _nomeController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  String? _validateMatricula(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua matrícula';
    }
    if (value.length < 5) {
      return 'Matrícula deve ter pelo menos 5 dígitos';
    }
    return null;
  }

  String? _validateNome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu nome';
    }
    if (value.length < 3) {
      return 'Nome deve ter pelo menos 3 caracteres';
    }
    return null;
  }

  Future<void> _submitAvaliacao() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final avaliacao = Avaliacao(
        id: AvaliacaoService.gerarId(),
        matricula: _matriculaController.text.trim(),
        nome: _nomeController.text.trim(),
        nota: _nota,
        feedback: _feedbackController.text.trim(),
        projetoId: _projeto.id,
        projetoNome: _projeto.nome,
        dataAvaliacao: DateTime.now(),
      );

      final success = await AvaliacaoService.salvarAvaliacao(avaliacao);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          _showSuccessDialog();
        } else {
          _showErrorDialog('Erro', 'Não foi possível salvar a avaliação. Tente novamente.');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Erro', 'Erro ao salvar avaliação: $e');
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Sucesso!'),
            ],
          ),
          content: const Text('Sua avaliação foi salva com sucesso!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text('Voltar ao Início'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Verificar se o projeto foi carregado
    if (!mounted) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliar Projeto'),
        backgroundColor: const Color(0xFF5e17eb),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informações do projeto
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.school,
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _projeto.nome,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Autor: ${_projeto.autor}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _projeto.descricao,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Título do formulário
              const Text(
                'Formulário de Avaliação',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5e17eb),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Campo Matrícula
              TextFormField(
                controller: _matriculaController,
                keyboardType: TextInputType.number,
                validator: _validateMatricula,
                decoration: InputDecoration(
                  labelText: 'Matrícula *',
                  prefixIcon: const Icon(Icons.badge, color: Color(0xFF5e17eb)),
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
              
              // Campo Nome
              TextFormField(
                controller: _nomeController,
                validator: _validateNome,
                decoration: InputDecoration(
                  labelText: 'Nome Completo *',
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
              
              // Campo Nota
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFF5e17eb)),
                        const SizedBox(width: 8),
                        Text(
                          'Nota: $_nota/10',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: _nota.toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 10,
                      activeColor: const Color(0xFF5e17eb),
                      onChanged: (value) {
                        setState(() {
                          _nota = value.round();
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('0', style: TextStyle(color: Colors.grey)),
                        Text('10', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Campo Feedback
              TextFormField(
                controller: _feedbackController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Feedback (opcional)',
                  prefixIcon: const Icon(Icons.feedback, color: Color(0xFF5e17eb)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF5e17eb), width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  hintText: 'Compartilhe sua opinião sobre o projeto...',
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Botão Enviar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitAvaliacao,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5e17eb),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
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
                          'Enviar Avaliação',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
