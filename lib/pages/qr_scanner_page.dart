import 'package:flutter/material.dart';
import '../services/avaliacao_service.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final _qrCodeController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _qrCodeController.dispose();
    super.dispose();
  }

  Future<void> _processQRCode() async {
    if (_qrCodeController.text.trim().isEmpty) {
      _showErrorDialog(
        'Erro',
        'Por favor, insira um código de projeto válido.',
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Simular processamento
      await Future.delayed(const Duration(milliseconds: 500));

      // Verificar se o QR code contém um ID de projeto válido
      final projeto = AvaliacaoService.getProjetoById(
        _qrCodeController.text.trim(),
      );

      if (projeto != null) {
        // Navegar para a página de avaliação
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            '/avaliar',
            arguments: projeto,
          );
        }
      } else {
        // QR code inválido
        if (mounted) {
          _showErrorDialog(
            'QR Code inválido',
            'O código inserido não corresponde a um projeto válido.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Erro', 'Erro ao processar o código: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Código do Projeto'),
        backgroundColor: const Color(0xFF5e17eb),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ícone e título
            const Icon(Icons.qr_code, size: 100, color: Color(0xFF5e17eb)),
            const SizedBox(height: 24),
            const Text(
              'Inserir Código do Projeto',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5e17eb),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Digite o código do projeto que você deseja avaliar',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Campo de entrada
            TextFormField(
              controller: _qrCodeController,
              decoration: InputDecoration(
                labelText: 'Código do Projeto',
                hintText: 'Ex: proj001, proj002, etc.',
                prefixIcon: const Icon(Icons.qr_code, color: Color(0xFF5e17eb)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF5e17eb),
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),

            const SizedBox(height: 24),

            // Botão de processar
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processQRCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5e17eb),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Processar Código',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 32),

            // Projetos disponíveis
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Projetos Disponíveis para Teste:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5e17eb),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...AvaliacaoService.getProjetos().map(
                    (projeto) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: Color(0xFF5e17eb),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${projeto.id}: ${projeto.nome}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
