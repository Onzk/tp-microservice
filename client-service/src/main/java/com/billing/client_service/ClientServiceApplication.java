package com.billing.client_service;

import com.billing.client_service.entities.Client;
import com.billing.client_service.repositories.ClientRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.data.rest.core.config.RepositoryRestConfiguration;

@SpringBootApplication
public class ClientServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(ClientServiceApplication.class, args);
	}

//	@Bean
//	CommandLineRunner start(ClientRepository clientRepository, RepositoryRestConfiguration restConfiguration){
//		return args -> {
//			restConfiguration.exposeIdsFor(Client.class);
//			clientRepository.save(new Client(null, "SOULE", "Martin", "martin@gmail.com"));
//			clientRepository.save(new Client(null, "MOULE", "Anne", "anne@gmail.com"));
//		};
//	}
}
