import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static final Map<String, Map<String, String>> _usuarios = {
    'admin': {
      'senha': '123456',
      'nome': 'Administrador',
    },
    '2023001': {
      'senha': 'senha123',
      'nome': 'João Silva',
    },
    '2023002': {
      'senha': 'senha456',
      'nome': 'Maria Santos',
    },
    'prof001': {
      'senha': 'prof123',
      'nome': 'Dr. Carlos Oliveira',
    },
    'prof002': {
      'senha': 'prof456',
      'nome': 'Dra. Ana Costa',
    },
  };

  static Map<String, String>? autenticar(String matricula, String senha) {
    final usuario = _usuarios[matricula];
    if (usuario != null && usuario['senha'] == senha) {
      return {
        'matricula': matricula,
        'nome': usuario['nome']!,
      };
    }
    return null;
  }

  static List<Map<String, String>> obterTodosUsuarios() {
    return _usuarios.entries.map((entry) => {
      'matricula': entry.key,
      'nome': entry.value['nome']!,
    }).toList();
  }

  /// Consome a API de login via POST
  /// [matricula] e [senha] são os dados de autenticação
  /// Retorna os dados do usuário ou lança uma Exception em caso de erro
  static Future<Map<String, dynamic>> loginApi(String matricula, String senha) async {
    final url = Uri.parse('https://productclienthub-ld2x.onrender.com/api/Aluno/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'matricula': matricula,
          'senha': senha,
        }),
      );
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body) as Map<String, dynamic>;
        
        // Salvar dados do usuário no SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_matricula', userData['matricula'] ?? matricula);
        await prefs.setString('user_nome', userData['nome'] ?? 'Usuário');
        await prefs.setString('user_email', userData['email'] ?? '');
        await prefs.setString('user_curso', userData['curso'] ?? '');
        await prefs.setString('user_periodo', userData['periodo'] ?? '');
        await prefs.setString('user_senha', senha);
        
        return userData;
      } else if (response.statusCode == 401) {
        throw Exception('Credenciais inválidas');
      } else {
        throw Exception('Erro no servidor: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Credenciais inválidas')) {
        rethrow;
      }
      throw Exception('Falha na conexão: Verifique sua internet');
    }
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
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dadosAvaliacao),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Erro ao criar avaliação: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha na requisição: $e');
    }
  }

  /// Consome a API http://localhost:8080/api/Aluno via POST
  /// [data] deve ser um Map com os dados do aluno
  /// Retorna o corpo da resposta ou lança uma Exception em caso de erro
  static Future<Map<String, dynamic>> cadastrarAluno(Map<String, dynamic> data) async {
    final url = Uri.parse('https://productclienthub-ld2x.onrender.com/api/Aluno');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Erro ao cadastrar aluno: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Falha na requisição: $e');
    }
  }
}