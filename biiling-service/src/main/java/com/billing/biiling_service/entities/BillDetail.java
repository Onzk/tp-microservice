package com.billing.biiling_service.entities;

import com.billing.biiling_service.datas.Client;
import com.billing.biiling_service.datas.Product;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;

@Entity
@Table(name = "bill_details")
@Data
@NoArgsConstructor
@AllArgsConstructor

public class BillDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private Long product_id;
    @Transient
    private Product product;
    private Integer quantity;
    private double price;
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private Long bill_id;
}