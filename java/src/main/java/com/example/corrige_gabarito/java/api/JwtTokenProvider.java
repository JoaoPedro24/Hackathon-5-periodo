package com.example.corrige_gabarito.java.api;



import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;

@Component
public class JwtTokenProvider {

    // Injeta o valor de 'app.jwtSecret' do application.properties
    @Value("${app.jwtSecret}")
    private String jwtSecret; // Não é 'final' pois será injetado pelo Spring

    // Injeta o valor de 'app.jwtExpirationInMs' do application.properties
    @Value("${app.jwtExpirationInMs}")
    private long jwtExpirationInMs; // Não é 'final' pois será injetado pelo Spring

    private Key key; // Não é 'final' pois será inicializada no método @PostConstruct

    // Construtor vazio ou padrão. O Spring fará a injeção via @Value antes de @PostConstruct.
    public JwtTokenProvider() {
        // Nada a fazer aqui se a inicialização da 'key' for no @PostConstruct
    }

    // @PostConstruct garante que este método será executado APÓS todas as injeções @Value
    // serem concluídas, garantindo que 'jwtSecret' já tenha um valor.
    @jakarta.annotation.PostConstruct // Use jakarta.annotation.PostConstruct para Spring Boot 3+
    public void init() {
        // Use o valor de jwtSecret injetado para criar a chave
        this.key = Keys.hmacShaKeyFor(jwtSecret.getBytes());
    }

    public String generateToken(Authentication authentication) {
        String username = authentication.getName();

        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + jwtExpirationInMs);

        return Jwts.builder()
                .setSubject(username)
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(key, SignatureAlgorithm.HS512)
                .compact();
    }
}