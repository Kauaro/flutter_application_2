import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/avaliacao.dart';

class AvaliacaoService {
  static const String _storageKey = 'avaliacoes';
  
  // Projetos mockados com códigos QR
  static final List<Projeto> _projetos = [
    Projeto(
      id: 'TCC001',
      nome: 'Sistema de Gestão Escolar',
      descricao: 'Aplicativo para gerenciar notas, frequência e comunicação entre escola e pais.',
      autor: 'João Silva',
      codigoQR: '00001',
    ),
    Projeto(
      id: 'TCC002',
      nome: 'App de Delivery Sustentável',
      descricao: 'Plataforma que conecta restaurantes com entregadores usando veículos elétricos.',
      autor: 'Maria Santos',
      codigoQR: '00002',
    ),
    Projeto(
      id: 'TCC003',
      nome: 'Monitoramento de Saúde IoT',
      descricao: 'Sistema de sensores para monitorar sinais vitais em tempo real.',
      autor: 'Pedro Costa',
      codigoQR: '00003',
    ),
    Projeto(
      id: 'TCC004',
      nome: 'Rede Social para Estudantes',
      descricao: 'Plataforma para compartilhamento de conhecimento e colaboração acadêmica.',
      autor: 'Ana Oliveira',
      codigoQR: '00004',
    ),
    Projeto(
      id: 'TCC005',
      nome: 'E-commerce Inteligente',
      descricao: 'Sistema de vendas online com IA para recomendações personalizadas.',
      autor: 'Carlos Mendes',
      codigoQR: 'QR_TCC005_ECOMMERCE_IA',
    ),
    Projeto(
      id: 'TCC006',
      nome: 'App de Controle Financeiro',
      descricao: 'Aplicativo para gestão de finanças pessoais com análise de gastos.',
      autor: 'Fernanda Lima',
      codigoQR: 'QR_TCC006_FINANCAS_PESSOAIS',
    ),
    Projeto(
      id: 'TCC007',
      nome: 'Sistema de Biblioteca Digital',
      descricao: 'Plataforma para empréstimo e leitura de livros digitais.',
      autor: 'Roberto Alves',
      codigoQR: 'QR_TCC007_BIBLIOTECA_DIGITAL',
    ),
    Projeto(
      id: 'TCC008',
      nome: 'App de Carona Solidária',
      descricao: 'Sistema para compartilhamento de caronas entre universitários.',
      autor: 'Juliana Rocha',
      codigoQR: 'QR_TCC008_CARONA_SOLIDARIA',
    ),
  ];

  // Obter todos os projetos
  static List<Projeto> getProjetos() {
    return _projetos;
  }

  // Obter projeto por ID
  static Projeto? getProjetoById(String id) {
    try {
      return _projetos.firstWhere((projeto) => projeto.id == id);
    } catch (e) {
      return null;
    }
  }

  // Salvar avaliação
  static Future<bool> salvarAvaliacao(Avaliacao avaliacao) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final avaliacoes = await getAvaliacoes();
      
      // Verificar se já existe uma avaliação para este projeto por esta pessoa
      final index = avaliacoes.indexWhere(
        (a) => a.projetoId == avaliacao.projetoId && a.matricula == avaliacao.matricula
      );
      
      if (index != -1) {
        // Atualizar avaliação existente
        avaliacoes[index] = avaliacao;
      } else {
        // Adicionar nova avaliação
        avaliacoes.add(avaliacao);
      }
      
      final jsonList = avaliacoes.map((a) => a.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
      
      return true;
    } catch (e) {
      // Erro ao salvar avaliação
      return false;
    }
  }

  // Obter todas as avaliações
  static Future<List<Avaliacao>> getAvaliacoes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => Avaliacao.fromJson(json)).toList();
    } catch (e) {
      // Erro ao obter avaliações
      return [];
    }
  }

  // Obter avaliações por matrícula
  static Future<List<Avaliacao>> getAvaliacoesPorMatricula(String matricula) async {
    final avaliacoes = await getAvaliacoes();
    return avaliacoes.where((a) => a.matricula == matricula).toList();
  }

  // Obter avaliações por projeto
  static Future<List<Avaliacao>> getAvaliacoesPorProjeto(String projetoId) async {
    final avaliacoes = await getAvaliacoes();
    return avaliacoes.where((a) => a.projetoId == projetoId).toList();
  }

  // Gerar ID único para avaliação
  static String gerarId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Obter projeto por código QR
  static Projeto? getProjetoPorCodigoQR(String codigoQR) {
    try {
      return _projetos.firstWhere((projeto) => projeto.codigoQR == codigoQR);
    } catch (e) {
      return null;
    }
  }

  // Calcular média das estrelas de um projeto
  static Future<double> getMediaEstrelasProjeto(String projetoId) async {
    final avaliacoes = await getAvaliacoesPorProjeto(projetoId);
    
    if (avaliacoes.isEmpty) return 0.0;
    
    final soma = avaliacoes.fold(0, (sum, a) => sum + a.estrelas);
    return soma / avaliacoes.length;
  }

  /// Busca projeto por código via GET
  /// [codigo] é o código do projeto
  /// Retorna os dados do projeto ou lança uma Exception em caso de erro
  static Future<Map<String, dynamic>> buscarProjetoPorCodigo(String codigo) async {
    final url = Uri.parse('https://productclienthub-ld2x.onrender.com/api/Projeto/codigo/$codigo');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        throw Exception('Projeto não encontrado');
      } else {
        throw Exception('Erro no servidor: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Projeto não encontrado')) {
        rethrow;
      }
      throw Exception('Falha na conexão: Verifique sua internet');
    }
  }

  /// Cria avaliação via POST
  /// [projetoCodigo] é o código do projeto
  /// [dadosAvaliacao] são os dados da avaliação
  /// Retorna os dados da avaliação criada ou lança uma Exception em caso de erro
  static Future<Map<String, dynamic>> criarAvaliacao(String projetoCodigo, Map<String, dynamic> dadosAvaliacao) async {
    final url = Uri.parse('https://productclienthub-ld2x.onrender.com/api/Avaliacao/$projetoCodigo');
    try {
      print('Enviando para: $url');
      print('Dados: ${jsonEncode(dadosAvaliacao)}');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dadosAvaliacao),
      );
      
      print('Status: ${response.statusCode}');
      print('Resposta: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Falha na requisição: $e');
    }
  }
}
