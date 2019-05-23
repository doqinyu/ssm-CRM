package com.dao;

import java.util.List;

import com.pojo.Customer;

public interface CustomerMapper {
	
	//查询所有的客户信息
	public List<Customer> findAllCustomers();
	//添加客户信息
	public void save(Customer customer);
	//根据id查询对象
	public Customer findById(Integer id);
	public void update(Customer customer);
	public void remove(Integer[] id);
}
