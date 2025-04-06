package com.billing.product_service.controllers;


import com.billing.product_service.controllers.interfaces.CrudController;
import com.billing.product_service.entities.Product;
import com.billing.product_service.services.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping(path = "/products-rest")
public class ProductController extends CrudController<Product, Long> {

    @Autowired
    protected ProductService service;
}

