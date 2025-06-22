package com.example.corrige_gabarito.java.api;



import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
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

        // Captura as roles (authorities) do usuário autenticado
        var roles = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .toList();

        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + jwtExpirationInMs);

        return Jwts.builder()
                .setSubject(username)
                .claim("roles", roles) // ✅ adiciona as roles no payload
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(key, SignatureAlgorithm.HS512)
                .compact();
    }
    public String getUsernameFromToken(String token) {
        Claims claims = Jwts.parser()
                .setSigningKey(key) // Usa a mesma chave para validar a assinatura
                .build()
                .parseClaimsJws(token) // Faz o parse do token, validando a assinatura
                .getBody(); // Obtém o corpo (payload) do token

        return claims.getSubject(); // Retorna o 'subject' (nome de usuário)
    }
    public boolean validateToken(String authToken) {
        try {
            Jwts.parser().setSigningKey(key).build().parseClaimsJws(authToken);
            return true;
        } catch (MalformedJwtException ex) {
            // Logar ou lidar com exceções de token malformado
            System.err.println("Token JWT inválido: " + ex.getMessage());
        } catch (ExpiredJwtException ex) {
            // Logar ou lidar com exceções de token expirado
            System.err.println("Token JWT expirado: " + ex.getMessage());
        } catch (UnsupportedJwtException ex) {
            // Logar ou lidar com exceções de token não suportado
            System.err.println("Token JWT não suportado: " + ex.getMessage());
        } catch (IllegalArgumentException ex) {
            // Logar ou lidar com exceções de argumento ilegal (ex: string JWT vazia)
            System.err.println("String JWT vazia: " + ex.getMessage());
        } catch (io.jsonwebtoken.security.SignatureException ex) {
            // Logar ou lidar com exceções de assinatura inválida (chave incorreta)
            System.err.println("Assinatura JWT inválida: " + ex.getMessage());
        }
        return false;
    }
}