package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

public interface MainManageService {
	public Map<String, Object> todayProduct();
	public Map<String, Object> thisMonthProduct();
	public Map<String, Object> previousMonthProduct();
	
	public List<Map<String, Object>> dayTotalMoney(String date);
	public List<Map<String, Object>> monthTotalMoney(String month);
	public Map<String, Object> dayOfWeekTotalCount(String month);
}
