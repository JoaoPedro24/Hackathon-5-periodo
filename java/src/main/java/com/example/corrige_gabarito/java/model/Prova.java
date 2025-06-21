package com.example.corrige_gabarito.java.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Prova {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nome;

    private LocalDate dataAplicacao;

    @Column(nullable = false)
    private BigDecimal valorTotal;

    @ManyToOne(optional = false)
    private Disciplina disciplina;

    @ManyToOne(optional = false)
    private Turma turma;

    @ManyToOne(optional = false)
    private Usuario professor;

    @OneToMany(mappedBy = "prova", cascade = CascadeType.ALL, orphanRemoval = true)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private List<Questao> questoes = new ArrayList<>();

    /**
     * Helper: Garante que as questões tenham referência para esta prova
     */
    public void adicionarQuestoes(List<Questao> questoes) {
        this.questoes = questoes;
        if (questoes != null) {
            questoes.forEach(q -> q.setProva(this));
        }
    }
}
