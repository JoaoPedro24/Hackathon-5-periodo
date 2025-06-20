package com.example.corrige_gabarito.java.service;

import com.example.corrige_gabarito.java.model.Professor;
import com.example.corrige_gabarito.java.repository.ProfessorRepository;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class ProfessorService {

    private final ProfessorRepository professorRepository;

    public List<Professor> listarTodos() {
        return professorRepository.findAll();
    }

    public Professor buscarPorId(Long id) {
        return professorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Professor não encontrado com id: " + id));
    }

    @Transactional
    public Professor salvar(Professor professor) {
        return professorRepository.save(professor);
    }

    @Transactional
    public void deletarPorId(Long id) {
        professorRepository.deleteById(id);
    }
}
