package com.example.demo.Map.entities;

import com.example.demo.Auth.entities.User;
import com.example.demo.Map.dto.DataBetweenTwoAddresses;
import com.example.demo.Map.dto.LatLng;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Table(name = "rides_table")
public class RidesTable {

    @Id
    @SequenceGenerator(name = "seq", sequenceName = "ride_seq", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq")
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)// also default parameter
    @JoinColumn(name = "created_by_user_id")
    private User createdBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ride_id")
    private RideNum rideNum;

    //    private Coordinate coordinates; //won't be used
    private String fullAddress;
    private String city;
    private Integer sequence;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "duration", column = @Column(name = "duration")),
            @AttributeOverride(name = "distance", column = @Column(name = "distance")),
    })
    private DataBetweenTwoAddresses dataBetweenTwoAddresses;

    private Double latitude;
    private Double longitude;

    int capacity;
}
