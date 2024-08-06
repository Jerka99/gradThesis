package com.example.demo.Map.repository;

import com.example.demo.Map.entities.RidesTable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RidesRepository extends JpaRepository<RidesTable, Long> {

}
