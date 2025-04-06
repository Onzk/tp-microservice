package com.billing.client_service.controllers.interfaces;


import com.billing.client_service.services.interfaces.CrudServiceInterface;
import com.ucao.tg.BillingApi.utils.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public abstract class CrudController<T, B> implements CrudControllerInterface<T, B> {

    @Autowired
    protected CrudServiceInterface<T, B> service;

    @Override
    @PostMapping()
    public Response save(@RequestBody T model){
        try{
            return Response.success("Successfully inserted.", service.save(model));
        }catch (Exception e){
            return Response.serverError("An internal error occurred", e.getMessage());
        }
    }



    @Override
    @GetMapping
    public Response show(){
        try{
            return Response.ok("Data retrieved", service.findAll());
        }catch (Exception e){
            return Response.serverError("An internal error occurred",e.getMessage());
        }
    }


    @Override
    @GetMapping("/feign")
    public List<T> feignShow(){
        return service.findAll();
    }

    @Override
    @DeleteMapping("/{id}")
    public Response delete(@PathVariable B id){
        try{
            boolean deleted = service.delete(id);
            return  deleted
                    ? Response.ok("Deletion completed successfully", Map.ofEntries(Map.entry("id", id)))
                    : Response.error("Deletion failed", "ID "+ id + " not found");
        }catch (Exception e){
            return Response.serverError("An internal error occurred",e.getMessage());
        }
    }

    @Override
    @GetMapping("/{id}")
    public Response getOne(@PathVariable B id){
        try{
            Optional<T> model = service.find(id);
            return model.isEmpty()
                    ? Response.error("ID " + id + " not found", null)
                    : Response.ok("Data found", model);
        }catch (Exception e){
            return Response.serverError("An internal error occurred",e.getMessage());
        }
    }

    @Override
    @GetMapping("/feign/{id}")
    public Optional<T> feignGetOne(@PathVariable B id){
        return service.find(id);
    }

    @PutMapping("/{id}")
    public Response update(@RequestBody T model, @PathVariable B id){
        try{
            return Response.success("Update completed successfully", service.update(model, id));
        }catch (Exception e){
            return Response.serverError("An internal error occurred",e.getMessage());
        }
    }
}
