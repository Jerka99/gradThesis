package com.example.demo.User;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "roles")
public class Role {

    @Id
    @SequenceGenerator(name="seq", sequenceName="user_seq", allocationSize = 1)
    @GeneratedValue(strategy=GenerationType.SEQUENCE, generator="seq")
    private Long id;
    private String name;
}
