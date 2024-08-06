package com.example.demo.Map.dto;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class AddressClass {

//    private Coordinate coordinates; //won't be used
    private String fullAddress;
    private String city;
    private DataBetweenTwoAddresses dataBetweenTwoAddresses;
}
