import 'dart:convert';
import 'package:http/http.dart' as http;

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

  /// Consome a API http://localhost:8080/api/Aluno via POST
  /// [data] deve ser um Map com os dados do aluno
  /// Retorna o corpo da resposta ou lança uma Exception em caso de erro
  static Future<Map<String, dynamic>> cadastrarAluno(Map<String, dynamic> data) async {
    final url = Uri.parse('http://localhost:8080/api/Aluno');
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