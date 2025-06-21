package com.example.corrige_gabarito.java.api;

import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

import java.util.Base64;

public class KeyGenerator {
    public static void main(String[] args) {
        // Gera uma chave segura para HS512 (64 bytes / 512 bits)
        byte[] keyBytes = Keys.secretKeyFor(SignatureAlgorithm.HS512).getEncoded();
        String base64Key = Base64.getEncoder().encodeToString(keyBytes);
        System.out.println("Sua chave secreta segura (Base64): " + base64Key);
    }
}
