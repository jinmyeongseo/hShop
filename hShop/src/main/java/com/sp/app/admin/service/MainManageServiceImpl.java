package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sp.app.admin.mapper.TotalManageMapper;

@Service
public class MainManageServiceImpl implements MainManageService {
	@Autowired
	private TotalManageMapper mapper;
	
	@Override
	public Map<String, Object> todayProduct() {
		Map<String, Object> resultMap = null;
		
		try {
			resultMap = mapper.todayProduct();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return resultMap;
	}

	@Override
	public Map<String, Object> thisMonthProduct() {
		Map<String, Object> resultMap = null;
		
		try {
			resultMap = mapper.thisMonthProduct();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return resultMap;
	}

	@Override
	public Map<String, Object> previousMonthProduct() {
		Map<String, Object> resultMap = null;
		
		try {
			resultMap = mapper.previousMonthProduct();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return resultMap;
	}
	
	@Override
	public List<Map<String, Object>> dayTotalMoney(String date) {
		List<Map<String, Object>> list = null;
		
		try {
			list = mapper.dayTotalMoney(date);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public List<Map<String, Object>> monthTotalMoney(String month) {
		List<Map<String, Object>> list = null;
		
		try {
			list = mapper.monthTotalMoney(month);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public Map<String, Object> dayOfWeekTotalCount(String month) {
		Map<String, Object> resultMap = null;
		
		try {
			resultMap = mapper.dayOfWeekTotalCount(month);
			
			/*
			long total = ((BigDecimal) resultMap.get("TOTAL")).longValue();
			long sun = ((BigDecimal) resultMap.get("SUN")).longValue();
			long mon = ((BigDecimal) resultMap.get("MON")).longValue();
			long tuh = ((BigDecimal) resultMap.get("TUE")).longValue();
			long wed = ((BigDecimal) resultMap.get("WED")).longValue();
			long thu = ((BigDecimal) resultMap.get("THU")).longValue();
			long fri = ((BigDecimal) resultMap.get("FRI")).longValue();
			long sat = ((BigDecimal) resultMap.get("SAT")).longValue();
			*/
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return resultMap;
	}
}
