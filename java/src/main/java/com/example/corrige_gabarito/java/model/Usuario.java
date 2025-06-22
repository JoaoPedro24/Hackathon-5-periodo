package com.example.corrige_gabarito.java.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Usuario implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private String password;
    private String login;
    private String role;


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        System.out.println("DEBUG: Role do usuário no método getAuthorities(): " + this.role); // ADICIONE AQUI
        if ("ADMIN".equalsIgnoreCase(this.role)) {
            return List.of(new SimpleGrantedAuthority("ROLE_ADMIN"), new SimpleGrantedAuthority("ROLE_USER"));
        } else if ("PROFESSOR".equalsIgnoreCase(this.role)) {
            return List.of(new SimpleGrantedAuthority("ROLE_PROFESSOR"), new SimpleGrantedAuthority("ROLE_USER"));
        } else if ("ALUNO".equalsIgnoreCase(this.role)) {
            return List.of(new SimpleGrantedAuthority("ROLE_ALUNO"), new SimpleGrantedAuthority("ROLE_USER"));
        } else {
            return List.of(new SimpleGrantedAuthority("ROLE_USER"));
        }
    }


    @Override
    public String getUsername() {
        return this.login;
    }

    @Override
    public boolean isAccountNonExpired() {
        return UserDetails.super.isAccountNonExpired();
    }

    @Override
    public boolean isAccountNonLocked() {
        return UserDetails.super.isAccountNonLocked();
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return UserDetails.super.isCredentialsNonExpired();
    }

    @Override
    public boolean isEnabled() {
        return UserDetails.super.isEnabled();
    }
}
