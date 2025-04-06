package com.billing.biiling_service;

import com.billing.biiling_service.datas.Client;
import com.billing.biiling_service.entities.Bill;
import com.billing.biiling_service.entities.BillDetail;
import com.billing.biiling_service.repositories.BillDetailRepository;
import com.billing.biiling_service.repositories.BillRepository;
import com.billing.biiling_service.services.ClientService;
import com.billing.biiling_service.services.ProductService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.Bean;

import java.util.Date;

@SpringBootApplication
@EnableFeignClients
public class BillingServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(BillingServiceApplication.class, args);
	}

//	@Bean
//	CommandLineRunner start(BillRepository billRepository, BillDetailRepository billDetailRepository, ClientService clientService, ProductService productService){
//		return args -> {
//			Client client = clientService.findClientById(1L);
//			System.out.println("**************************************");
//			System.out.println("Client : " + client.getId() + " => " + client.getLastName() + " " + client.getFirstName() + " (" + client.getEmail() + ")");
//			System.out.println("**************************************");
//			Bill bill = billRepository.save(new Bill(null, client.getId(), null, new Date(), null));
//			productService.findAllProducts().getContent().forEach(product -> {
//				System.out.println("Produit : " + product.getId() + " => " + product.getName() + " " + product.getDescription() + " (" + product.getPrice() + " FCFA)");
//				System.out.println("**************************************");
//				billDetailRepository.save(new BillDetail(null, product.getId(), null, 2, product.getPrice(), bill.getId()));
//			});
//		};
//	}

}
