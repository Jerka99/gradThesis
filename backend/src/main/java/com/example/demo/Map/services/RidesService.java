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
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.reactive.function.client.WebClient;

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

    @Autowired
    private WebClient.Builder webClientBuilder;

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
        
        List<RideData> rideDataList;

        rideDataList = numberOfRides.stream().map(
                rideNum -> RideDataMapper(ridesTable.stream().filter((element) ->
                        element.getRideNum().getId().equals(rideNum.getId())
                ).collect(Collectors.toList()))
        ).toList();

        return rideDataList;
    }

    private RideData RideDataMapper(List<RidesTable> ridesTableList) {
        List<AddressClass> addressesList = new ArrayList<>();
        List<List<Double>> markerPoints = new ArrayList<>();
        List<LatLng> polyline = new ArrayList<>();

        markerPoints = ridesTableList.stream().map(el -> List.of(el.getLatitude(), el.getLongitude())
        ).toList();

        String apiUrl = "https://api.openrouteservice.org/v2/directions/driving-car/geojson";

        Map<String, Object> payload = Map.of(
                "coordinates", markerPoints
        );

        try {
            WebClient webClient = webClientBuilder.build();
            ResponseEntity<String> response = webClient.post()
                    .uri(apiUrl)
                    .header("Authorization", "5b3ce3597851110001cf62487adb1559612143eda0724256da26f388")
                    .accept(MediaType.APPLICATION_JSON, MediaType.valueOf("application/geo+json"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(payload)
                    .retrieve()
                    .toEntity(String.class)
                    .block();

            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode data = objectMapper.readTree(response.getBody());

            if (data.has("error") && data.get("error").get("code").asInt() == 2010) {
                throw new RuntimeException(data.get("error").get("message").asText());
            }

            JsonNode coordinatesNode = data.get("features").get(0).get("geometry").get("coordinates");

            for (JsonNode coordinate : coordinatesNode) {
                List<Double> point = new ArrayList<>();
                point.add(coordinate.get(0).asDouble());
                point.add(coordinate.get(1).asDouble());
                polyline.add(new LatLng(point));
            }
        }
        catch (Exception e) {
            System.err.println("An error occurred while processing the ride data: " + e.getMessage());
            e.printStackTrace();
        }


        List<LatLng> markerCoordinateList = new ArrayList<>();
        ridesTableList.forEach(el -> {
                    List<Double> coordinates = Arrays.asList(el.getLatitude(), el.getLongitude());
                    markerCoordinateList.add(new LatLng(coordinates));
                    addressesList.add(new AddressClass(el.getFullAddress(), el.getCity(), el.getDataBetweenTwoAddresses()));
                }
        );
        return new RideData(addressesList, markerCoordinateList, polyline);
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
