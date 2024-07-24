package com.example.demo.Auth.services;

import com.example.demo.Auth.DTO.LoginDto;
import com.example.demo.Auth.DTO.RegisterDto;
import com.example.demo.Auth.repository.RoleRepository;
import com.example.demo.Auth.repository.UserRepository;
import com.example.demo.User.Role;
import com.example.demo.User.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
//@Autowired
//private AuthService(AuthenticationManager authenticationManager, JwtTokenProvider jwtTokenProvider) {
//    this.authenticationManager = authenticationManager;
//    this.jwtTokenProvider = jwtTokenProvider;
//}
public class AuthService {

    private final UserRepository userRepository;

    private final RoleRepository roleRepository;

    private final PasswordEncoder passwordEncoder;

    private final AuthenticationManager authenticationManager;

    public User authenticate(LoginDto loginDto) {
        //IMPORTANT
//one of ProviderManagers instances is AuthenticationProvider, and it performs a specific
// type of authentication e.g. UsernamePasswordAuthenticationToken
        authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(
                loginDto.getEmail(),
                loginDto.getPassword()
        ));

        return userRepository.findByEmail(loginDto.getEmail())
                .orElseThrow();
    }

    public User signup(RegisterDto registerDto) {
        Set<Role> role = registerDto.getRole().stream()
                .map(roleName -> roleRepository.findByName(roleName.getName())
                        .orElseThrow(() -> new RuntimeException("Role not found: " + roleName)))
                .collect(Collectors.toSet());

        User user = User.builder()
                .name(registerDto.getName())
                .email(registerDto.getEmail())
                .roles(role)
                .password(passwordEncoder.encode(registerDto.getPassword()))
                .build();

        return userRepository.save(user);
    }

}
