package com.sp.app.admin.controller;

import java.io.File;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

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

import com.sp.app.admin.domain.ProductManage;
import com.sp.app.admin.domain.ProductStockManage;
import com.sp.app.admin.service.ProductManageService;
import com.sp.app.common.MyUtil;

@Controller
@RequestMapping("/admin/product/*")
public class ProductManageController {
	@Autowired
	private ProductManageService service;
	
	@Autowired
	private MyUtil myUtil;
	
	@RequestMapping(value = {"{menuItem}/main", "/main"})
	public String list(@PathVariable(required = false) Optional<Integer> menuItem,
		@RequestParam(defaultValue = "0") long parentNum,
		@RequestParam(defaultValue = "0") long categoryNum,
		@RequestParam(defaultValue = "1") int productShow,
		@RequestParam(defaultValue = "all") String schType,
		@RequestParam(defaultValue = "") String kwd,		
		@RequestParam(value = "page", defaultValue = "1") int current_page,
		HttpServletRequest req,
		Model model) throws Exception {
	
		/*
		String str = null;
		String s = Optional.ofNullable(str).orElse("test"); // str 이 null 이면 test 반환하고 그렇지 않으면 str 값 반한
		*/
		int classify = menuItem.orElse(100);
		
		String cp = req.getContextPath();
		
		int size = 10;
		int total_page;
		int dataCount;
		
		if (req.getMethod().equalsIgnoreCase("GET")) {
			kwd = URLDecoder.decode(kwd, "UTF-8");
		}
		
		List<ProductManage> listCategory = service.listCategory(); 
		List<ProductManage> listSubCategory = null;
		if(parentNum == 0 && listCategory.size() !=0) {
			parentNum = listCategory.get(0).getCategoryNum();
		}
		listSubCategory = service.listSubCategory(parentNum);
		if(categoryNum == 0 && listSubCategory.size() != 0) {
			categoryNum = listSubCategory.get(0).getCategoryNum();
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("classify", classify);
		map.put("parentNum", parentNum);
		map.put("categoryNum", categoryNum);
		map.put("productShow", productShow);
		map.put("schType", schType);
		map.put("kwd", kwd);
		
		dataCount = service.dataCount(map);
		total_page = myUtil.pageCount(dataCount, size);
		if(current_page > total_page) {
			current_page = total_page;
		}
		
		int offset = (current_page - 1) * size;
		if(offset < 0) offset = 0;
		
		map.put("offset", offset);
		map.put("size", size);
		
		List<ProductManage> list = service.listProduct(map);
		
		String listUrl = cp + "/admin/product/" + classify + "/main";
		String articleUrl = cp + "/admin/product/" + classify + "/article?page=" + current_page;
		
		String query = "parentNum=" + parentNum + "&categoryNum="+categoryNum;
		if(productShow != -1) {
			query += "&productShow="+productShow;
		}
		if (kwd.length() != 0) {
			query += "&schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "UTF-8");
		}		
		listUrl += "?" + query;
		articleUrl += "&" + query;
		
		String paging = myUtil.pagingUrl(current_page, total_page, listUrl);
		
		model.addAttribute("classify", classify);
		model.addAttribute("listCategory", listCategory);
		model.addAttribute("listSubCategory", listSubCategory);
		model.addAttribute("list", list);
		model.addAttribute("dataCount", dataCount);
		
		model.addAttribute("productShow", productShow);
		model.addAttribute("parentNum", parentNum);
		model.addAttribute("categoryNum", categoryNum);
		model.addAttribute("schType", schType);
		model.addAttribute("kwd", kwd);

		model.addAttribute("articleUrl", articleUrl);
		
		model.addAttribute("page", current_page);
		model.addAttribute("size", size);
		model.addAttribute("total_page", total_page);
		model.addAttribute("paging", paging);
				
		return ".admin.product.list";
	}
	
	@GetMapping("listSubCategory")
	@ResponseBody
	public Map<String, Object> listSubCategory(
			@RequestParam long parentNum) throws Exception {
		Map<String, Object> model = new HashMap<String, Object>();
		
		List<ProductManage> listSubCategory = service.listSubCategory(parentNum);
		
		model.put("listSubCategory", listSubCategory);
		
		return model;
	}
	
	@GetMapping("{classify}/write")
	public String writeForm(@PathVariable int classify, Model model) {
		List<ProductManage> listCategory = service.listCategory();
		List<ProductManage> listSubCategory = null;
		long parentNum = 0;
		if(listCategory.size() !=0) {
			parentNum = listCategory.get(0).getCategoryNum();
		}
		listSubCategory = service.listSubCategory(parentNum);
		
		model.addAttribute("mode", "write");
		model.addAttribute("classify", classify);
		model.addAttribute("listCategory", listCategory);
		model.addAttribute("listSubCategory", listSubCategory);
		
		return ".admin.product.write";
	}
	
	@PostMapping("{classify}/write")
	public String writeSubmit(@PathVariable int classify,
			ProductManage dto,
			HttpSession session,
			Model model) {
		
		String root = session.getServletContext().getRealPath("/");
		String path = root + "uploads" + File.separator + "product";
		
		try {
			service.insertProduct(dto, path);
		} catch (Exception e) {
		}
		
		String url = "redirect:/admin/product/" + classify + "/main?parentNum=" + dto.getParentNum()
						+ "&categoryNum=" + dto.getCategoryNum();
		
		return url;
	}
	
	@GetMapping("{classify}/article")
	public String article(@PathVariable int classify,
			Model model) {
		
		return ".admin.product.article";
	}
	
	@GetMapping("{classify}/update")
	public String updateForm(
			@PathVariable int classify,
			@RequestParam(defaultValue = "0") long parentNum,
			@RequestParam(defaultValue = "0") long categoryNum,
			@RequestParam long productNum,
			@RequestParam String page,
			Model model) {
		
		ProductManage dto = service.findById(productNum);
		if(dto == null) {
			String query = "parentNum=" + parentNum + "&categoryNum=" + categoryNum + "&page=" + page;
			return "redirect:/admin/product/" + classify + "/main?" + query;
		}

		// 카테고리
		List<ProductManage> listCategory = service.listCategory();
		List<ProductManage> listSubCategory = service.listSubCategory(parentNum);
		
		// 추가 이미지
		List<ProductManage> listFile = service.listProductFile(productNum);
		
		// 옵션1/옵션2 옵션명
		List<ProductManage> listOption = service.listProductOption(productNum);
		
		// 옵션1/옵션2 상세 옵션
		List<ProductManage> listOptionDetail = null;
		List<ProductManage> listOptionDetail2 = null;
		if(listOption.size() > 0) {
			dto.setOptionNum(listOption.get(0).getOptionNum());
			dto.setOptionName(listOption.get(0).getOptionName());
			listOptionDetail = service.listOptionDetail(listOption.get(0).getOptionNum());
		}
		if(listOption.size() > 1) {
			dto.setOptionNum2(listOption.get(1).getOptionNum());
			dto.setOptionName2(listOption.get(1).getOptionName());
			listOptionDetail2 = service.listOptionDetail(listOption.get(1).getOptionNum());
		}
		
		model.addAttribute("mode", "update");
		model.addAttribute("classify", classify);
		
		model.addAttribute("dto", dto);
		model.addAttribute("listFile", listFile);
		model.addAttribute("listOptionDetail", listOptionDetail);
		model.addAttribute("listOptionDetail2", listOptionDetail2);
		
		model.addAttribute("listCategory", listCategory);
		model.addAttribute("listSubCategory", listSubCategory);
		model.addAttribute("parentNum", parentNum);
		
		model.addAttribute("page", page);
		
		return ".admin.product.write";
	}
	
	@PostMapping("{classify}/update")
	public String updateSubmit(
			@PathVariable int classify,
			ProductManage dto,
			@RequestParam String page,
			HttpSession session,
			Model model) {
		
		String root = session.getServletContext().getRealPath("/");
		String path = root + "uploads" + File.separator + "product";
		
		try {
			service.updateProduct(dto, path);
		} catch (Exception e) {
		}
		
		String query = "parentNum=" + dto.getParentNum() + "&categoryNum=" + dto.getCategoryNum() + "&page=" + page;
		
		return "redirect:/admin/product/" + classify + "/main?" + query;
	}
	
	@PostMapping("deleteFile")
	@ResponseBody
	public Map<String, Object> deleteFile(@RequestParam long fileNum, 
			@RequestParam String filename,
			HttpSession session) throws Exception {

		String state = "true";
		try {
			String root = session.getServletContext().getRealPath("/");
			String pathname = root + "uploads" + File.separator + "product" + File.separator + filename;

			service.deleteProductFile(fileNum, pathname);
		} catch (Exception e) {
			state = "false";
		}
		
		Map<String, Object> model = new HashMap<>();
		model.put("state", state);
		return model;
	}
	
	@PostMapping("deleteOptionDetail")
	@ResponseBody
	public Map<String, Object> deleteOptionDetail(@RequestParam long detailNum) throws Exception {
		
		String state = "true";
		try {
			service.deleteOptionDetail(detailNum);
		} catch (Exception e) {
			state = "false";
		}
		
		Map<String, Object> model = new HashMap<>();
		model.put("state", state);
		return model;
	}
	
	// AJAX-Text
	@GetMapping("listProductStock")
	public String listProductStock(@RequestParam Map<String, Object> paramMap, Model model) throws Exception {
		// 상세 옵션별 재고 -----
		try {
			List<ProductStockManage> list = service.listProductStock(paramMap); // productNum, optionCount
			
			if(list.size() >= 1) {
				String productName = list.get(0).getProductName();
				String title = list.get(0).getOptionName();
				String title2 = list.get(0).getOptionName2();
				
				model.addAttribute("productNum", paramMap.get("productNum"));
				model.addAttribute("productName", productName);
				model.addAttribute("title", title);
				model.addAttribute("title2", title2);
			}
			
			model.addAttribute("list", list);
		} catch (Exception e) {
		}
		
		return "admin/product/listProductStock";
	}
	
	@PostMapping("updateProductStock")
	@ResponseBody
	public Map<String, Object> updateProductStock(ProductStockManage dto) throws Exception {
		// 상세 옵션별 재고 추가 또는 변경 -----
		String state = "true";
		try {
			service.updateProductStock(dto);
		} catch (Exception e) {
			state = "false";
		}
		
		Map<String, Object> model = new HashMap<>();
		model.put("state", state);
		return model;
	}
}
