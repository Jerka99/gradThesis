package com.example.demo.Map.entities;
import com.example.demo.Auth.entities.User;
import jakarta.persistence.*;
import lombok.*;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "desired_rides_table")
public class DesiredRide {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)// also default parameter
    @JoinColumn(name = "created_by_customer_id")
    private User createdBy;


    String firstLocationCity;
    String firstLocationAddress;
    private Double firstLatitude;
    private Double firstLongitude;

    String secondLocationCity;
    String secondLocationAddress;
    private Double secondLatitude;
    private Double secondLongitude;

    Double date;
}
