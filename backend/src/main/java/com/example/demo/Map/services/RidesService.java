package com.example.demo.Map.services;

import com.example.demo.Auth.entities.User;
import com.example.demo.Auth.repository.UserRepository;
import com.example.demo.Auth.services.AuthService;
import com.example.demo.Map.dto.AddressClass;
import com.example.demo.Map.dto.LatLng;
import com.example.demo.Map.dto.RideData;
import com.example.demo.Map.entities.Coordinate;
import com.example.demo.Map.entities.RideNum;
import com.example.demo.Map.entities.RidesTable;
import com.example.demo.Map.repository.RidesCounterRepository;
import com.example.demo.Map.repository.RidesNumRepository;
import com.example.demo.Map.repository.RidesRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class RidesService {

    @Autowired
    RidesRepository ridesRepository;

    @Autowired
    AuthService authService;

    @Autowired
    UserRepository userRepository;

    @Autowired
    RidesCounterRepository ridesCounterRepository;

    @Autowired
    RidesNumRepository ridesNumRepository;

    public void saveRideData(RideData rideData){
        User user = (User) authService.getCurrentAuthentication().getPrincipal();
        RideNum newRide = RideNum.builder()
                .build();

        newRide = ridesCounterRepository.save(newRide);

        for (int i = 0; i < rideData.getMarkerCoordinateList().size(); i++) {
            RidesTable ridesTable = dataMapper(user, rideData.getMarkerCoordinateList().get(i), rideData.getAddressesList().get(i), i, newRide);
            ridesRepository.save(ridesTable);
        }
    }

    public List<RideData> fetchAllRides(){
        User user = (User) authService.getCurrentAuthentication().getPrincipal();

        List<RideNum> numberOfRides = ridesNumRepository.findAll();
        List<RidesTable> ridesTable = ridesRepository.findAll();
        
        List<RideData> rideDataList = Collections.EMPTY_LIST;

        rideDataList = numberOfRides.stream().map(
                rideNum -> RideDataMapper(ridesTable.stream().filter((element) ->
                        element.getRideNum().getId().equals(rideNum.getId())
                ).collect(Collectors.toList()))
        ).toList();

        return rideDataList;
    }

    private RideData RideDataMapper(List<RidesTable> ridesTableList) {
        List<AddressClass> addressesList = new ArrayList<>();
        List<LatLng> markerCoordinateList = new ArrayList<>();
        ridesTableList.forEach(el -> {
                    List<Double> coordinates = Arrays.asList(el.getLatitude(), el.getLongitude());
                    markerCoordinateList.add(new LatLng(coordinates));
                    addressesList.add(new AddressClass(el.getFullAddress(), el.getCity(), el.getDataBetweenTwoAddresses()));
                }
        );
        return new RideData(addressesList, markerCoordinateList);
    }

    private static RidesTable dataMapper(User user, LatLng markersCoordinates, AddressClass addressData, int sequence, RideNum newRide) {
        return RidesTable.builder()
                .createdBy(user)
                .fullAddress(addressData.getFullAddress())
                .city(addressData.getCity())
                .sequence(sequence + 1)
                .dataBetweenTwoAddresses(addressData.getDataBetweenTwoAddresses())
                .latitude(markersCoordinates.getCoordinates().get(0))
                .longitude(markersCoordinates.getCoordinates().get(1))
                .rideNum(newRide)
                .build();
    }


}
