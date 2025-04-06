package com.billing.biiling_service.controllers;


import com.billing.biiling_service.controllers.interfaces.CrudController;
import com.billing.biiling_service.entities.Bill;
import com.billing.biiling_service.repositories.BillDetailRepository;
import com.billing.biiling_service.repositories.BillRepository;
import com.billing.biiling_service.services.BillDetailService;
import com.billing.biiling_service.services.BillService;
import com.billing.biiling_service.services.ClientService;
import com.billing.biiling_service.services.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;


@RestController
@RequestMapping(path = "/bills-rest")
public class BillController extends CrudController<Bill, Long> {

    @Autowired
    protected BillRepository billRepository;

    @Autowired
    protected BillDetailRepository detailRepository;

    @Autowired
    protected ClientService clientService;

    @Autowired
    protected ProductService productService;

    @GetMapping("/full/{id}")
    public Optional<Bill> fullBill(@PathVariable("id") Long id){
        Optional<Bill> bill = billRepository.findById(id);
        if(bill.isPresent()){
            bill.get().setClient(clientService.findClientById(bill.get().getClient_id()));
            bill.get().getDetails().forEach(detail -> {
                detail.setProduct(productService.findProductById(detail.getProduct_id()));
            });
        }
        return bill;
    }



}

