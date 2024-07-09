package com.sp.app.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TotalManageMapper {
	public Map<String, Object> todayProduct();
	public Map<String, Object> thisMonthProduct();
	public Map<String, Object> previousMonthProduct();
	
	public List<Map<String, Object>> dayTotalMoney(String date);
	public List<Map<String, Object>> dayTotalMoney2(String date);
	public List<Map<String, Object>> monthTotalMoney(String month);
	public List<Map<String, Object>> monthTotalMoney2(String month);
	public Map<String, Object> dayOfWeekTotalCount(String month);
}
