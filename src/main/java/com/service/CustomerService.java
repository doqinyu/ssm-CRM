package com.service;

import java.util.List;

import com.pojo.Customer;

public interface CustomerService {

	public List<Customer> findAllCustomers();
	//添加客户
	public void save(Customer customer);
	public Customer findById(Integer id);
	public void remove(Integer[] id);
}
