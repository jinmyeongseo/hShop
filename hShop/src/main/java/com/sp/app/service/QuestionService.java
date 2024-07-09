package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.domain.Question;

public interface QuestionService {
	public void insertQuestion(Question dto, String pathname) throws Exception;
	
	public int dataCount(Map<String, Object> map);
	public List<Question>listQuestion(Map<String, Object> map);
	
	public int dataCount2(Map<String, Object> map);
	public List<Question>listQuestion2(Map<String, Object> map);
	
	public void updateQuestion(Question dto) throws Exception;
	
	public void deleteQuestion(long num, String pathname) throws Exception;
}
