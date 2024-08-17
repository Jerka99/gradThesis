package com.example.demo.Map.services;

import com.example.demo.Auth.entities.User;
import com.example.demo.Auth.exceptions.DuplicateRouteException;
import com.example.demo.Auth.repository.UserRepository;
import com.example.demo.Auth.services.AuthService;
import com.example.demo.Map.dto.AddressClass;
import com.example.demo.Map.dto.LatLng;
import com.example.demo.Map.dto.RideData;
import com.example.demo.Map.dto.UsersRideRouteDTO;
import com.example.demo.Map.entities.RideNum;
import com.example.demo.Map.entities.RidesTable;
import com.example.demo.Map.entities.UsersRideRoute;
import com.example.demo.Map.repository.RidesCounterRepository;
import com.example.demo.Map.repository.RidesNumRepository;
import com.example.demo.Map.repository.RidesRepository;
import com.example.demo.Map.repository.UsersRouteRepository;
import jakarta.transaction.SystemException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.*;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Collectors;

@Service
public class RidesService {

    @Autowired
    RidesRepository ridesRepository;

    @Autowired
    AuthService authService;

    @Autowired
    UserRepository userRepository;

//    @Autowired
//    RidesCounterRepository ridesCounterRepository;

    @Autowired
    RidesNumRepository ridesNumRepository;

    @Autowired
    UsersRouteRepository usersRouteRepository;


    @Autowired
    private WebClient.Builder webClientBuilder;

    public void saveRideData(RideData rideData) {
        User user = (User) authService.getCurrentAuthentication().getPrincipal();
        RideNum newRide = RideNum.builder()
                .maxCapacity(rideData.getMaxCapacity())
                .build();

        newRide = ridesNumRepository.save(newRide);

        for (int i = 0; i < rideData.getMarkerCoordinateList().size(); i++) {
            RidesTable ridesTable = dataMapper(user, rideData.getMarkerCoordinateList().get(i), rideData.getAddressesList().get(i), i, newRide);
            ridesRepository.save(ridesTable);
        }
    }

    public void saveUserRoute(UsersRideRouteDTO usersRideRouteDTO) {
        User user = (User) authService.getCurrentAuthentication().getPrincipal();
        user.getId();

        RideNum rideNum = ridesNumRepository.getReferenceById(usersRideRouteDTO.getRideId());

        try {
            usersRideRouteDTO.getSequence().forEach(number ->
                    usersRouteRepository.save(routeMapper(user, rideNum, number))
            );
        } catch (DataIntegrityViolationException e) {
            throw new DuplicateRouteException("You have already scheduled this ride, ride id: " + rideNum.getId());
        }
    }

    public List<RideData> fetchAllRides() {
        List<RideNum> numberOfRides = ridesNumRepository.findAll();
        List<RidesTable> ridesTable = ridesRepository.findAll();

        List<RideData> rideDataList;

        rideDataList = numberOfRides.stream().map(
                rideNum -> RideDataMapper(ridesTable.stream().filter((oneRide) ->
                        oneRide.getRideNum().getId().equals(rideNum.getId())
                ).collect(Collectors.toList()))
        ).toList();

        return rideDataList;
    }

    private RideData RideDataMapper(List<RidesTable> oneRide) {
        List<AddressClass> addressesList = new ArrayList<>();
        List<LatLng> markerCoordinateList = new ArrayList<>();
        double maxCapacity = 0.0;
        RideNum rideNum = null;
        Long createdById = null;

        User user = (User) authService.getCurrentAuthentication().getPrincipal();

        for (RidesTable el : oneRide) {
            List<Double> coordinates = Arrays.asList(el.getLatitude(), el.getLongitude());
            markerCoordinateList.add(new LatLng(coordinates));
            maxCapacity = el.getRideNum().getMaxCapacity();
            rideNum = el.getRideNum();
            createdById = el.getCreatedBy().getId();
            Long peopleOnStation = usersRouteRepository.countByRideNumAndSequence(el.getRideNum(), el.getSequence());
            Long capacityOnStation = (long) (el.getRideNum().getMaxCapacity() - peopleOnStation);
            addressesList.add(new AddressClass(el.getFullAddress(), el.getCity(), el.getDataBetweenTwoAddresses(), capacityOnStation));
        }
         List<Integer> sequences = usersRouteRepository.findSequenceByUserAndRideNum(user, rideNum);
        Integer firstMarker = null;
        Integer lastMarker = null;
        if(!sequences.isEmpty()){
        firstMarker = sequences.get(0) - 1;
        lastMarker = (sequences.get(sequences.size() - 1));
        }
        return new RideData(addressesList, markerCoordinateList, maxCapacity, rideNum.getId(), firstMarker, lastMarker, createdById);
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

    private static UsersRideRoute routeMapper(User user, RideNum ride, int sequence) {
        return UsersRideRoute.builder()
                .user(user)
                .rideNum(ride)
                .sequence(sequence)
                .build();
    }

    public void deleteUserRoute(long rideId) {
        User user = (User) authService.getCurrentAuthentication().getPrincipal();

        try {
        usersRouteRepository.deleteByUserIdAndRideId(user.getId(), rideId);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void deleteRide(long rideId) {
        User user = (User) authService.getCurrentAuthentication().getPrincipal();
        RideNum rideNum = ridesNumRepository.getReferenceById(rideId);
            try {
                usersRouteRepository.deleteRideId(rideId);
                ridesRepository.deleteByRideNum(rideNum);
                ridesNumRepository.delete(rideNum);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
    }
}

