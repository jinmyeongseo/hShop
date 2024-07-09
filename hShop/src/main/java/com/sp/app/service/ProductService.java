package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.domain.Product;

public interface ProductService {
	public int dataCount(Map<String, Object> map);
	public List<Product> listProduct(Map<String, Object> map);
	
	public Product findById(long productNum);
	public List<Product> listProductFile(long productNum);
	
	public List<Product> listAllCategory();
	public List<Product> listCategory();
	public List<Product> listSubCategory(long parentNum);
	
	public List<Product> listProductOption(long productNum);
	public List<Product> listOptionDetail(long optionNum);
	public List<Product> listOptionDetailStock(Map<String, Object> map);
}
