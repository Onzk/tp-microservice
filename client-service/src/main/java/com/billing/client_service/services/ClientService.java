package com.billing.client_service.services;

import com.billing.client_service.entities.Client;
import com.billing.client_service.repositories.ClientRepository;
import com.billing.client_service.services.interfaces.CrudService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ClientService extends CrudService<Client, Long> {

    @Autowired
    protected ClientRepository repository;
}
