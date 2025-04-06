package com.billing.biiling_service.services;


import com.billing.biiling_service.entities.BillDetail;
import com.billing.biiling_service.repositories.BillDetailRepository;
import com.billing.biiling_service.services.interfaces.CrudService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class BillDetailService extends CrudService<BillDetail, Long> {

    @Autowired
    protected BillDetailRepository repository;
}
