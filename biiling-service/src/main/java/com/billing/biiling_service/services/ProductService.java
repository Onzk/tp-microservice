package com.billing.biiling_service.services;

import com.billing.biiling_service.datas.Product;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.hateoas.PagedModel;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;


@FeignClient(name = "PRODUCT-SERVICE")
public interface ProductService {
    @GetMapping("/products-rest/feign/{id}")
    public Product findProductById(@PathVariable(name = "id") Long id);

    @GetMapping("/products")
    public PagedModel<Product> findAllProducts();

}
