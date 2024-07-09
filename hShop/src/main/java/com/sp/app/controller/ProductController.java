package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.common.MyUtil;
import com.sp.app.domain.Product;
import com.sp.app.service.ProductService;

@Controller
@RequestMapping("/product/*")
public class ProductController {
	@Autowired
	private ProductService service;
	
	@Autowired
	@Qualifier("myUtil")
	private MyUtil myUtil;
	
	@RequestMapping("main")
	public String main(
			@RequestParam(defaultValue = "1") long categoryNum,
			@RequestParam(value = "page", defaultValue = "1") int current_page,
			HttpServletRequest req,
			Model model) throws Exception {
		
		String cp = req.getContextPath();
		
		int size = 12;
		int total_page;
		int dataCount;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("categoryNum", categoryNum);
		
		dataCount = service.dataCount(map);
		total_page = myUtil.pageCount(dataCount, size);
		if(current_page > total_page) {
			current_page = total_page;
		}
		
		int offset = (current_page - 1) * size;
		if(offset < 0) offset = 0;
		
		map.put("offset", offset);
		map.put("size", size);
		
		List<Product> list = service.listProduct(map);
		
		String listUrl = cp + "/product/main?categoryNum="+categoryNum;
		
		String paging = myUtil.pagingUrl(current_page, total_page, listUrl);
		
		model.addAttribute("list", list);
		model.addAttribute("categoryNum", categoryNum);
		model.addAttribute("page", current_page);
		model.addAttribute("dataCount", dataCount);
		model.addAttribute("size", size);
		model.addAttribute("total_page", total_page);
		model.addAttribute("paging", paging);
		
		return ".product.main";
	}

	@GetMapping("listAllCategory")
	@ResponseBody
	public Map<String, Object> listAllCategory() {
		Map<String, Object> model = new HashMap<String, Object>();
		
		List<Product> listMain = service.listCategory();
		List<Product> listAll = service.listAllCategory();
		
		model.put("listMain", listMain);
		model.put("listAll", listAll);
		
		return model;
	}
	
	@GetMapping("listCategory")
	@ResponseBody
	public List<Product> listCategory() {
		List<Product> list = service.listCategory();
		return list;
	}

	@GetMapping("listSubCategory")
	@ResponseBody
	public List<Product> listSubCategory(@RequestParam long parentNum) {
		List<Product> list = service.listSubCategory(parentNum);
		return list;
	}
	
	@GetMapping("listOptionDetail2")
	@ResponseBody
	public List<Product> listOptionDetail2(@RequestParam long optionNum,
			@RequestParam long optionNum2, @RequestParam long detailNum) {
		List<Product> list = service.listOptionDetail(optionNum2);
		return list;
	}
	
	@GetMapping("listOptionDetailStock")
	@ResponseBody
	public List<Product> listOptionDetailStock(@RequestParam Map<String, Object> paramMap) {
		// 상세 옵션 및 재고량 -----
		List<Product> list = service.listOptionDetailStock(paramMap);
		
		return list;
	}	
	
	@GetMapping("{product}")
	public String buyRequest(@PathVariable String product,
			Model model
			) throws Exception{
		
		try {
			long productNum = Long.parseLong(product);
			
			// 상품
			Product dto = service.findById(productNum);
			if(dto == null || dto.getShowSpecial() == 0) {
				return "redirect:/product/main";
			}
			
			// 추가 이미지
			List<Product> listFile = service.listProductFile(productNum);
			
			// 옵션명
			List<Product> listOption = service.listProductOption(productNum);
			
			// 옵션1 옵션값
			List<Product> listOptionDetail = null;
			if(listOption.size() > 0) {
				listOptionDetail = service.listOptionDetail(listOption.get(0).getOptionNum());
			}
			
			Map<String, Object> map = new HashMap<String, Object>();
			List<Product> listStock = null;
			if(dto.getOptionCount() < 2) {
				map.put("productNum", dto.getProductNum());
				listStock = service.listOptionDetailStock(map);
				
				if(dto.getOptionCount() == 0 && listStock.size() > 0) {
					// 옵션이 없는 경우 재고 수량
					dto.setStockNum(listStock.get(0).getStockNum());
					dto.setTotalStock(listStock.get(0).getTotalStock());
				} else if(dto.getOptionCount() > 0) {
					// 옵션이 하나인 경우 재고 수량
					for(Product vo : listOptionDetail) {
						for(Product ps : listStock) {
							if(vo.getDetailNum() == ps.getDetailNum()) {
								vo.setStockNum(ps.getStockNum());
								vo.setTotalStock(ps.getTotalStock());
								break;
							}
						}
					}
				}
			}
			
			// 추가 이미지
			dto.setFilename(dto.getThumbnail());
			listFile.add(0, dto);
			
			model.addAttribute("dto", dto);
			model.addAttribute("listOption", listOption);
			model.addAttribute("listOptionDetail", listOptionDetail);
			model.addAttribute("listFile", listFile);
			
		} catch (Exception e) {
			return "redirect:/product/main";
		}
		
		return ".product.buy";
	}
	
}
