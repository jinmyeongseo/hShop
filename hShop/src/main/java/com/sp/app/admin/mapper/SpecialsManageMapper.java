package com.sp.app.admin.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.admin.domain.SpecialsDetailManage;
import com.sp.app.admin.domain.SpecialsManage;

@Mapper
public interface SpecialsManageMapper {
	public void insertSpecials(SpecialsManage dto) throws SQLException;
	public void updateSpecials(SpecialsManage dto) throws SQLException;
	public void deleteSpecials(long num) throws SQLException;
	
	public int dataCountSpecials(Map<String, Object> map);
	public List<SpecialsManage> listSpecials(Map<String, Object> map);
	public SpecialsManage findById(long num);
	
	public void insertSpecialsDetail(SpecialsDetailManage dto) throws SQLException;
	public void updateSpecialsDetail(SpecialsDetailManage dto) throws SQLException;
	public void deleteSpecialsDetail(long detailNum) throws SQLException;
	
	public int dataCountDetail(Map<String, Object> map);
	public List<SpecialsDetailManage> listSpecialsDetail(Map<String, Object> map);
	public List<SpecialsDetailManage> specialsProductSearch(Map<String, Object> map);
}
