package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.dto.ResultadoProva;
import com.example.corrige_gabarito.java.model.*;
import com.example.corrige_gabarito.java.service.*;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@AllArgsConstructor
@RequestMapping("/prova")
public class ProvaController {

    private final ProvaService provaService;
    private final DisciplinaService disciplinaService;
    private final UsuarioService usuarioService;
    private final TurmaService turmaService;
    private final RespostaAlunoService respostaAlunoService;


    @GetMapping("/listar")
    public String listar(Model model, Principal principal) {
        Usuario professor = usuarioService.buscarPorLogin(principal.getName());
        List<Disciplina> disciplinasDoProfessor = disciplinaService.listarPorProfessor(professor);

        List<Prova> provas;
        if (professor.getRole().contains("PROFESSOR")) {
            // Se for professor, lista apenas as provas dele
            provas = provaService.listarPorProfessorId(professor.getId());
        } else {
            // Se for outro tipo (admin, etc), lista todas as provas
            provas = provaService.listarTodas();
        }

        model.addAttribute("provas", provas);
        model.addAttribute("prova", new Prova());
        model.addAttribute("disciplinas", disciplinasDoProfessor);
        model.addAttribute("turmas", turmaService.listarTodas());

        return "prova/lista";
    }

    @PostMapping
    public String salvar(@ModelAttribute Prova prova, Principal principal, Model model) {
        return salvarOuAtualizar(prova, principal, model);
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model, Principal principal) {
        Usuario professor = usuarioService.buscarPorLogin(principal.getName());
        Prova prova = provaService.buscarPorId(id);

        if (prova == null) {
            return "redirect:/prova/listar";
        }

        List<Prova> provas;
        if (professor.getRole().contains("PROFESSOR")) {
            provas = provaService.listarPorProfessorId(professor.getId());
        } else {
            provas = provaService.listarTodas();
        }

        List<Disciplina> disciplinasDoProfessor = disciplinaService.listarPorProfessor(professor);
        List<Turma> turmas = turmaService.listarTodas();

        model.addAttribute("prova", prova);
        model.addAttribute("disciplinas", disciplinasDoProfessor);
        model.addAttribute("turmas", turmas);
        model.addAttribute("provas", provas);

        return "prova/lista";
    }


    @GetMapping("/remover/{id}")
    public String remover(@PathVariable Long id) {
        provaService.deletarPorId(id);
        return "redirect:/prova/listar";
    }

    /**
     * Método auxiliar para salvar ou atualizar prova (evitando duplicação de código)
     */
    private String salvarOuAtualizar(Prova prova, Principal principal, Model model) {
        try {
            Usuario professor = usuarioService.buscarPorLogin(principal.getName());
            prova.setProfessor(professor);

            if (prova.getQuestoes() != null) {
                prova.getQuestoes().forEach(q -> q.setProva(prova));
            }

            provaService.salvar(prova);
            return "redirect:/prova/listar";

        } catch (Exception e) {
            model.addAttribute("message", "Não foi possível salvar a prova: " + e.getMessage());
            model.addAttribute("provas", provaService.listarTodas());
            model.addAttribute("disciplinas", disciplinaService.listarPorProfessor(usuarioService.buscarPorLogin(principal.getName())));
            model.addAttribute("turmas", turmaService.listarTodas());
            model.addAttribute("prova", prova);
            return "prova/lista";
        }
    }

    @GetMapping("/{id}/resultados")
    public String visualizarResultados(@PathVariable Long id, Model model) {
        Prova prova = provaService.buscarPorId(id);

        if (prova == null) {
            return "redirect:/prova/listar";
        }

        List<RespostaAluno> respostas = respostaAlunoService.buscarPorProvaId(id);

        // Agrupar respostas por aluno
        Map<Aluno, List<RespostaAluno>> respostasPorAluno = respostas.stream()
                .collect(Collectors.groupingBy(RespostaAluno::getAluno));

        List<ResultadoProva> resultados = new ArrayList<>();
        double somaNotas = 0;
        int alunosCorrigidos = 0;

        for (Map.Entry<Aluno, List<RespostaAluno>> entry : respostasPorAluno.entrySet()) {
            Aluno aluno = entry.getKey();
            List<RespostaAluno> respostasAluno = entry.getValue();

            BigDecimal notaTotal = respostasAluno.stream()
                    .map(RespostaAluno::getValor)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            long questoesCertas = respostasAluno.stream()
                    .filter(r -> r.getValor().compareTo(BigDecimal.ZERO) > 0)
                    .count();

            resultados.add(new ResultadoProva(
                    aluno.getUsuario().getNome(),
                    notaTotal.doubleValue(),
                    (int) questoesCertas
            ));

            somaNotas += notaTotal.doubleValue();
            alunosCorrigidos++;
        }

        double mediaTurma = alunosCorrigidos > 0 ? somaNotas / alunosCorrigidos : 0;

        Set<Aluno> alunosDaTurma = prova.getTurma().getAlunos();
        Set<Aluno> alunosComRespostas = respostasPorAluno.keySet();

        List<String> alunosNaoCorrigidos = alunosDaTurma.stream()
                .filter(aluno -> !alunosComRespostas.contains(aluno))
                .map(aluno -> aluno.getUsuario().getNome())
                .collect(Collectors.toList());

        int totalAlunosTurma = alunosDaTurma.size();

        model.addAttribute("alunosNaoCorrigidos", alunosNaoCorrigidos);
        model.addAttribute("prova", prova);
        model.addAttribute("resultados", resultados);
        model.addAttribute("mediaTurma", mediaTurma);
        model.addAttribute("provasCorrigidas", alunosCorrigidos);
        model.addAttribute("totalProvas", totalAlunosTurma);
        model.addAttribute("notaMaxima", prova.getValorTotal());

        return "prova/resultado";
    }
}
