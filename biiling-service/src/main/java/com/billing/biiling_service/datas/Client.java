package com.billing.biiling_service.datas;

import lombok.Data;

@Data
public class Client {
    private Long id;
    private String lastName;
    private String firstName;
    private String email;
}
