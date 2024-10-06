package com.example.demo.Map.dto;

import lombok.*;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RideData {
    private List<AddressClass> addressesList;
    private List<LatLng> markerCoordinateList;
    private double maxCapacity;
    private Long rideId;
    private Integer selectedMarkerIndex1;
    private Integer selectedMarkerIndex2;
    private Long createdBy;
}
