import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/avaliacao.dart';

class AvaliacaoService {
  static const String _storageKey = 'avaliacoes';
  
  // Simular projetos disponíveis
  static final List<Projeto> _projetos = [
    Projeto(
      id: 'proj001',
      nome: 'Sistema de Gestão Escolar',
      descricao: 'Aplicativo para gerenciar notas, frequência e comunicação entre escola e pais.',
      autor: 'João Silva',
    ),
    Projeto(
      id: 'proj002',
      nome: 'App de Delivery Sustentável',
      descricao: 'Plataforma que conecta restaurantes com entregadores usando veículos elétricos.',
      autor: 'Maria Santos',
    ),
    Projeto(
      id: 'proj003',
      nome: 'Monitoramento de Saúde IoT',
      descricao: 'Sistema de sensores para monitorar sinais vitais em tempo real.',
      autor: 'Pedro Costa',
    ),
    Projeto(
      id: 'proj004',
      nome: 'Rede Social para Estudantes',
      descricao: 'Plataforma para compartilhamento de conhecimento e colaboração acadêmica.',
      autor: 'Ana Oliveira',
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

  // Calcular média das notas de um projeto
  static Future<double> getMediaNotasProjeto(String projetoId) async {
    final avaliacoes = await getAvaliacoesPorProjeto(projetoId);
    
    if (avaliacoes.isEmpty) return 0.0;
    
    final soma = avaliacoes.fold(0, (sum, a) => sum + a.nota);
    return soma / avaliacoes.length;
  }
}
