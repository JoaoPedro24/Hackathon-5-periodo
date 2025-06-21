package com.example.corrige_gabarito.java.service;

import com.example.corrige_gabarito.java.model.Disciplina;
import com.example.corrige_gabarito.java.model.Usuario;
import com.example.corrige_gabarito.java.repository.DisciplinaRepository;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class DisciplinaService {

    private final DisciplinaRepository disciplinaRepository;

    public List<Disciplina> listarTodos() {
        return disciplinaRepository.findAll();
    }

    public Disciplina buscarPorId(Long id) {
        return disciplinaRepository.findById(id).orElse(null);
    }

    @Transactional
    public Disciplina salvar(Disciplina disciplina) {
        return disciplinaRepository.save(disciplina);
    }

    @Transactional
    public void deletarPorId(Long id) {
        disciplinaRepository.deleteById(id);
    }

    public List<Disciplina> listarPorProfessor(Usuario professor) {
        return disciplinaRepository.findByProfessor (professor);
    }
}


