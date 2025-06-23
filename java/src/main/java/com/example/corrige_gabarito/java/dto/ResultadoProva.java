package com.example.corrige_gabarito.java.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ResultadoProva {
    private String alunoNome;
    private Double nota;
    private Integer quantidadeCertas;


}
