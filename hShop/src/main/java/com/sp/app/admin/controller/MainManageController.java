package com.sp.app.admin.controller;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.admin.service.MainManageService;

@Controller
public class MainManageController {
	
	@Autowired
	private MainManageService service;
	 
	@GetMapping("/admin")
	public String main(Model model) {
		
		Map<String, Object> today = service.todayProduct();
		Map<String, Object> thisMonth = service.thisMonthProduct();
		Map<String, Object> previousMonth = service.previousMonthProduct();
		
		model.addAttribute("today", today);
		model.addAttribute("thisMonth", thisMonth);
		model.addAttribute("previousMonth", previousMonth);
		
		return ".adminLayout";
	}

	@GetMapping("/admin/charts")
	@ResponseBody
	public Map<String, Object> total() {
		Calendar cal = Calendar.getInstance();
		int y = cal.get(Calendar.YEAR);
		int m = cal.get(Calendar.MONTH) + 1;
		int d = cal.get(Calendar.DATE);
		
		String date = String.format("%04d-%02d-%02d", y, m, d);
		String month = String.format("%04d%02d", y, m);
		
		List<Map<String, Object>> days = service.dayTotalMoney(date);
		List<Map<String, Object>> months = service.monthTotalMoney(month);
		
		if(d < 20) {
			cal.add(Calendar.MONTH, -1);
			y = cal.get(Calendar.YEAR);
			m = cal.get(Calendar.MONTH) + 1;
			month = String.format("%04d%02d", y, m);
		}
		Map<String, Object> dayOfWeek = service.dayOfWeekTotalCount(month);
		dayOfWeek.put("month", month);
		
		Map<String, Object> model = new HashMap<String, Object>();
		
		model.put("days", days);
		model.put("months", months);
		model.put("dayOfWeek", dayOfWeek);
		
		
		return model;
	}

}
