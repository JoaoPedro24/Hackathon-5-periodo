package com.example.corrige_gabarito.java.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import jakarta.persistence.CascadeType;

import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

@Entity
@Table(name = "alunos")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Aluno {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToMany(mappedBy = "alunos")
    private Set<Turma> turmas = new HashSet<>();

    // Para garantir que Set funciona corretamente, implementamos equals e hashCode baseado no ID

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Aluno)) return false;
        Aluno aluno = (Aluno) o;
        return id != null && id.equals(aluno.getId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    private String matricula;
}
