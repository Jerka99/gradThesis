package com.example.demo.Map.services;

import com.example.demo.Map.dto.AddressClass;
import com.example.demo.Map.dto.LatLng;
import com.example.demo.Map.dto.RideData;
import com.example.demo.Map.entities.DesiredRide;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Service
public class DirectionsService {

    @Autowired
    private WebClient.Builder webClientBuilder;

    private static final String API_URL = "https://api.openrouteservice.org/v2/directions/driving-car/geojson";
    private static final String API_KEY = "5b3ce3597851110001cf62487adb1559612143eda0724256da26f388";

    public List<Double> getDirections(List<DesiredRide> desiredRideList) {
        List<List<Double>> markerPoints;
        List<Double> durationList = new ArrayList<>();

        List<List<Double>> pickupPoints = desiredRideList.stream()
                .map(el -> List.of(el.getFirstLatitude(), el.getFirstLongitude()))
                .toList();
        List<List<Double>> droppOffPoint = desiredRideList.stream()
                .map(el -> List.of(el.getSecondLatitude(), el.getSecondLongitude()))
                .toList();
        markerPoints = new ArrayList<>(pickupPoints);
        markerPoints.addAll(droppOffPoint);


        List<List<List<Double>>> consecutivePairs = getConsecutivePairs(markerPoints);

        for (List<List<Double>> pair : consecutivePairs) {
            try {
                String payload = createPayload(pair);
                WebClient webClient = webClientBuilder.build();
                ResponseEntity<String> response = webClient.post()
                        .uri(API_URL)
                        .header("Authorization", API_KEY)
                        .accept(MediaType.APPLICATION_JSON, MediaType.valueOf("application/geo+json"))
                        .contentType(MediaType.APPLICATION_JSON)
                        .bodyValue(payload)
                        .retrieve()
                        .toEntity(String.class)
                        .block();

                ObjectMapper objectMapper = new ObjectMapper();
                assert response != null;
                JsonNode data = objectMapper.readTree(response.getBody());

                if (data.has("error") && data.get("error").get("code").asInt() == 2010) {
                    throw new RuntimeException(data.get("error").get("message").asText());
                }

                Double duration = data.get("features").get(0).get("properties").get("segments").get(0).get("duration").asDouble();

                    durationList.add(duration);


            } catch (Exception e) {
                System.err.println("An error occurred while processing the ride data: " + e.getMessage());
                e.printStackTrace();
            }
        }
        durationList.add(0, EpochTimeCalculator());
        return durationList;
    }

    public double EpochTimeCalculator() {
        LocalDateTime currentDateTime = LocalDateTime.now();

        LocalDateTime futureDateTime = currentDateTime.plus(7, ChronoUnit.DAYS);

        double epochSeconds = (double) futureDateTime.toEpochSecond(ZoneOffset.UTC) * 1000;

        return epochSeconds;
    }



        private String createPayload(List<List<Double>> pair) {
        // Construct the payload as a JSON string
        Map<String, Object> payload = Map.of(
                "coordinates", pair
        );
        try {
            return new ObjectMapper().writeValueAsString(payload);
        } catch (Exception e) {
            throw new RuntimeException("Failed to create payload", e);
        }
    }

    public static List<List<List<Double>>> getConsecutivePairs(List<List<Double>> markerPoints) {
        List<List<List<Double>>> pairs = new ArrayList<>();

        for (int i = 0; i < markerPoints.size() - 1; i++) {
            List<List<Double>> pair = new ArrayList<>();
            pair.add(markerPoints.get(i));
            pair.add(markerPoints.get(i + 1));
            pairs.add(pair);
        }

        return pairs;
    }
}
