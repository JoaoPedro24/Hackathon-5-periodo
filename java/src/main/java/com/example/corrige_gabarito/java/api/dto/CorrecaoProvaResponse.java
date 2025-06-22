package com.example.corrige_gabarito.java.api.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class CorrecaoProvaResponse {
    private int totalAcertos;
    private double pontuacaoTotal;
}
