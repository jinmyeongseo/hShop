package com.sp.app.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.domain.Specials;
import com.sp.app.domain.SpecialsProduct;

@Mapper
public interface SpecialsMapper {
	public int dataCountSpecials(Map<String, Object> map);
	public List<Specials> listSpecials(Map<String, Object> map);
	public Specials findById(long num);
	
	public int dataCountProduct(Map<String, Object> map);
	public List<SpecialsProduct> listProduct(Map<String, Object> map);
}
