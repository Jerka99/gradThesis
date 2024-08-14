package com.example.demo.Map.repository;

import com.example.demo.Auth.entities.User;
import com.example.demo.Map.entities.RideNum;
import com.example.demo.Map.entities.UsersRideRoute;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UsersRouteRepository extends JpaRepository<UsersRideRoute, Long> {
    Long countByRideNumAndSequence(RideNum rideNum, Integer sequence);
//    Long sumNumberByRideNumAndSequence(RideNum rideNum, Integer sequence);
    @Query("SELECT u.sequence FROM UsersRideRoute u WHERE u.user = :user AND u.rideNum = :rideNum")
    List<Integer> findSequenceByUserAndRideNum(@Param("user") User user, @Param("rideNum") RideNum rideNum);

    List<UsersRideRoute> findByUserAndRideNum(User user, RideNum rideNum);

}
