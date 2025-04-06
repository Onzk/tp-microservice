package com.billing.product_service.controllers.interfaces;

import com.billing.product_service.utils.Response;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;


public interface CrudControllerInterface<T, B> {

    public Response save(@RequestBody T model);

    public Response show();

    public List<T> feignShow();

    public Response delete(@PathVariable B id);

    public Response getOne(@PathVariable B id);

    public Optional<T> feignGetOne(@PathVariable B id);

    public Response update(@RequestBody T model, @PathVariable B id);
}
