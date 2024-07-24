package com.example.demo.Auth.repository;
import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.User.Role;

import java.util.Optional;

public interface RoleRepository extends JpaRepository<Role, Long> {

    Optional<Role> findByName(String roleName);
}
