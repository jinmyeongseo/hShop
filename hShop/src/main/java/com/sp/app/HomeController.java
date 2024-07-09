package com.sp.app;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.sp.app.domain.SpecialsProduct;
import com.sp.app.service.SpecialsService;

@Controller
public class HomeController {
	@Autowired
	private SpecialsService specialsService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("classify", 200); // 1:특가
		map.put("offset", 0);
		map.put("size", 12);
		List<SpecialsProduct> todayList = specialsService.listProduct(map);
		
		map.put("classify", 300); // 2:기획
		map.put("offset", 0);
		map.put("size", 12);
		List<SpecialsProduct> planList = specialsService.listProduct(map);

		
		model.addAttribute("todayList", todayList);
		model.addAttribute("planList", planList);
		
		return ".home";
	}
}
