package com.billing.client_service.services.interfaces;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public abstract class CrudService<T, B> implements CrudServiceInterface<T, B> {

    @Autowired
    protected JpaRepository<T, B> repository;

    @Override
    public List<T> findAll() {
        return repository.findAll().reversed();
    }

    @Override
    public T save(T model) {
        return repository.save(model);
    }

    @Override
    public T update(T model, B id) {
        try {
            model.getClass().getMethod("setId", id.getClass()).invoke(model, id);
        } catch (Exception e) {
            System.out.println("## Error : " + e);
        }
        return repository.save(model);
    }

    @Override
    public Optional<T> find(B id) {
        return repository.findById(id);
    }

    @Override
    public boolean delete(B id) {
        if(repository.existsById(id)){
            repository.deleteById(id);
            return true;
        }
        return false;
    }
}
