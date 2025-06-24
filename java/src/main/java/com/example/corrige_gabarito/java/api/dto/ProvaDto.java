package com.example.corrige_gabarito.java.api.dto;

import lombok.*;

import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProvaDto {

    private Long id;
    private String nome;
    private BigDecimal valorTotal;
    private String disciplina;
    private String turma;
    private Integer totalAlunos;
    private Integer totalAlunosCorrigidos;
}
