package com.controller;

import java.io.Console;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.pojo.Customer;
import com.service.CustomerService;


@Controller
@RequestMapping("/customer")
public class CustomerController {
	
	//注入service对象
	@Resource
	private CustomerService customerService;
	
	//设计Map集合，存储需要给页面的对象数据
	private Map<String,Object> result=new HashMap<String,Object>();
	
	
	/*查询所有的客户信息,给页面返回json格式数据
	 * 
	 * easyui的datagrid组件，有分页功能，展示时需要接受json格式数据：[{id:1,name:xxx},{id:2,name:xxx}]
	 * 
	 * 使用@ResponseBody之后，直接将数据返回到请求网址：http://localhost:8080/ssm-CRM/customer/list.action
	 * */
	@RequestMapping("/list")
	@ResponseBody //用于转换对象为json
	public List<Customer> list()
	{
		System.out.println("---controller list");
		//查询数据
		List<Customer> customers=customerService.findAllCustomers();
		return customers;
	}
	
	
	//分页查询
	@RequestMapping("/listByPage")
	@ResponseBody
	public Map<String,Object> listByPage(Integer page,Integer rows)
	{
		System.out.println("---controller listPage");
		
		//设置分页参数
		PageHelper.startPage(page, rows);
		//查询所有数据
		List<Customer> customers=customerService.findAllCustomers();
		//使用PageInfo封装查询结果
		PageInfo<Customer> pageInfo=new PageInfo<Customer>(customers);
		//从PageInfo中取出查询结果
		long total=pageInfo.getTotal();
		//当前页数据列表
		List<Customer> custList=pageInfo.getList();
		result.put("total", total);
		result.put("rows", custList);
		return result;
	}
	
	
	//!!!!!!!!!!!! @ResponseBody注解写在public后面，而不能写在public上面，否则一直报错 400 !!!!!!!!!!!
	//保存新增的客户数据
	@RequestMapping("/save")
	public @ResponseBody Map<String,Object> save(Customer customer)
	{
		System.out.println("---controller save");
		Map<String,Object> res=new HashMap<String,Object>();

		try {
			customerService.save(customer);
			res.put("success",true);
		} catch (Exception e) {
			// TODO: handle exception
			res.put("success",false);
			res.put("msg",e.getMessage());
		}
		
		return res;
	}
	
	@RequestMapping("/findById")
	public @ResponseBody Customer findById(Integer id)
	{
		System.out.println("---controller findById");
		Customer customer=customerService.findById(id);
		return customer;
	}
	
	//!!!!!!!!!!! 前端id=1&id=2 ,后端用数组接受
	@RequestMapping("/remove")
	@ResponseBody
	public Map<String,Object> remove(Integer[] id)
	{
		System.out.println("---controller remove");
		Map<String,Object> res=new HashMap<String,Object>();
		try {
			customerService.remove(id);
			res.put("success",true);
		} catch (Exception e) {
			// TODO: handle exception
			res.put("success",false);
			res.put("msg",e.getMessage());
		}
		return res;
	}
}
