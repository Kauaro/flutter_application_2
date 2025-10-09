import 'package:flutter/material.dart';
import '../models/avaliacao.dart';
import '../services/avaliacao_service.dart';

class AvaliacaoPage extends StatefulWidget {
  final String? codigoQR;
  
  const AvaliacaoPage({super.key, this.codigoQR});

  @override
  State<AvaliacaoPage> createState() => _AvaliacaoPageState();
}

class _AvaliacaoPageState extends State<AvaliacaoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _matriculaController = TextEditingController();
  final _descricaoController = TextEditingController();
  int _estrelas = 0;
  bool _isLoading = false;
  Projeto? _projeto;

  @override
  void initState() {
    super.initState();
    if (widget.codigoQR != null) {
      _projeto = AvaliacaoService.getProjetoPorCodigoQR(widget.codigoQR!);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _matriculaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  String? _validateNome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu nome';
    }
    if (value.length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  String? _validateMatricula(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua matrícula';
    }
    if (value.length < 5) {
      return 'Matrícula deve ter pelo menos 5 caracteres';
    }
    return null;
  }

  String? _validateDescricao(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira uma descrição';
    }
    if (value.length < 5) {
      return 'Descrição deve ter pelo menos 5 caracteres';
    }
    return null;
  }

  Future<void> _handleAvaliacao() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_estrelas == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, selecione uma avaliação com as estrelas'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (_projeto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Projeto não encontrado'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final avaliacao = Avaliacao(
        id: AvaliacaoService.gerarId(),
        matricula: _matriculaController.text,
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        estrelas: _estrelas,
        projetoId: _projeto!.id,
        projetoNome: _projeto!.nome,
        dataAvaliacao: DateTime.now(),
      );

      final sucesso = await AvaliacaoService.salvarAvaliacao(avaliacao);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (sucesso) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Avaliação enviada com sucesso!'),
              backgroundColor: const Color(0xFF6A1B9A),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Erro ao salvar avaliação'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao processar avaliação'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _estrelas = index + 1;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              index < _estrelas ? Icons.star : Icons.star_border,
              size: 40,
              color: index < _estrelas ? const Color(0xFF9C6ADE) : Colors.grey[400],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
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
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF9C6ADE),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF9C6ADE),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header moderno
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
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // Card de avaliação
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6A1B9A).withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Ícone
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF9C6ADE), Color(0xFF6A1B9A)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF9C6ADE).withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.rate_review_outlined,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Título
                          const Text(
                            'Avaliação',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          if (_projeto != null) ...[
                            Text(
                              _projeto!.nome,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6A1B9A),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Responsavel: ${_projeto!.autor}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF718096),
                              ),
                            ),
                          ] else ...[
                            const Text(
                              'Avalie este projeto',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF718096),
                              ),
                            ),
                          ],
                          
                          const SizedBox(height: 32),
                          
                          // Formulário
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Campo Nome
                                _buildModernTextField(
                                  controller: _nomeController,
                                  label: 'Nome Completo',
                                  validator: _validateNome,
                                  icon: Icons.person_outline,
                                ),
                                const SizedBox(height: 20),
                                
                                // Campo Matrícula
                                _buildModernTextField(
                                  controller: _matriculaController,
                                  label: 'Matrícula',
                                  validator: _validateMatricula,
                                  icon: Icons.badge_outlined,
                                ),
                                const SizedBox(height: 20),
                                
                                // Campo Descrição
                                _buildModernTextField(
                                  controller: _descricaoController,
                                  label: 'Comentários sobre o projeto',
                                  validator: _validateDescricao,
                                  icon: Icons.comment_outlined,
                                  maxLines: 4,
                                ),
                                const SizedBox(height: 32),
                                
                                // Avaliação com estrelas
                                Column(
                                  children: [
                                    
                                    const SizedBox(height: 16),
                                    _buildStarRating(),
                                    if (_estrelas > 0)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          '$_estrelas estrela${_estrelas > 1 ? 's' : ''}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF6A1B9A),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                
                                // Botão de enviar
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleAvaliacao,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF9C6ADE), Color(0xFF6A1B9A)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: _isLoading
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Text(
                                                'Enviar Avaliação',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}