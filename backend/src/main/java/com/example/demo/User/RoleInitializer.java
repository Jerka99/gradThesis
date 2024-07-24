package com.example.demo.User;

import com.example.demo.Auth.repository.RoleRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Arrays;

@Component
public class RoleInitializer {

    @Autowired
    private RoleRepository roleRepository;

    @PostConstruct
    public void initRoles() {
        if (roleRepository.count() == 0) {
            Arrays.asList("ROLE_DRIVER", "ROLE_CUSTOMER", "ROLE_ADMIN").forEach(roleName -> {
                Role role = new Role();
                role.setName(roleName);
                roleRepository.save(role);
            });
        }
    }
}
