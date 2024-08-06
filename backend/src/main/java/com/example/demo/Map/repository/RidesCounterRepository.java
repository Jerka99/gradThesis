package com.example.demo.Map.repository;

import com.example.demo.Map.entities.RideNum;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RidesCounterRepository extends JpaRepository<RideNum, Long> {
}
