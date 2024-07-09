package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.domain.Specials;
import com.sp.app.domain.SpecialsProduct;

public interface SpecialsService {
	public int dataCountSpecials(Map<String, Object> map);
	public List<Specials> listSpecials(Map<String, Object> map);
	public Specials findById(long num);
	
	public int dataCountProduct(Map<String, Object> map);
	public List<SpecialsProduct> listProduct(Map<String, Object> map);
}
