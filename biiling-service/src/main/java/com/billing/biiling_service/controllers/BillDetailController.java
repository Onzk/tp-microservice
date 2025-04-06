package com.billing.biiling_service.controllers;



import com.billing.biiling_service.controllers.interfaces.CrudController;
import com.billing.biiling_service.entities.Bill;
import com.billing.biiling_service.entities.BillDetail;
import com.billing.biiling_service.repositories.BillRepository;
import com.billing.biiling_service.services.BillDetailService;
import com.billing.biiling_service.utils.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;


@RestController
@RequestMapping(path = "/bill-details-rest")
public class BillDetailController extends CrudController<BillDetail, Long> {

    @Autowired
    protected BillDetailService service;

    @Autowired
    protected BillRepository billRepository;

    @Override
    @PostMapping()
    public Response save(@RequestBody BillDetail model){
        try{
            System.out.println(model.toString());
            return Response.success("Successfully inserted.", service.save(model));
        }catch (Exception e){
            return Response.serverError("An internal error occurred", e.getMessage());
        }
    }
}

