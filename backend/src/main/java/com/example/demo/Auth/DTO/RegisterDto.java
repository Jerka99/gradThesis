package com.example.demo.Auth.DTO;

import com.example.demo.User.Role;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RegisterDto {
    private String name;
    private String email;
    private String password;
    private Set<RoleDto> role; // Roles as set of RoleDto objects

    @Getter
    @Setter
    public static class RoleDto {
        private Long id;
        private String name;
    }
}
