package com.sp.app.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sp.app.common.MyUtil;
import com.sp.app.domain.Question;
import com.sp.app.domain.SessionInfo;
import com.sp.app.service.QuestionService;

@RestController // @Controller + @ResponseBody
@RequestMapping("/qna/*")
public class QuestionController {
	@Autowired
	private QuestionService service;
	
	@Autowired
	private MyUtil myUtil;
	
	// AJAX - JSON
	@PostMapping("write")
	public Map<String, Object> writeSubmit(Question dto,
			HttpSession session) throws Exception {
		
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "qna";
		
		String state = "true";
		try {
			
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			dto.setMemberIdx(info.getMemberIdx());
			
			service.insertQuestion(dto, pathname);
		} catch (Exception e) {
			state = "false";
		}
		
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("state", state);
		return model;
	}
	
	// AJAX - JSON
	@GetMapping("list")
	public Map<String, Object> list(
			@RequestParam long productNum,
			@RequestParam(value = "pageNo", defaultValue = "1") int current_page,
			HttpSession session) throws Exception {
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		Map<String, Object> model = new HashMap<String, Object>();
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			int size = 5;
			int dataCount = 0;
			
			map.put("productNum", productNum);
			
			dataCount = service.dataCount(map);
			int total_page = myUtil.pageCount(dataCount, size);
			if (current_page > total_page) {
				current_page = total_page;
			}

			int offset = (current_page - 1) * size;
			if(offset < 0) offset = 0;

			map.put("offset", offset);
			map.put("size", size);

			List<Question> list = service.listQuestion(map);
			for(Question dto : list) {
				if(dto.getSecret() == 1 && (info == null || (info.getMembership() < 50 && dto.getMemberIdx() != info.getMemberIdx()))) {
					dto.setQuestion("비밀글 입니다. <i class='bi bi-file-lock2'></i>");
					dto.setAnswer("");
					dto.setListFilename(null);
				}
			}
			
			String paging = myUtil.pagingFunc(current_page, total_page, "listQuestion");
			
			model.put("list", list);
			model.put("dataCount", dataCount);
			model.put("size", size);
			model.put("pageNo", current_page);
			model.put("paging", paging);
			model.put("total_page", total_page);
			
		} catch (Exception e) {
		}
		
		return model;
	}

	// AJAX - JSON : 마이페이지 - 내 Q&A
	@GetMapping("list2")
	public Map<String, Object> list2(
			@RequestParam(value = "pageNo", defaultValue = "1") int current_page,
			HttpSession session) throws Exception {
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		Map<String, Object> model = new HashMap<String, Object>();
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			int size = 5;
			int dataCount = 0;
			
			map.put("memberIdx", info.getMemberIdx());
			
			dataCount = service.dataCount2(map);
			int total_page = myUtil.pageCount(dataCount, size);
			if (current_page > total_page) {
				current_page = total_page;
			}

			int offset = (current_page - 1) * size;
			if(offset < 0) offset = 0;

			map.put("offset", offset);
			map.put("size", size);

			List<Question> list = service.listQuestion2(map);
			
			String paging = myUtil.pagingFunc(current_page, total_page, "listQuestion");
			
			model.put("list", list);
			model.put("dataCount", dataCount);
			model.put("size", size);
			model.put("pageNo", current_page);
			model.put("paging", paging);
			model.put("total_page", total_page);
			
		} catch (Exception e) {
		}
		
		return model;
	}

}
