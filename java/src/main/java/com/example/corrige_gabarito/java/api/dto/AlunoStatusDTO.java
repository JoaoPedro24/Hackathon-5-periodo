package com.example.corrige_gabarito.java.api.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
public class AlunoStatusDTO {
    private Long alunoId;
    private String nomeAluno;
    private String status;
    private String matricula;
    private BigDecimal nota;  // ✅ nova propriedade
    private Integer acertos;
}
