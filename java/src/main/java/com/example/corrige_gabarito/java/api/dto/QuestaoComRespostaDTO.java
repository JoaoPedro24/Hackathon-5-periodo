package com.example.corrige_gabarito.java.api.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class QuestaoComRespostaDTO {
    private Long questaoId;
    private String enunciado;
    private String tipo;
    private Double valor;
}
