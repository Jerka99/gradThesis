package com.example.demo.Map.dto;
import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor

public class PersonalRide {
    Long rideId;
    String firstLocation;
    String lastLocation;
//    Date date;
}
