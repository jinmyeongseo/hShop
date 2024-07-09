package com.sp.app.admin.controller;

import java.io.File;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.admin.domain.SpecialsDetailManage;
import com.sp.app.admin.domain.SpecialsManage;
import com.sp.app.admin.service.SpecialsManageService;
import com.sp.app.common.MyUtil;

@Controller
@RequestMapping("/admin/specials/*")
public class SpecialsManageController {
	@Autowired
	private SpecialsManageService service;
	
	@Autowired
	private MyUtil myUtil;
	
	@RequestMapping("{classify}/main") 
	public String list(@PathVariable int classify,
			@RequestParam(defaultValue = "1") int state,
			@RequestParam(defaultValue = "all") String schType,
			@RequestParam(defaultValue = "") String kwd,		
			@RequestParam(value = "page", defaultValue = "1") int current_page,
			HttpServletRequest req,
			Model model) throws Exception {

		String cp = req.getContextPath();
		
		int size = 10;
		int total_page;
		int dataCount;
		
		if (req.getMethod().equalsIgnoreCase("GET")) {
			kwd = URLDecoder.decode(kwd, "UTF-8");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("classify", classify);
		map.put("state", state); // 1:진행중, 2:진행예정, 3:기간종료
		map.put("schType", schType);
		map.put("kwd", kwd);
		
		dataCount = service.dataCountSpecials(map);
		total_page = myUtil.pageCount(dataCount, size);
		if(current_page > total_page) {
			current_page = total_page;
		}
		
		int offset = (current_page - 1) * size;
		if(offset < 0) offset = 0;
		
		map.put("offset", offset);
		map.put("size", size);
		
		List<SpecialsManage> list = service.listSpecials(map);
		
		String listUrl = cp + "/admin/specials/" +classify + "/main";
		String articleUrl = cp + "/admin/specials/" +classify + "/article?page=" + current_page;
		String query = "";
		
		if(state != 1) {
			query = "state=" + state;
		}
		if (kwd.length() != 0) {
			query += query.length() != 0 ? "&" : "";
			query += "schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "UTF-8");
		}
		
		if(query.length() != 0) {
			listUrl += "?" + query;
			articleUrl += "&" + query;
		}

		String paging = myUtil.pagingUrl(current_page, total_page, listUrl);
		
		model.addAttribute("classify", classify);
		
		model.addAttribute("list", list);
		model.addAttribute("dataCount", dataCount);
		
		model.addAttribute("state", state);
		model.addAttribute("schType", schType);
		model.addAttribute("kwd", kwd);
		
		model.addAttribute("articleUrl", articleUrl);
		
		model.addAttribute("page", current_page);
		model.addAttribute("size", size);
		model.addAttribute("total_page", total_page);
		model.addAttribute("paging", paging);
		
		return ".admin.specials.list";
	}

	@GetMapping("{classify}/write")
	public String writeForm(@PathVariable int classify,
			Model model) throws Exception {
		
		model.addAttribute("classify", classify);
		model.addAttribute("mode", "write");
		
		return ".admin.specials.write";
	}

	@PostMapping("{classify}/write")
	public String writeSubmit(@PathVariable int classify,
			SpecialsManage dto,
			HttpSession session,
			Model model) throws Exception {
		
		String root = session.getServletContext().getRealPath("/");
		String path = root + "uploads" + File.separator + "specials";
		
		try {
			service.insertSpecials(dto, path);
		} catch (Exception e) {
		}
		
		return "redirect:/admin/specials/" + classify + "/main";
	}
	
	@GetMapping("{classify}/article")
	public String article(@PathVariable int classify,
			@RequestParam long specialNum,
			@RequestParam(defaultValue = "1") int state,
			@RequestParam(defaultValue = "all") String schType,
			@RequestParam(defaultValue = "") String kwd,
			@RequestParam String page,
			Model model) throws Exception {
		
		kwd = URLDecoder.decode(kwd, "utf-8");

		String query = "page=" + page;
		if(state != 1) {
			query += "&state=" + state;
		}
		if (kwd.length() != 0) {
			query += "&schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "UTF-8");
		}
		SpecialsManage dto = service.findById(specialNum);

		if (dto == null) {
			return "redirect:/admin/specials/" + classify + "/main?" + query;
		}
		
		model.addAttribute("classify", classify);
		
		model.addAttribute("dto", dto);
		model.addAttribute("query", query);
		model.addAttribute("page", page);
		
		return ".admin.specials.article";
	}
	
	@GetMapping("{classify}/update")
	public String updateForm(@PathVariable int classify,
			@RequestParam long specialNum,
			@RequestParam String page,
			Model model) throws Exception {
		
		SpecialsManage dto = service.findById(specialNum);

		if (dto == null) {
			return "redirect:/admin/specials/" + classify + "/main?page=" + page;
		}
		
		model.addAttribute("classify", classify);
		model.addAttribute("dto", dto);
		model.addAttribute("page", page);		
		model.addAttribute("mode", "update");
		
		return ".admin.specials.write";
	}

	@PostMapping("{classify}/update")
	public String updateSubmit(@PathVariable int classify,
			SpecialsManage dto,
			@RequestParam String page,
			HttpSession session,
			Model model) throws Exception {
		
		String root = session.getServletContext().getRealPath("/");
		String path = root + "uploads" + File.separator + "specials";
		
		try {
			service.updateSpecials(dto, path);
		} catch (Exception e) {
		}
		
		return "redirect:/admin/specials/" + classify + "/main?page=" + page;
	}
	
	@GetMapping("{classify}/delete")
	public String delete(@PathVariable int classify,
			@RequestParam(defaultValue = "1") int state,
			@RequestParam long specialNum,
			@RequestParam String page,
			@RequestParam String imageFilename,
			@RequestParam(defaultValue = "all") String schType,
			@RequestParam(defaultValue = "") String kwd,
			HttpSession session) throws Exception {

		kwd = URLDecoder.decode(kwd, "utf-8");
		String query = "page=" + page;
		if(state != 1) {
			query += "&state=" + state;
		}
		if (kwd.length() != 0) {
			query += "&schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "UTF-8");
		}

		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "specials" + File.separator + imageFilename;

		try {
			service.deleteSpecials(specialNum, pathname);
		} catch (Exception e) {
		}

		return "redirect:/admin/specials/" + classify + "/main?" + query;
	}	
	
	// 특가/기획전에  상품 등록
	// AJAX - JSON
	@PostMapping("{classify}/productInsert")
	@ResponseBody
	public Map<String, Object> productInsert(@PathVariable int classify,
			SpecialsDetailManage dto) throws Exception {

		String state = "true";
		try {
			service.insertSpecialsDetail(dto);
		} catch (Exception e) {
			state = "false";
		}
		
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("state", state);
		return model;
	}

	// 특가/기획전에 등록된 상품 목록
	// AJAX - JSON
	@GetMapping("{classify}/productList")
	@ResponseBody
	public Map<String, Object> productList(@PathVariable int classify,
			@RequestParam long specialNum,
			@RequestParam(value = "pageNo", defaultValue = "1") int current_page) throws Exception {
		
		int size = 10;
		int total_page;
		int dataCount;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("specialNum", specialNum);
		
		dataCount = service.dataCountDetail(map);
		total_page = myUtil.pageCount(dataCount, size);
		if(current_page > total_page) {
			current_page = total_page;
		}
		
		int offset = (current_page - 1) * size;
		if(offset < 0) offset = 0;
		
		map.put("offset", offset);
		map.put("size", size);
		
		List<SpecialsDetailManage> list = service.listSpecialsDetail(map);
		
		String paging = myUtil.pagingMethod(current_page, total_page, "listPage");
		
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("list", list);
		model.put("dataCount", dataCount);
		model.put("pageNo", current_page);
		model.put("total_page", total_page);
		model.put("size", size);
		model.put("paging", paging);
		
		return model;
	}

	// 특가/기획전에  상품 등록
	// AJAX - JSON
	@PostMapping("{classify}/productUpdate")
	@ResponseBody
	public Map<String, Object> productUpdate(@PathVariable int classify,
			SpecialsDetailManage dto) throws Exception {

		String state = "true";
		try {
			service.updateSpecialsDetail(dto);
		} catch (Exception e) {
			state = "false";
		}
		
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("state", state);
		return model;
	}
	
	// 특가/기획전에 등록된 상품 삭제
	// AJAX - JSON
	@PostMapping("{classify}/productDelete")
	@ResponseBody
	public Map<String, Object> productDelete(@PathVariable int classify,
			@RequestParam long detailNum) throws Exception {

		String state = "true";
		try {
			service.deleteSpecialsDetail(detailNum);
		} catch (Exception e) {
			state = "false";
		}
		
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("state", state);
		return model;
	}

	// 특가/기획전에 등록할 상품 검색
	// AJAX - JSON
	@GetMapping("{classify}/productSearch")
	@ResponseBody
	public Map<String, Object> productSearch(@PathVariable int classify,
			@RequestParam long specialNum,
			@RequestParam String schType,
			@RequestParam String kwd) throws Exception {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("classify", classify);
		map.put("specialNum", specialNum);
		map.put("schType", schType);
		map.put("kwd", kwd);
		
		List<SpecialsDetailManage> list = service.specialsProductSearch(map);
		
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("list", list);
		return model;
	}

}
