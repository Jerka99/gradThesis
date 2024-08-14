package com.example.demo.Map.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class UsersRideRouteDTO {
    private Long rideId;
    private Long userId;
    private List<Integer> sequence;
}
