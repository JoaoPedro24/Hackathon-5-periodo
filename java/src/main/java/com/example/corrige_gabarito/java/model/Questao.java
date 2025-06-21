
package com.example.corrige_gabarito.java.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class Questao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String enunciado;
    private String alternativaCorreta;
    private Double valor;

    @ManyToOne
    @JoinColumn(name = "prova_id")
    private Prova prova;
}
