package com.example.corrige_gabarito.java.model;

public enum Role {
    ADMIN("Administrador"),
    PROFESSOR("Professor"),
    ALUNO("Aluno");

    private final String descricao;

    Role(String descricao) {
        this.descricao = descricao;
    }

    public String getDescricao() {
        return descricao;
    }
}