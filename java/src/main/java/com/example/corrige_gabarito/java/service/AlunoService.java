package com.example.corrige_gabarito.java.service;

import com.example.corrige_gabarito.java.model.Aluno;
import com.example.corrige_gabarito.java.model.Usuario;
import com.example.corrige_gabarito.java.repository.AlunoRepository;
import com.example.corrige_gabarito.java.repository.UsuarioRepository;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class AlunoService {

    private final AlunoRepository alunoRepository;
    private final UsuarioRepository usuarioRepository;

    public List<Aluno> listarTodos() {
        return alunoRepository.findAll();
    }

    public Aluno buscarPorId(Long id) {
        return alunoRepository.findById(id).orElse(null);
    }

    @Transactional
    public Aluno salvar(Aluno aluno) {
        return alunoRepository.save(aluno);
    }

    @Transactional
    public void deletarPorId(Long id) {
        alunoRepository.deleteById(id);
    }

    public Aluno buscarPorUsuario(Usuario usuario) {
        return alunoRepository.findByUsuario(usuario);
    }
}
