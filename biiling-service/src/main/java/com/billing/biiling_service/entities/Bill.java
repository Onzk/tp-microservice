package com.billing.biiling_service.entities;

import com.billing.biiling_service.datas.Client;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.util.Collection;
import java.util.Date;

@Entity
@Table(name = "bills")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Bill {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private Long client_id;
    @Transient
    private Client client;
    private Date date;
    @OneToMany(mappedBy = "bill_id", targetEntity = BillDetail.class, cascade = CascadeType.REMOVE)
    private Collection<BillDetail> details;
}