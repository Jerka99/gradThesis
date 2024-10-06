package com.example.demo.Map.services;
import com.example.demo.config.LoggingInterceptor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;

import com.example.demo.Auth.entities.User;
import com.example.demo.Auth.exceptions.DuplicateRouteException;
import com.example.demo.Auth.repository.UserRepository;
import com.example.demo.Auth.services.AuthService;
import com.example.demo.Map.dto.*;
import com.example.demo.Map.entities.DesiredRide;
import com.example.demo.Map.entities.RideNum;
import com.example.demo.Map.entities.RidesTable;
import com.example.demo.Map.entities.UsersRideRoute;
import com.example.demo.Map.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class RidesService implements HandlerInterceptor{

    @Autowired
    RidesRepository ridesRepository;

    @Autowired
    UserRepository userRepository;

    @Autowired
    AuthService authService;

    @Autowired
    RidesNumRepository ridesNumRepository;

    @Autowired
    UsersRouteRepository usersRouteRepository;

    @Autowired
    DesiredRidesRepository desiredRidesRepository;

    @Autowired
    DirectionsService directionsService;

    private static final Logger logger = LoggerFactory.getLogger(LoggingInterceptor.class);

    public void saveRideData(RideData rideData, User user) {
        if(user == null) {
            user = (User) authService.getCurrentAuthentication().getPrincipal();
        }
        RideNum newRide = RideNum.builder()
                .maxCapacity(rideData.getMaxCapacity())
                .build();

        newRide = ridesNumRepository.save(newRide);

        for (int i = 0; i < rideData.getMarkerCoordinateList().size(); i++) {
            RidesTable ridesTable = ridesTableMapper(user, rideData.getMarkerCoordinateList().get(i),
                    rideData.getAddressesList().get(i), i, newRide);
            ridesRepository.save(ridesTable);
        }
    }

    public void saveUserRoute(UsersRideRouteDTO usersRideRouteDTO, User user) {
        if(user == null) {
            user = (User) authService.getCurrentAuthentication().getPrincipal();
        }
        RideNum rideNum = ridesNumRepository.getReferenceById(usersRideRouteDTO.getRideId());

        try {
            User finalUser = user;
            usersRideRouteDTO.getSequence().forEach(number ->
                    usersRouteRepository.save(routeMapper(finalUser, rideNum, number))
            );
        } catch (DataIntegrityViolationException e) {
            throw new DuplicateRouteException("You have already scheduled this ride, ride id: " + rideNum.getId());
        }
    }

    public void saveDesiredRideData(RideData rideData) {
        User user = (User) authService.getCurrentAuthentication().getPrincipal();

        desiredRidesRepository.save(desiredRideMapper(rideData, user));

        List<DesiredRide> allDesiredRides = desiredRidesRepository.findAll();

        Map<String, List<DesiredRide>> groupedByFirstLocation = allDesiredRides.stream()
                .collect(Collectors.groupingBy(DesiredRide::getFirstLocationCity));

        for (Map.Entry<String, List<DesiredRide>> entry : groupedByFirstLocation.entrySet()) {
            List<DesiredRide> ridesWithSameFirstLocation = entry.getValue();

            if (ridesWithSameFirstLocation.size() >= 3) {

                Map<String, List<DesiredRide>> groupedBySecondLocation = ridesWithSameFirstLocation.stream()
                        .filter(ride -> !ride.getFirstLocationCity().equals(ride.getSecondLocationCity())) // Ensure locations are different
                        .collect(Collectors.groupingBy(DesiredRide::getSecondLocationCity));


                for (Map.Entry<String, List<DesiredRide>> secondEntry : groupedBySecondLocation.entrySet()) {
                    List<DesiredRide> ridesWithSameSecondLocation = secondEntry.getValue();

                    if (ridesWithSameSecondLocation.size() >= 3) {

                        List<Double> durationsList = directionsService.getDirections(ridesWithSameSecondLocation);

                        RideData newRideData = createNewRideData(ridesWithSameSecondLocation, durationsList);

                        saveRideData(newRideData, userRepository.getReferenceById(1L));

                        List<RideNum> rideNum = ridesNumRepository.findAll();


                        for(int i = 0; i < ridesWithSameSecondLocation.size(); i ++) {
                            List<Integer> sequences = new ArrayList<>();
                            for (int j = 1; j <= 4; j++) {
                                sequences.add(i + j); //for i = 0 - 1,2,3,4 for i = 1 - 2,3,4,5 and i = 2 - 3,4,5,6
                            }
                            UsersRideRouteDTO usersRideRouteDTO = new UsersRideRouteDTO(
                                    rideNum.getLast().getId(),
                                    ridesWithSameSecondLocation.get(i).getCreatedBy().getId(),
                                    sequences
                            );
                            saveUserRoute(usersRideRouteDTO, ridesWithSameSecondLocation.get(i).getCreatedBy());
                        }
                        int size = ridesWithSameSecondLocation.size();
                        for(int i = 0; i < size; i ++) {
                            desiredRidesRepository.delete(ridesWithSameFirstLocation.get(i));
                        }

                    }
                }
            }
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

    public List<PersonalRide> fetchCustomersRidesById() {
        User user = (User) authService.getCurrentAuthentication().getPrincipal();
        List<PersonalRide> personalRideList = new ArrayList<>();
        List<UsersRideRoute> numberOfRides = usersRouteRepository.findAllByUserId(user.getId());

        Map<Long, List<UsersRideRoute>> groupedById = numberOfRides.stream()
                .collect(Collectors.groupingBy(ride -> ride.getRideNum().getId()));

        List<List<UsersRideRoute>> listOfLists = new ArrayList<>(groupedById.values());

        listOfLists.forEach(el->{
            RidesTable firstFetch = ridesRepository.findBySequenceAndRideNum(el.getFirst().getSequence(), el.getFirst().getRideNum());
            String firstLocation = firstFetch.getFullAddress() + firstFetch.getCity();

            RidesTable secondFetch = ridesRepository.findBySequenceAndRideNum(el.getLast().getSequence() + 1, el.getFirst().getRideNum());
            String secondLocation = secondFetch.getFullAddress() + secondFetch.getCity();
            PersonalRide personalRide = new PersonalRide(
                    el.getFirst().getRideNum().getId(),
                    firstLocation,
                    secondLocation
            );
            personalRideList.add(personalRide);
        });

        return personalRideList;
    }

    public List<PersonalRide> fetchDriversRidesById() {
        User user = (User) authService.getCurrentAuthentication().getPrincipal();
        List<PersonalRide> personalRideList = new ArrayList<>();
        List<RidesTable> numberOfRides = ridesRepository.findAllByCreatedBy(user);

        Map<Long, List<RidesTable>> groupedById = numberOfRides.stream()
                .collect(Collectors.groupingBy(ride -> ride.getRideNum().getId()));

        List<List<RidesTable>> listOfLists = new ArrayList<>(groupedById.values());

        listOfLists.forEach(el->{
            String firstLocation = el.getFirst().getFullAddress() + el.getFirst().getCity();

            String lastLocation = el.getLast().getFullAddress() + el.getLast().getCity();
            PersonalRide personalRide = new PersonalRide(
                    el.getFirst().getRideNum().getId(),
                    firstLocation,
                    lastLocation
            );
            personalRideList.add(personalRide);
        });


        return personalRideList;
    }



    public void deleteUserRoute(long rideId) {
        User user = (User) authService.getCurrentAuthentication().getPrincipal();
        RideNum rideNum = ridesNumRepository.getReferenceById(rideId);

        try {
            usersRouteRepository.deleteByUserAndRideNum(user, rideNum);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void deleteRide(long rideId) {
        RideNum rideNum = ridesNumRepository.getReferenceById(rideId);
        try {
            usersRouteRepository.deleteByRideNum(rideNum);
            ridesRepository.deleteByRideNum(rideNum);
            ridesNumRepository.delete(rideNum);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
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
            createdById = 1L;
            System.out.println(STR."created By Id: \{createdById}");
            logger.info("\"created By Id: {}", createdById);
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
        return RideData.builder()
                .addressesList(addressesList)
                .markerCoordinateList(markerCoordinateList)
                .maxCapacity(maxCapacity)
                .rideId(rideNum.getId())
                .selectedMarkerIndex1(firstMarker)
                .selectedMarkerIndex2(lastMarker)
                .createdBy(createdById)
                .build();
    }

    private static RidesTable ridesTableMapper(User user, LatLng markersCoordinates, AddressClass addressData, int sequence, RideNum newRide) {
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

    private DesiredRide desiredRideMapper(RideData rideData, User user) {
        AddressClass firstAddress = rideData.getAddressesList().getFirst();
        AddressClass lastAddress = rideData.getAddressesList().getLast();

        LatLng firstCoordinates = rideData.getMarkerCoordinateList().getFirst();
        LatLng secondCoordinates = rideData.getMarkerCoordinateList().getLast();

        return DesiredRide.builder().
                firstLocationCity(firstAddress.getCity()).
                firstLocationAddress(firstAddress.getFullAddress()).
                firstLatitude(firstCoordinates.getCoordinates().getFirst()).
                firstLongitude(firstCoordinates.getCoordinates().getLast()).
                secondLocationCity(lastAddress.getCity()).
                secondLocationAddress(lastAddress.getFullAddress()).
                secondLatitude(secondCoordinates.getCoordinates().getFirst()).
                secondLongitude(secondCoordinates.getCoordinates().getLast()).
                date(firstAddress.getDataBetweenTwoAddresses().getDuration()).
                createdBy(user).
                build();
    }

    private static RideData createNewRideData(List<DesiredRide> ridesWithSameSecondLocation, List<Double> durationsList) {
        Long stationCapacity = 3L;
        List<LatLng> markerCoordinateList = new ArrayList<>();
        List<AddressClass> addressClassList = new ArrayList<>();
        for(int i = 0; i < ridesWithSameSecondLocation.size(); i++) {
            DataBetweenTwoAddresses dataBetweenTwoAddresses =
                    new DataBetweenTwoAddresses(durationsList.get(i), 0);

            AddressClass addressClass = new AddressClass(
                    ridesWithSameSecondLocation.get(i).getFirstLocationCity(),
                    ridesWithSameSecondLocation.get(i).getFirstLocationAddress(),
                    dataBetweenTwoAddresses,
                    stationCapacity
            );
            addressClassList.add(addressClass);
            List<Double> coordinates = Arrays.asList(ridesWithSameSecondLocation.get(i).getFirstLatitude(), ridesWithSameSecondLocation.get(i).getFirstLongitude());
            markerCoordinateList.add(new LatLng(coordinates));
        }
        for(int i = 0; i < ridesWithSameSecondLocation.size(); i++) {
            DataBetweenTwoAddresses dataBetweenTwoAddresses =
                    new DataBetweenTwoAddresses(durationsList.get(i + 3), 0);

            AddressClass addressClass = new AddressClass(
                    ridesWithSameSecondLocation.get(i).getSecondLocationCity(),
                    ridesWithSameSecondLocation.get(i).getSecondLocationAddress(),
                    dataBetweenTwoAddresses,
                    stationCapacity
            );
            addressClassList.add(addressClass);
            List<Double> coordinates = Arrays.asList(ridesWithSameSecondLocation.get(i).getSecondLatitude(), ridesWithSameSecondLocation.get(i).getSecondLongitude());
            markerCoordinateList.add(new LatLng(coordinates));
        }
        return RideData.builder()
                .addressesList(addressClassList)
                .markerCoordinateList(markerCoordinateList)
                .maxCapacity(3)
                .createdBy(3L)
                .build();
    }

}

