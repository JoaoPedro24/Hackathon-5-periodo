package com.example.corrige_gabarito.java.dto;

import com.example.corrige_gabarito.java.model.Disciplina;
import com.example.corrige_gabarito.java.model.Turma;
import lombok.Data;

import java.time.LocalDate;

@Data
public class ProvaAluno {
    private Long id;
    private String nome;
    private LocalDate data;
    private Disciplina disciplina;
    private Turma turma;
    private Double resultado;   // Nota do aluno
    private Double notaMaxima;  // Nota máxima da prova
}
