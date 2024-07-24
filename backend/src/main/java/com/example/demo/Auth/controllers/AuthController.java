package com.example.demo.Auth.controllers;

import com.example.demo.Auth.DTO.LoginDto;
import com.example.demo.Auth.DTO.LoginResponse;
import com.example.demo.Auth.DTO.RegisterDto;
import com.example.demo.Auth.repository.RoleRepository;
import com.example.demo.Auth.services.JwtService;
import com.example.demo.Auth.services.AuthService;
import com.example.demo.User.Role;
import com.example.demo.User.User;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@AllArgsConstructor
//    private AuthController(AuthService authService) {
//        this.authService = authService;
//    }
@RestController
@RequestMapping("/auth")
public class AuthController {

    private final JwtService jwtService;

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginDto loginDto){
        User authenticatedUser = authService.authenticate(loginDto);

        String jwtToken = jwtService.generateToken(authenticatedUser);

        LoginResponse loginResponse = LoginResponse.builder().
                token(jwtToken).
                expiresIn(jwtService.getExpirationTime()).
                build();

        return ResponseEntity.ok(loginResponse);
    }

    @PostMapping("/signup")
    public ResponseEntity<User> register(@RequestBody RegisterDto registerDto) {
        User registeredUser = authService.signup(registerDto);

        return ResponseEntity.ok(registeredUser);
    }

}

//The process begins when a user sends a sign-in request to the Service. An Authentication object called UsernamePasswordAuthenticationToken is then generated, using the provided username and password.
//The AuthenticationManager is responsible for authenticating the Authentication object, handling all necessary tasks. If the username or password is incorrect, an exception is thrown, and a response with HTTP Status 403 is returned to the user.
//After successful authentication, an attempt is made to retrieve the user from the database. If the user does not exist in the database, a response with HTTP Status 403 is sent to the user. However, since we have already passed step 2 (authentication), this step is not crucial, as the user should already be in the database.
//Once we have the user information, we call the JwtService to generate the JWT.
//The JWT is then encapsulated in a JSON response and returned to the user.
//https://medium.com/@truongbui95/jwt-authentication-and-authorization-with-spring-boot-3-and-spring-security-6-2f90f9337421