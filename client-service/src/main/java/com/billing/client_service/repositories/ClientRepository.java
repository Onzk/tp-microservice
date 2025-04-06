package com.billing.client_service.repositories;

import com.billing.client_service.entities.Client;
import org.springframework.data.jpa.repository.JpaRepository;


public interface ClientRepository extends JpaRepository<Client, Long> {

}
