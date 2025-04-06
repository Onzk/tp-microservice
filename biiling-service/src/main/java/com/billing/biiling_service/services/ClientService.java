package com.billing.biiling_service.services;

import com.billing.biiling_service.datas.Client;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "CLIENT-SERVICE")
public interface ClientService {
    @GetMapping("/clients-rest/feign/{id}")
    public Client findClientById(@PathVariable(name = "id") Long id);
}
