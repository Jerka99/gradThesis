package com.example.demo.Map.controllers;

import com.example.demo.Map.dto.RideData;
import com.example.demo.Map.dto.UsersRideRouteDTO;
import com.example.demo.Map.dto.UsersRideRouteDTO;
import com.example.demo.Map.entities.UsersRideRoute;
import com.example.demo.Map.services.RidesService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
            ridesService.saveRideData(rideData);

        return ResponseEntity.ok("Ride is saved successfully");
    }

    @PostMapping("/saveUserRoute")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> saveUserRoute(@RequestBody UsersRideRouteDTO usersRideRouteDTO) {

        ridesService.saveUserRoute(usersRideRouteDTO);

        return ResponseEntity.ok("Ride is saved successfully");
    }

    @PostMapping("/saveUsersDesiredRideData")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> saveDesiredRideData(@RequestBody UsersRideRouteDTO usersRideRouteDTOđ) {
        //related to AuthenticationManager
//        ridesService.saveRideData(rideData);
//
        return ResponseEntity.ok("Ride is saved successfully");
    }

    @GetMapping("/fetchAllRides")
    @PreAuthorize("hasAnyRole('DRIVER', 'CUSTOMER')")
    public ResponseEntity<List<RideData>> fetchAllRides() {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON_UTF8); // Ensure UTF-8 encoding

        List<RideData> rideData = ridesService.fetchAllRides();

        return new ResponseEntity<>(rideData, headers, HttpStatus.OK);
    }
}
