package com.billing.client_service.controllers;


import com.billing.client_service.controllers.interfaces.CrudController;
import com.billing.client_service.entities.Client;
import com.billing.client_service.services.ClientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(path = "/clients-rest")
public class ClientController extends CrudController<Client, Long> {

    @Autowired
    protected ClientService service;
}
