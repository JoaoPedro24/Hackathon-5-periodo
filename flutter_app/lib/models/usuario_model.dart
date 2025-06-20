class Usuario {
  final String token;
  final String perfil;

  Usuario({required this.token, required this.perfil});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      token: json['token'],
      perfil: json['perfil'],
    );
  }
}
