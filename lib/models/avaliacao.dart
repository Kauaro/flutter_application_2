class Avaliacao {
  final String id;
  final String matricula;
  final String nome;
  final int nota;
  final String feedback;
  final String projetoId;
  final String projetoNome;
  final DateTime dataAvaliacao;

  Avaliacao({
    required this.id,
    required this.matricula,
    required this.nome,
    required this.nota,
    required this.feedback,
    required this.projetoId,
    required this.projetoNome,
    required this.dataAvaliacao,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matricula': matricula,
      'nome': nome,
      'nota': nota,
      'feedback': feedback,
      'projetoId': projetoId,
      'projetoNome': projetoNome,
      'dataAvaliacao': dataAvaliacao.toIso8601String(),
    };
  }

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      id: json['id'],
      matricula: json['matricula'],
      nome: json['nome'],
      nota: json['nota'],
      feedback: json['feedback'],
      projetoId: json['projetoId'],
      projetoNome: json['projetoNome'],
      dataAvaliacao: DateTime.parse(json['dataAvaliacao']),
    );
  }
}

class Projeto {
  final String id;
  final String nome;
  final String descricao;
  final String autor;

  Projeto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.autor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'autor': autor,
    };
  }

  factory Projeto.fromJson(Map<String, dynamic> json) {
    return Projeto(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      autor: json['autor'],
    );
  }
}
