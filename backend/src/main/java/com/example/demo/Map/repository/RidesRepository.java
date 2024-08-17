package com.example.demo.Map.repository;

import com.example.demo.Map.entities.RideNum;
import com.example.demo.Map.entities.RidesTable;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface RidesRepository extends JpaRepository<RidesTable, Long> {

    @Modifying
    @Transactional
    @Query("DELETE FROM RidesTable r WHERE r.rideNum = :rideNum")
    void deleteByRideNum(RideNum rideNum);
}
