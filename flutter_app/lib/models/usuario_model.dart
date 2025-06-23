class Usuario {
  final String token;
  final String login;
  final String nome;
  final String role;

  Usuario({required this.token, required this.login,required this.nome, required this.role});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      token: json['token'] ?? '',
      login: json['login'] ?? '',
      nome: json['nome'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
