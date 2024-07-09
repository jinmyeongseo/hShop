package com.sp.app.admin.controller;

import java.io.File;
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
import com.sp.app.domain.Question;
import com.sp.app.domain.Review;
import com.sp.app.domain.SessionInfo;
import com.sp.app.service.QuestionService;
import com.sp.app.service.ReviewService;

@Controller
@RequestMapping("/admin/customer/*")
public class CustomerManageController {
	@Autowired
	private MyUtil myUtil;
	
	@Autowired
	private ReviewService reviewService;
	
	@Autowired
	private QuestionService questionService;
	
	@GetMapping("review")
	public String reviewList(@RequestParam(value = "page", defaultValue = "1") int current_page,
			@RequestParam(defaultValue = "1") int mode,
			HttpServletRequest req,
			Model model) throws Exception {
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			int size = 5;
			int dataCount = 0;
			
			map.put("mode", mode);
			dataCount = reviewService.dataCount2(map);
			
			int total_page = myUtil.pageCount(dataCount, size);
			if (current_page > total_page) {
				current_page = total_page;
			}

			int offset = (current_page - 1) * size;
			if(offset < 0) offset = 0;

			map.put("offset", offset);
			map.put("size", size);

			List<Review> list = reviewService.listReview2(map);
			
			String cp = req.getContextPath();
			String listUrl = cp + "/admin/customer/review";
			if(mode != 1) {
				listUrl += "?mode=" + mode;
			}
			String paging = myUtil.paging(current_page, total_page, listUrl);
			
			model.addAttribute("list", list);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("size", size);
			model.addAttribute("page", current_page);
			model.addAttribute("paging", paging);
			model.addAttribute("total_page", total_page);
			model.addAttribute("mode", mode);
			
		} catch (Exception e) {
		}
		
		return ".admin.customer.review";
	}

	@PostMapping("review/answer")
	public String reviewAnswer(Review dto, @RequestParam String page,
			@RequestParam int mode) throws Exception {
		
		try {
			reviewService.updateReview(dto);
		} catch (Exception e) {
		}
		
		String url = "redirect:/admin/customer/review?";
		if(mode == 1) {
			url += "page=" + page;
		} else {
			url += "mode=" + mode + "&page=" + page;
		}
		return url;
	}
	
	@GetMapping("review/delete")
	public String reviewDelete(@RequestParam long num,
			@RequestParam String page,
			@RequestParam int mode,
			HttpSession session) throws Exception {
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "qna";
		
		try {
			reviewService.deleteReview(num, pathname);
		} catch (Exception e) {
		}
		
		String url = "redirect:/admin/customer/review?";
		if(mode == 1) {
			url += "page=" + page;
		} else {
			url += "mode=" + mode + "&page=" + page;
		}
		return url;

	}

	@GetMapping("question")
	public String questionList(@RequestParam(value = "page", defaultValue = "1") int current_page,
			@RequestParam(defaultValue = "1") int mode,
			HttpServletRequest req,
			Model model) throws Exception {
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			int size = 5;
			int dataCount = 0;
			
			map.put("mode", mode);
			dataCount = questionService.dataCount2(map);
			int total_page = myUtil.pageCount(dataCount, size);
			if (current_page > total_page) {
				current_page = total_page;
			}

			int offset = (current_page - 1) * size;
			if(offset < 0) offset = 0;

			map.put("offset", offset);
			map.put("size", size);

			List<Question> list = questionService.listQuestion2(map);
			
			String cp = req.getContextPath();
			String listUrl = cp + "/admin/customer/question";
			if(mode != 1) {
				listUrl += "?mode=" + mode;
			}
			String paging = myUtil.paging(current_page, total_page, listUrl);
			
			model.addAttribute("list", list);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("size", size);
			model.addAttribute("page", current_page);
			model.addAttribute("paging", paging);
			model.addAttribute("total_page", total_page);
			model.addAttribute("mode", mode);
			
		} catch (Exception e) {
		}
		
		return ".admin.customer.question";
	}

	@PostMapping("question/answer")
	public String questionAnswer(Question dto, @RequestParam String page, 
			@RequestParam int mode,
			HttpSession session) throws Exception {
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		try {
			dto.setAnswerId(info.getUserId());
			questionService.updateQuestion(dto);
		} catch (Exception e) {
		}
		
		String url = "redirect:/admin/customer/question?";
		if(mode == 1) {
			url += "page=" + page;
		} else {
			url += "mode=" + mode + "&page=" + page;
		}
		return url;
	}

	@GetMapping("question/delete")
	public String questionDelete(@RequestParam long num,
			@RequestParam String page,
			@RequestParam int mode,
			HttpSession session) throws Exception {
		
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "qna";
		
		try {
			questionService.deleteQuestion(num, pathname);
		} catch (Exception e) {
		}
		
		String url = "redirect:/admin/customer/question?";
		if(mode == 1) {
			url += "page=" + page;
		} else {
			url += "mode=" + mode + "&page=" + page;
		}
		return url;
	}
}
