package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

import com.sp.app.admin.domain.SpecialsDetailManage;
import com.sp.app.admin.domain.SpecialsManage;

public interface SpecialsManageService {
	public void insertSpecials(SpecialsManage dto, String pathname) throws Exception;
	public void updateSpecials(SpecialsManage dto, String pathname) throws Exception;
	public void deleteSpecials(long specialNum, String pathname) throws Exception;
	
	public int dataCountSpecials(Map<String, Object> map);
	public List<SpecialsManage> listSpecials(Map<String, Object> map);
	public SpecialsManage findById(long specialNum);
	
	public void insertSpecialsDetail(SpecialsDetailManage dto) throws Exception;
	public void updateSpecialsDetail(SpecialsDetailManage dto) throws Exception;
	public void deleteSpecialsDetail(long detailNum) throws Exception;
	
	public int dataCountDetail(Map<String, Object> map);
	public List<SpecialsDetailManage> listSpecialsDetail(Map<String, Object> map);
	public List<SpecialsDetailManage> specialsProductSearch(Map<String, Object> map);
}
