package com.sp.app.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.FileManager;
import com.sp.app.domain.Review;
import com.sp.app.domain.Summary;
import com.sp.app.mapper.ReviewMapper;

@Service
public class ReviewServiceImpl implements ReviewService {
	@Autowired
	private ReviewMapper mapper;
	
	@Autowired
	private FileManager fileManager;
	
	@Override
	public void insertReview(Review dto, String pathname) throws Exception {
		try {
			mapper.insertReview(dto);
			
			if( ! dto.getSelectFile().isEmpty() ) {
				for(MultipartFile mf : dto.getSelectFile()) {
					String filename = fileManager.doFileUpload(mf, pathname);
					if(filename != null) {
						dto.setFilename(filename);
						
						mapper.insertReviewFile(dto);
					}
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}

	@Override
	public void deleteReview(long num, String pathname) throws Exception {
		try {
			List<Review> listFile = mapper.listReviewFile(num);
			if (listFile != null) {
				for (Review dto : listFile) {
					fileManager.doFileDelete(dto.getFilename(), pathname);
				}
			}
			
			mapper.deleteReview(num);
			
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}

	@Override
	public Summary findByReviewSummary(Map<String, Object> map) {
		Summary dto = null;
		
		try {
			dto = mapper.findByReviewSummary(map);

			dto.setScoreRate1((int)((double)dto.getScore1()/dto.getCount() * 100 + 0.5));
			dto.setScoreRate2((int)((double)dto.getScore2()/dto.getCount() * 100 + 0.5));
			dto.setScoreRate3((int)((double)dto.getScore3()/dto.getCount() * 100 + 0.5));
			dto.setScoreRate4((int)((double)dto.getScore4()/dto.getCount() * 100 + 0.5));
			dto.setScoreRate5((int)((double)dto.getScore5()/dto.getCount() * 100 + 0.5));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override
	public List<Review> listReview(Map<String, Object> map) {
		List<Review> list = null;
		
		try {
			list = mapper.listReview(map);
			
			String s;
			for (Review dto : list) {
				if(dto.getFilename() != null) {
					dto.setListFilename(dto.getFilename().split(",")); 
				}
				
				s = dto.getUserName().substring(0, 1);
				if(dto.getUserName().length() <= 2) {
					s += "*";
				} else {
					s += dto.getUserName().substring(2, dto.getUserName().length()).replaceAll(".", "*");
				}
				s += dto.getUserName().substring(dto.getUserName().length()-1);
				dto.setUserName(s);
				
				dto.setReview(dto.getReview().replaceAll("\n", "<br>"));
				
				if(dto.getAnswer() != null) {
					dto.setAnswer(dto.getAnswer().replaceAll("\n", "<br>"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public int dataCount2(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.dataCount2(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	@Override
	public List<Review> listReview2(Map<String, Object> map) {
		List<Review> list = null;
		
		try {
			list = mapper.listReview2(map);
			
			for (Review dto : list) {
				if(dto.getFilename() != null) {
					dto.setListFilename(dto.getFilename().split(",")); 
				}
				
				dto.setReview(dto.getReview().replaceAll("\n", "<br>"));
				
				if(dto.getAnswer() != null) {
					dto.setAnswer(dto.getAnswer().replaceAll("\n", "<br>"));
				}
			}	
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public void updateReview(Review dto) throws Exception {
		try {
			mapper.updateReview(dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

}
