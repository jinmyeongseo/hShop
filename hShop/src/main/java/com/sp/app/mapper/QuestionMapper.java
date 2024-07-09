package com.sp.app.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.domain.Question;

@Mapper
public interface QuestionMapper {
	public void insertQuestion(Question dto) throws SQLException;
	public void insertQuestionFile(Question dto) throws SQLException;
	
	public int dataCount(Map<String, Object> map);
	public List<Question>listQuestion(Map<String, Object> map);
	
	public int dataCount2(Map<String, Object> map);
	public List<Question>listQuestion2(Map<String, Object> map);
	
	public void updateQuestion(Question dto) throws SQLException;

	public List<Question>listQuestionFile(long num);
	public void deleteQuestion(long num) throws SQLException;
}
