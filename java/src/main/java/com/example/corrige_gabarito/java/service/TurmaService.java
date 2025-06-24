package com.example.corrige_gabarito.java.service;

import com.example.corrige_gabarito.java.model.Aluno;
import com.example.corrige_gabarito.java.model.Turma;
import com.example.corrige_gabarito.java.repository.AlunoRepository;
import com.example.corrige_gabarito.java.repository.TurmaRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class TurmaService {

    private final TurmaRepository turmaRepository;
    private final AlunoRepository alunoRepository;

    public List<Turma> listarTodas() {
        return turmaRepository.findAll();
    }

    @Transactional
    public Turma salvarTurmaComAlunos(Turma turma, List<Long> idsAlunos) {
        Set<Aluno> alunos = new HashSet<>(alunoRepository.findAllById(idsAlunos));
        turma.setAlunos(alunos);
        
        for (Aluno aluno : alunos) {
            aluno.getTurmas().add(turma);
        }

        return turmaRepository.save(turma);
    }

    public Turma buscarPorId(Long id) {
        return turmaRepository.findById(id).orElse(null);
    }

    public void deletarTurma(Long id) {
        turmaRepository.deleteById(id);
    }

}
