package com.billing.client_service.services.interfaces;


import java.util.List;
import java.util.Optional;

public interface CrudServiceInterface<T, B> {
    public List<T> findAll();
    public T save(T model);
    public T update(T model, B id);
    public Optional<T> find(B id);
    public boolean delete(B id);
}
