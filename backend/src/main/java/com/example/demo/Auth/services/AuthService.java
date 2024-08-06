package com.example.demo.Auth.services;

import com.example.demo.Auth.dto.LoginDto;
import com.example.demo.Auth.dto.RegisterDto;
import com.example.demo.Auth.repository.RoleRepository;
import com.example.demo.Auth.repository.UserRepository;
import com.example.demo.Auth.entities.Role;
import com.example.demo.Auth.entities.User;
import lombok.AllArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.security.core.context.SecurityContextHolder;

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

    public Authentication getCurrentAuthentication() {
        return SecurityContextHolder.getContext().getAuthentication();
    }

    public User authenticate(LoginDto loginDto) {
        //IMPORTANT
//one of ProviderManagers instances is AuthenticationProvider, and it performs a specific
// type of authentication e.g. UsernamePasswordAuthenticationToken
        //important https://docs.spring.io/spring-security/reference/servlet/authentication/passwords/dao-authentication-provider.html#servlet-authentication-daoauthenticationprovider
        authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(
                loginDto.getEmail(),
                loginDto.getPassword()
        ));

        return userRepository.findByEmail(loginDto.getEmail())
                .orElseThrow();
    }

    public User signup(RegisterDto registerDto) {

        Role role = roleRepository.findByName(registerDto.getRole().getName())
                .orElseThrow(() -> new RuntimeException("Role not found"));


        User user = User.builder()
                .name(registerDto.getName())
                .email(registerDto.getEmail())
                .role(role)
                .password(passwordEncoder.encode(registerDto.getPassword()))
                .build();

        return userRepository.save(user);
    }
}
