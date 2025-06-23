package com.example.corrige_gabarito.java.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication)
            throws IOException, ServletException {

        boolean isAluno = authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ALUNO"));
        boolean isProfessor = authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_PROFESSOR"));
        boolean isAdmin = authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"));

        if (isAluno) {
            response.sendRedirect(request.getContextPath() + "/aluno/minhas-provas");
        } else if (isProfessor) {
            response.sendRedirect(request.getContextPath() + "/prova/listar");
        } else if (isAdmin) {
            response.sendRedirect(request.getContextPath() + "/");
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}
