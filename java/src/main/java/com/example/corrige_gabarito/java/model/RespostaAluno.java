package com.example.corrige_gabarito.java.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "respostas_aluno")
@Data
public class RespostaAluno {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "aluno_id", nullable = false)
    private Long alunoId;

    @Column(name = "prova_id", nullable = false)
    private Long provaId;

    @Column(nullable = false)
    private int enunciado;

    @Column(nullable = false)
    private String resposta;
}
