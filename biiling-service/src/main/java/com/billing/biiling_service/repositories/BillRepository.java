package com.billing.biiling_service.repositories;

import com.billing.biiling_service.entities.Bill;
import org.springframework.data.jpa.repository.JpaRepository;



public interface BillRepository extends JpaRepository<Bill, Long> {
}
