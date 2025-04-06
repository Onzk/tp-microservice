package com.billing.biiling_service.repositories;

import com.billing.biiling_service.entities.BillDetail;
import org.springframework.data.jpa.repository.JpaRepository;


public interface BillDetailRepository extends JpaRepository<BillDetail, Long> {

}
