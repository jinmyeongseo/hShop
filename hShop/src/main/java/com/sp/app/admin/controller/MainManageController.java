package com.sp.app.admin.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MainManageController {

	 
	@GetMapping("/admin")
	public String main(Model model) {
		
		
		return ".adminLayout";
	}

	@GetMapping("/admin/charts")
	@ResponseBody
	public Map<String, Object> total() {

		
		Map<String, Object> model = new HashMap<String, Object>();
		
		
		return model;
	}

}
