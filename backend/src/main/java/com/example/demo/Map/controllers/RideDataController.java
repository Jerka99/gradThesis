package com.example.demo.Map.controllers;

import com.example.demo.Map.dto.RideData;
import com.example.demo.Map.dto.UsersRideRouteDTO;
import com.example.demo.Map.services.RidesService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@AllArgsConstructor
@RestController
public class RideDataController {

    RidesService ridesService;

    @PostMapping("/saveRideData")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> saveRideData(@RequestBody RideData rideData) {
        //related to AuthenticationManager
            ridesService.saveRideData(rideData, null);

        return ResponseEntity.ok("Ride is saved successfully");
    }

    @PostMapping("/saveUserRoute")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> saveUserRoute(@RequestBody UsersRideRouteDTO usersRideRouteDTO) {

        ridesService.saveUserRoute(usersRideRouteDTO, null);

        return ResponseEntity.ok("Ride is saved successfully");
    }

    @PostMapping("/saveDesiredRideData")
    @PreAuthorize("hasAnyRole('CUSTOMER')")
    public ResponseEntity<String> saveDesiredRideData(@RequestBody RideData rideData) {

        ridesService.saveDesiredRideData(rideData);

        return ResponseEntity.ok("Desired ride is saved successfully");
    }

    @GetMapping("/fetchAllRides")
    @PreAuthorize("hasAnyRole('DRIVER', 'CUSTOMER')")
    public ResponseEntity<List<RideData>> fetchAllRides() {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON_UTF8); // Ensure UTF-8 encoding

        List<RideData> rideData = ridesService.fetchAllRides();

        return new ResponseEntity<>(rideData, headers, HttpStatus.OK);
    }

    @PostMapping("/deleteUserRoute")
    @PreAuthorize("hasAnyRole('CUSTOMER')")
    public ResponseEntity<String> deleteUserRoute(@RequestBody UsersRideRouteDTO usersRideRouteDTO) {

        ridesService.deleteUserRoute(usersRideRouteDTO.getRideId());

        return new ResponseEntity<>("ride id " + usersRideRouteDTO.getRideId() + " is canceled successfully!", HttpStatus.OK);
    }

    @PostMapping("/deleteRideCreatedByDriver")
    @PreAuthorize("hasAnyRole('DRIVER')")
    public ResponseEntity<String> deleteRideCreatedByDriver(@RequestBody UsersRideRouteDTO usersRideRouteDTO) {

        ridesService.deleteRide(usersRideRouteDTO.getRideId());

        return new ResponseEntity<>("ride id " + usersRideRouteDTO.getRideId() + " is deleted successfully!", HttpStatus.OK);
    }
}
