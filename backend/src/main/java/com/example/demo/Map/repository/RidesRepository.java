package com.example.demo.Map.repository;

import com.example.demo.Auth.entities.User;
import com.example.demo.Map.entities.RideNum;
import com.example.demo.Map.entities.RidesTable;
import com.example.demo.Map.entities.UsersRideRoute;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RidesRepository extends JpaRepository<RidesTable, Long> {

    @Transactional
    void deleteByRideNum(RideNum rideNum);

    List<RidesTable> findAllByCreatedBy(User user);

    RidesTable findBySequenceAndRideNum(Integer sequence, RideNum rideNum);
}
