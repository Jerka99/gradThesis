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
public class RideData {
    private List<AddressClass> addressesList;
    private List<LatLng> markerCoordinateList;
    private List<LatLng> polylineList;
}
