package com.example.corrige_gabarito.java.api.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;

@Builder
@Data
public class ProvaDto {
    private Long id;
    private String nome;
    private BigDecimal valorTotal;
    private String disciplina;
    private String turma;
    private Integer totalAlunos;
    private Integer totalAlunosCorrigidos;
}
