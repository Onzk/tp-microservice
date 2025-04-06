package com.billing.biiling_service.projections;

import com.billing.biiling_service.entities.Bill;
import com.billing.biiling_service.entities.BillDetail;
import org.springframework.data.rest.core.config.Projection;

import java.util.Collection;
import java.util.Date;

@Projection(name="bf", types = Bill.class)
public interface BillProjection {
    public Long getId();
    public Date getDateBill();
    public Long getClientId();
    public Collection<BillDetail> getBillDetails();
}
