package com.billing.product_service.services;

import com.billing.product_service.entities.Product;
import com.billing.product_service.repositories.ProductRepository;
import com.billing.product_service.services.interfaces.CrudService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ProductService extends CrudService<Product, Long> {

    @Autowired
    protected ProductRepository repository;
}
