package com.sp.app.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.domain.Review;
import com.sp.app.domain.Summary;

@Mapper
public interface ReviewMapper {
	public void insertReview(Review dto) throws SQLException;
	public void insertReviewFile(Review dto) throws SQLException;
	
	public Summary findByReviewSummary(Map<String, Object> map);
	public List<Review>listReview(Map<String, Object> map);
	
	public int dataCount2(Map<String, Object> map);
	public List<Review>listReview2(Map<String, Object> map);
	
	public void updateReview(Review dto) throws SQLException; 
	
	public List<Review>listReviewFile(long num);
	public void deleteReview(long num) throws SQLException;
}
