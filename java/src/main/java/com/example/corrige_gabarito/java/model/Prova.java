package com.example.corrige_gabarito.java.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
public class Prova {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;
    private LocalDate dataAplicacao;
    private Double valorTotal;

    @ManyToOne
    private Disciplina disciplina;

    @ManyToOne
    private Turma turma;

    @ManyToOne
    private Usuario professor;

    @OneToMany(mappedBy = "prova", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Questao> questoes = new ArrayList<>();
}
