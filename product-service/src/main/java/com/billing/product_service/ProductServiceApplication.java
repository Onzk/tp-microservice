package com.billing.product_service;

import com.billing.product_service.entities.Product;
import com.billing.product_service.repositories.ProductRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.data.rest.core.config.RepositoryRestConfiguration;

@SpringBootApplication
public class ProductServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(ProductServiceApplication.class, args);
	}

//	@Bean
//	CommandLineRunner start(ProductRepository productRepository, RepositoryRestConfiguration restConfiguration){
//		return args -> {
//			restConfiguration.exposeIdsFor(Product.class);
//			productRepository.save(new Product(null, "CHAUSSURE", "Chaussure de marque", 5000));
//			productRepository.save(new Product(null, "PANTALON", "Pantalon jeans", 3000));
//		};
//	}

}
