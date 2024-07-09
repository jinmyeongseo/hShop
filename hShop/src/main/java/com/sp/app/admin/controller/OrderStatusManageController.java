package com.sp.app.admin.controller;

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

import com.sp.app.admin.domain.OrderDetailManage;
import com.sp.app.admin.domain.OrderManage;
import com.sp.app.admin.service.OrderStatusManageService;
import com.sp.app.common.MyUtil;
import com.sp.app.domain.SessionInfo;

@Controller
@RequestMapping("/admin/order/*")
public class OrderStatusManageController {
	@Autowired
	private OrderStatusManageService service;
	
	@Autowired
	private MyUtil myUtil;
	
	@RequestMapping("{orderStatus}")
	public String status(
			@PathVariable String orderStatus,
			@RequestParam(defaultValue = "1") int state,
			@RequestParam(value = "page", defaultValue = "1") int current_page,
			@RequestParam(defaultValue = "orderNum") String schType,
			@RequestParam(defaultValue = "") String kwd,
			HttpServletRequest req,
			Model model) throws Exception {
		// 주문 현황
		// state : 1-결제완료, 2-전체, 3-배송단계
		
		if(orderStatus.equals("delivery")) {
			state = 3;
		}
		
		String cp = req.getContextPath();
		
		int size = 10;
		int total_page;
		int dataCount;
		
		if (req.getMethod().equalsIgnoreCase("GET")) {
			kwd = URLDecoder.decode(kwd, "UTF-8");
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("state", state);
		map.put("schType", schType);
		map.put("kwd", kwd);
		
		dataCount = service.orderCount(map);
		total_page = myUtil.pageCount(dataCount, size);
		if(current_page > total_page) {
			current_page = total_page;
		}
		
		int offset = (current_page - 1) * size;
		if(offset < 0) offset = 0;
		
		map.put("offset", offset);
		map.put("size", size);
		
		List<OrderManage> list = service.listOrder(map);
		List<Map<String, Object>> listDeliveryCompany = service.listDeliveryCompany();
		
		String listUrl = cp + "/admin/order/" + orderStatus;
		
		String query = "state=" + state;
		if (kwd.length() != 0) {
			query += "&schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "UTF-8");
		}		
		listUrl += "?" + query;
		
		String paging = myUtil.pagingUrl(current_page, total_page, listUrl);
		
		model.addAttribute("orderStatus", orderStatus);
		
		model.addAttribute("list", list);
		model.addAttribute("dataCount", dataCount);
		model.addAttribute("state", state);
		
		model.addAttribute("schType", schType);
		model.addAttribute("kwd", kwd);
		
		model.addAttribute("page", current_page);
		model.addAttribute("size", size);
		model.addAttribute("total_page", total_page);
		model.addAttribute("paging", paging);
		model.addAttribute("query", query);

		model.addAttribute("listDeliveryCompany", listDeliveryCompany);

		return ".admin.orderStatus.status";
	}
	
	@GetMapping("detail/info")
	public String detail(
			@RequestParam String orderNum,
			@RequestParam String orderStatus,
			Model model) throws Exception {
		// 주문번호에 대한 주문상세 정보
		
		// 주문 정보
		OrderManage order = service.findById(orderNum);
		
		// 주문 상세 정보
		List<OrderDetailManage> listDetail = service.orderDetails(orderNum);
		
		model.addAttribute("order", order);
		model.addAttribute("listDetail", listDetail);
		
		return "admin/orderStatus/detail";
	}
	
	@PostMapping("detail/invoiceNumber")
	@ResponseBody
	public Map<String, Object> invoiceNumber(@RequestParam Map<String, Object> paramMap) {
		// 송장 번호 등록/변경
		String state = "true";
		
		try {
			service.updateOrder("invoiceNumber", paramMap);
		} catch (Exception e) {
			state = "false";
		}
		
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("state", state);
		return model;
	}

	@PostMapping("detail/delivery")
	@ResponseBody
	public Map<String, Object> delivery(@RequestParam Map<String, Object> paramMap) {
		// 배송 상태 변경
		String state = "true";
		
		try {
			service.updateOrder("delivery", paramMap);
		} catch (Exception e) {
			state = "false";
		}
		
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("state", state);
		return model;
	}

	@PostMapping("detail/updateDetailState")
	@ResponseBody
	public Map<String, Object> updateDetailState(@RequestParam Map<String, Object> paramMap,
			HttpSession session) {
		// 상세 주문별 상태 변경
		Map<String, Object> model = new HashMap<String, Object>();
		
		String state = "true";
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		try {
			int detailState = Integer.parseInt((String)paramMap.get("detailState"));
			
			paramMap.put("memberIdx", info.getMemberIdx());
			service.updateOrderDetailState(paramMap);
			model.put("detailState", detailState);
			
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		return model;
	}
	
	@GetMapping("detail/listDetailState")
	@ResponseBody
	public Map<String, Object> listDetailState(@RequestParam long orderDetailNum) {
		// 상세주문별 상태 리스트
		List<Map<String, Object>> list = null;
		try {
			list = service.listDetailStateInfo(orderDetailNum);
		} catch (Exception e) {
		}
		
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("list", list);
		return model;
	}
	
	public String exchange() throws Exception {
		// 교환관리
		return "";
	}

	public String cancel() throws Exception {
		// 반품 및 주문취소
		return "";
	}
}
