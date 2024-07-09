package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.common.MyUtil;
import com.sp.app.domain.Destination;
import com.sp.app.domain.Order;
import com.sp.app.domain.Payment;
import com.sp.app.domain.SessionInfo;
import com.sp.app.service.MyPageService;

@Controller
@RequestMapping("/myPage/*")
public class MyPageController {
	@Autowired
	private MyPageService service;
	
	@Autowired
	private MyUtil myUtil;
	
	// 결제내역
	@GetMapping("paymentList")
	public String paymentList(@RequestParam(value = "page", defaultValue = "1") int current_page,
			HttpServletRequest req,
			HttpSession session,
			Model model) throws Exception {
		
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		String cp = req.getContextPath();
		
		int size = 10;
		int total_page;
		int dataCount;
		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberIdx", info.getMemberIdx());
		
		dataCount = service.countPayment(map);
		total_page = myUtil.pageCount(dataCount, size);
		if(current_page > total_page) {
			current_page = total_page;
		}
		
		int offset = (current_page - 1) * size;
		if(offset < 0) offset = 0;
		
		map.put("offset", offset);
		map.put("size", size);
		
		List<Payment> list = service.listPayment(map);
		
		String listUrl = cp + "/myPage/paymentList";
		
		String paging = myUtil.pagingUrl(current_page, total_page, listUrl);
		
		model.addAttribute("list", list);
		model.addAttribute("page", current_page);
		model.addAttribute("dataCount", dataCount);
		model.addAttribute("size", size);
		model.addAttribute("total_page", total_page);
		model.addAttribute("paging", paging);		
		
		return ".myPage.paymentList";
	}

	// AJAX - Text
	@GetMapping("detailView")
	public String detailView(@RequestParam Map<String, Object> paramMap,
			HttpSession session,
			Model model) throws Exception {
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		Payment dto = null;
		Destination orderDelivery = null;

		try {
			paramMap.put("memberIdx", info.getMemberIdx());
			
			// 구매 상세 정보
			dto = service.findByOrderDetail(paramMap);
			
			// 퍼처스 리스트(함께 구매한 상품 리스트)
			List<Payment> listBuy = service.listPurchase(paramMap);
			
			// 배송지 정보
			orderDelivery = service.findByOrderDelivery(paramMap);
			
			model.addAttribute("dto", dto);
			model.addAttribute("listBuy", listBuy);
			model.addAttribute("orderDelivery", orderDelivery);
			
		} catch (Exception e) {
		}
		
		return "myPage/orderDetailView"; 
	}
	
	// 구매 확정
	@RequestMapping("confirmation")
	public String confirmation(@RequestParam Map<String, Object> paramMap,
			@RequestParam String page,
			HttpSession session) throws Exception {
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		try {
			paramMap.put("detailState", 1); // 구매확정
			paramMap.put("stateMemo", "구매확정완료");
			paramMap.put("memberIdx", info.getMemberIdx());
			paramMap.put("userId", info.getUserId());
			
			service.updateOrderDetailState(paramMap);
			
		} catch (Exception e) {
		}
		
		return "redirect:/myPage/paymentList?page="+page; 
	}
	
	// 주문취소/반품/교환요청
	@PostMapping("orderDetailUpdate")
	public String orderDetailUpdate(@RequestParam Map<String, Object> paramMap,
			@RequestParam String page,
			HttpSession session) throws Exception {
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		try {
			paramMap.put("memberIdx", info.getMemberIdx());
			
			service.updateOrderDetailState(paramMap);
		} catch (Exception e) {
		}
		
		return "redirect:/myPage/paymentList?page="+page;
	}
	
	@GetMapping("updateOrderHistory")
	public String updateOrderHistory(@RequestParam long orderDetailNum,
			@RequestParam String page,
			HttpSession session) throws Exception {
		
		try {
			service.updateOrderHistory(orderDetailNum);
		} catch (Exception e) {
		}
		
		return "redirect:/myPage/paymentList?page="+page;
	}	
	
	// 장바구니 리스트
	@GetMapping("cart")
	public String listCart(HttpSession session,
			Model model) throws Exception {
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		List<Order> list = service.listCart(info.getUserId());
		
		model.addAttribute("list", list);
		
		return ".myPage.cart";
	}
	
	// 장바구니 저장
	@PostMapping("saveCart")
	public String saveCart(
			Order dto,
			HttpSession session) throws Exception {
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		try {
			dto.setUserId(info.getUserId());
			
			service.insertCart(dto);
			
		} catch (Exception e) {
		}
		
		return "redirect:/myPage/cart"; 
	}

	// 하나 상품 장바구니 비우기
	@GetMapping("deleteCart")
	public String deleteCart(
			@RequestParam long stockNum,
			HttpSession session) throws Exception {
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("gubun", "item");
			map.put("userId", info.getUserId());
			map.put("stockNum", stockNum);
			
			service.deleteCart(map);
			
		} catch (Exception e) {
		}
		return "redirect:/myPage/cart"; 
	}

	// 선택상품 장바구니 비우기
	@PostMapping("deleteListCart")
	public String deleteListCart(
			@RequestParam List<Long> nums,
			HttpSession session) throws Exception {
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("gubun", "list");
			map.put("userId", info.getUserId());
			map.put("list", nums);
			
			service.deleteCart(map);
			
		} catch (Exception e) {
		}
		
		return "redirect:/myPage/cart"; 
	}

	// 장바구니 모두 비우기
	@GetMapping("deleteCartAll")
	public String deleteCartAll(
			HttpSession session) throws Exception {
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("gubun", "all");
			map.put("userId", info.getUserId());
			
			service.deleteCart(map);
			
		} catch (Exception e) {
		}
		
		return "redirect:/myPage/cart";
	}
	
	// 마이페이지-리뷰/Q&A
	@GetMapping("review")
	public String review(
			@RequestParam(defaultValue = "review") String mode,
			Model model) throws Exception {
		
		model.addAttribute("mode", mode);
		return ".myPage.review";
	}
	
}
