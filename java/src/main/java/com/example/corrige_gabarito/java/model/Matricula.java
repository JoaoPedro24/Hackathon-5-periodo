package com.example.corrige_gabarito.java.model;

public class Matricula {
    private Long id;
    private Long turmaId;
    private Long alunoId;
    private Long disciplinaId;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getTurmaId() { return turmaId; }
    public void setTurmaId(Long turmaId) { this.turmaId = turmaId; }

    public Long getAlunoId() { return alunoId; }
    public void setAlunoId(Long alunoId) { this.alunoId = alunoId; }

    public Long getDisciplinaId() { return disciplinaId; }
    public void setDisciplinaId(Long disciplinaId) { this.disciplinaId = disciplinaId; }
}
