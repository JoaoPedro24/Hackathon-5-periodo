class Questao {
  final int numero;
  final String tipo;
  final double valor;
  final String? respostaCorreta; // Para múltipla escolha

  Questao({
    required this.numero,
    required this.tipo,
    required this.valor,
    this.respostaCorreta,
  });

  factory Questao.fromJson(Map<String, dynamic> json) {
    return Questao(
      numero: json['questao_numero'] as int,
      tipo: json['tipo'] as String,
      valor: (json['valor'] as num).toDouble(),
      respostaCorreta: json['resposta_correta'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questao_numero': numero,
      'tipo': tipo,
      'valor': valor,
      'resposta_correta': respostaCorreta,
    };
  }

  bool get isMultiplaEscolha => tipo == 'Múltipla Escolha';
  bool get isDissertativa => tipo == 'Dissertativa';
}

class Gabarito {
  final int id;
  final int provaId;
  final List<Questao> questoes;

  Gabarito({
    required this.id,
    required this.provaId,
    required this.questoes,
  });

  factory Gabarito.fromJson(Map<String, dynamic> json) {
    return Gabarito(
      id: json['id'] as int,
      provaId: json['provaId'] as int,
      questoes: (json['questoes'] as List<dynamic>)
          .map((q) => Questao.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provaId': provaId,
      'questoes': questoes.map((q) => q.toJson()).toList(),
    };
  }

  double get valorTotal => questoes.fold(0.0, (sum, q) => sum + q.valor);
  
  List<Questao> get questoesMultiplas => 
      questoes.where((q) => q.isMultiplaEscolha).toList();
  
  List<Questao> get questoesDissertativas => 
      questoes.where((q) => q.isDissertativa).toList();
}

class CorrecaoGabarito {
  final int id;
  final int alunoId;
  final int provaId;
  final Map<int, String?> respostasMultiplas;
  final Map<int, double?> respostasDissertativas;
  final double notaTotal;
  final DateTime dataCorrecao;

  CorrecaoGabarito({
    required this.id,
    required this.alunoId,
    required this.provaId,
    required this.respostasMultiplas,
    required this.respostasDissertativas,
    required this.notaTotal,
    required this.dataCorrecao,
  });

  factory CorrecaoGabarito.fromJson(Map<String, dynamic> json) {
    return CorrecaoGabarito(
      id: json['id'] as int,
      alunoId: json['alunoId'] as int,
      provaId: json['provaId'] as int,
      respostasMultiplas: Map<int, String?>.from(
        (json['respostasMultiplas'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(int.parse(key), value as String?),
        ),
      ),
      respostasDissertativas: Map<int, double?>.from(
        (json['respostasDissertativas'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(int.parse(key), value?.toDouble()),
        ),
      ),
      notaTotal: (json['notaTotal'] as num).toDouble(),
      dataCorrecao: DateTime.parse(json['dataCorrecao'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alunoId': alunoId,
      'provaId': provaId,
      'respostasMultiplas': respostasMultiplas.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
      'respostasDissertativas': respostasDissertativas.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
      'notaTotal': notaTotal,
      'dataCorrecao': dataCorrecao.toIso8601String(),
    };
  }
}

class AlunoGabarito {
  final int id;
  final String codigo;
  final String nome;
  final bool jaCorrigido;
  final double? nota;
  final DateTime? dataCorrecao;

  AlunoGabarito({
    required this.id,
    required this.codigo,
    required this.nome,
    required this.jaCorrigido,
    this.nota,
    this.dataCorrecao,
  });

  factory AlunoGabarito.fromJson(Map<String, dynamic> json) {
    return AlunoGabarito(
      id: json['id'] as int,
      codigo: json['codigo'] as String,
      nome: json['nome'] as String,
      jaCorrigido: json['jaCorrigido'] as bool? ?? false,
      nota: json['nota']?.toDouble(),
      dataCorrecao: json['dataCorrecao'] != null 
          ? DateTime.parse(json['dataCorrecao'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'nome': nome,
      'jaCorrigido': jaCorrigido,
      'nota': nota,
      'dataCorrecao': dataCorrecao?.toIso8601String(),
    };
  }
}

