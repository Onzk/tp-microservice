package com.billing.biiling_service.controllers.interfaces;


import com.billing.biiling_service.utils.Response;
import org.springframework.web.bind.annotation.*;


public interface CrudControllerInterface<T, B> {

    public Response save(@RequestBody T model);

    public Response show();

    public Response delete(@PathVariable B id);

    public Response getOne(@PathVariable B id);

    public Response update(@RequestBody T model, @PathVariable B id);
}
