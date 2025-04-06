package com.billing.biiling_service.datas;

import lombok.Data;

@Data
public class Product {
    private Long id;
    private String name;
    private String description;
    private double price;
}
