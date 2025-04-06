package com.billing.biiling_service.services;


import com.billing.biiling_service.entities.Bill;
import com.billing.biiling_service.repositories.BillRepository;
import com.billing.biiling_service.services.interfaces.CrudService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class BillService extends CrudService<Bill, Long> {

    @Autowired
    protected BillRepository repository;


}

