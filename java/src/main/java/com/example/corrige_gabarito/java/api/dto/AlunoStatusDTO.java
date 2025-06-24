package com.example.corrige_gabarito.java.api.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class AlunoStatusDTO {
    private Long alunoId;
    private String nomeAluno;
    private String status;
    private String matricula;
// "CORRIGIDO" ou "PENDENTE"
}
