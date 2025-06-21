class Usuario {
  final String token;
  final String username;

  Usuario({required this.token, required this.username});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      token: json['token'],
      username: json['username'],
    );
  }
}
