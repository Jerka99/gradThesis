package com.example.demo.Map.entities;

import com.example.demo.Auth.entities.User;
import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Table(name = "users_ride_route", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"ride_id", "sequence", "user_id"})
})
public class UsersRideRoute {
    @Id
    @SequenceGenerator(name = "user_ride_seq_gen", sequenceName = "user_ride_seq", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "user_ride_seq_gen")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ride_id")
    private RideNum rideNum;

    @Column(name = "sequence")
    private Integer sequence;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;
}
