package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.domain.Review;
import com.sp.app.domain.Summary;

public interface ReviewService {
	public void insertReview(Review dto, String pathname) throws Exception;
	
	public Summary findByReviewSummary(Map<String, Object> map);
	public List<Review>listReview(Map<String, Object> map);
	
	public int dataCount2(Map<String, Object> map);
	public List<Review>listReview2(Map<String, Object> map);
	
	public void updateReview(Review dto) throws Exception;
	
	public void deleteReview(long num, String pathname) throws Exception;
}
