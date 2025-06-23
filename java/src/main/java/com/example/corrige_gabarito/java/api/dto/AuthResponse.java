package com.example.corrige_gabarito.java.api.dto;

public class AuthResponse {
    private String token;
    private String login;
    private String nome;
    private String role;




    public AuthResponse(String token, String login, String nome, String role) {
        this.token = token;
        this.login = login;
        this.nome = nome;
        this.role = role;
    }

    public String getToken() {
        return token;
    }

    public String getLogin() {
        return login;
    }
    public String getNome() {
        return nome;
    }
    public String getRole() {
        return role;
    }


}
