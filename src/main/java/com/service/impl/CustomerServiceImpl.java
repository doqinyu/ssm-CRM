package com.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dao.CustomerMapper;
import com.pojo.Customer;
import com.service.CustomerService;

//给类CustomerServiceImpl起别名customerService
@Service("customerService")
//@Transactional:开启事务管理功能。
//保证每一个事务方法在执行过程中如果出现异常情况，那么将自动回滚操作，使数据库恢复到未执行该方法时的状态。
@Transactional
public class CustomerServiceImpl implements CustomerService{

	//注入Mapper对象
	@Resource
	private CustomerMapper customerMapper;

	public List<Customer> findAllCustomers() {
		// TODO Auto-generated method stub
		return customerMapper.findAllCustomers();
	}

	public void save(Customer customer) {
		// TODO Auto-generated method stub
		//System.out.println("----Service save ");
		//判断是添加客户请求还是修改客户请求
		//当是添加新客户请求时，由于id域被隐藏，此时的id默认为null
		if(customer.getId()==null)
			customerMapper.save(customer);
//		//否则是修改请求
		else
		{
			System.out.println("----update");
			customerMapper.update(customer);
		}
			
	}

	public Customer findById(Integer id) {
		// TODO Auto-generated method stub
		Customer customer=customerMapper.findById(id);
		return customer;
	}

	public void remove(Integer[] id) {
		// TODO Auto-generated method stub
		customerMapper.remove(id);
	} 
	


}
