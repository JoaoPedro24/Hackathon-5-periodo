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
    private String jwtSecret;

    // Injeta o valor de 'app.jwtExpirationInMs' do application.properties
    @Value("${app.jwtExpirationInMs}")
    private long jwtExpirationInMs;

    private Key key;

    // Construtor vazio ou padrão. O Spring fará a injeção via @Value antes de @PostConstruct.
    public JwtTokenProvider() {
    }

    @jakarta.annotation.PostConstruct
    public void init() {
        this.key = Keys.hmacShaKeyFor(jwtSecret.getBytes());
    }

    public String generateToken(Authentication authentication) {
        String username = authentication.getName();


        var roles = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .toList();

        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + jwtExpirationInMs);

        return Jwts.builder()
                .setSubject(username)
                .claim("roles", roles)
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(key, SignatureAlgorithm.HS512)
                .compact();
    }
    public String getUsernameFromToken(String token) {
        Claims claims = Jwts.parser()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody();

        return claims.getSubject();
    }
    public boolean validateToken(String authToken) {
        try {
            Jwts.parser().setSigningKey(key).build().parseClaimsJws(authToken);
            return true;
        } catch (MalformedJwtException ex) {
            System.err.println("Token JWT inválido: " + ex.getMessage());
        } catch (ExpiredJwtException ex) {
            System.err.println("Token JWT expirado: " + ex.getMessage());
        } catch (UnsupportedJwtException ex) {
            System.err.println("Token JWT não suportado: " + ex.getMessage());
        } catch (IllegalArgumentException ex) {
            System.err.println("String JWT vazia: " + ex.getMessage());
        } catch (io.jsonwebtoken.security.SignatureException ex) {
            System.err.println("Assinatura JWT inválida: " + ex.getMessage());
        }
        return false;
    }
}