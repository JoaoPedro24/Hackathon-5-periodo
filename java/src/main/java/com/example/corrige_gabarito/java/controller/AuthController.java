package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.dto.AuthResponse;
import com.example.corrige_gabarito.java.dto.LoginDto;
import com.example.corrige_gabarito.java.model.Usuario;
import com.example.corrige_gabarito.java.security.JwtTokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginDto loginDTO) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            loginDTO.getLogin(), loginDTO.getSenha()
                    )
            );

            Usuario usuario = (Usuario) authentication.getPrincipal();
            String token = jwtTokenProvider.generateToken(authentication);

            return ResponseEntity.ok(new AuthResponse(token, usuario.getUsername()));
        } catch (AuthenticationException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Login inválido");
        }
    }
}
