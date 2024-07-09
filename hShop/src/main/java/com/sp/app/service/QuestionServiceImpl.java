package com.sp.app.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.FileManager;
import com.sp.app.domain.Question;
import com.sp.app.mapper.QuestionMapper;

@Service
public class QuestionServiceImpl implements QuestionService {
	@Autowired
	private QuestionMapper mapper;
	
	@Autowired
	private FileManager fileManager;
	
	@Override
	public void insertQuestion(Question dto, String pathname) throws Exception {
		try {
			mapper.insertQuestion(dto);
			
			if( ! dto.getSelectFile().isEmpty() ) {
				for(MultipartFile mf : dto.getSelectFile()) {
					String filename = fileManager.doFileUpload(mf, pathname);
					if(filename != null) {
						dto.setFilename(filename);
						
						mapper.insertQuestionFile(dto);
					}
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}

	@Override
	public void deleteQuestion(long num, String pathname) throws Exception {
		try {
			List<Question> listFile = mapper.listQuestionFile(num);
			if (listFile != null) {
				for (Question dto : listFile) {
					fileManager.doFileDelete(dto.getFilename(), pathname);
				}
			}
			
			mapper.deleteQuestion(num);
			
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}

	@Override
	public int dataCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.dataCount(map); 
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	@Override
	public List<Question> listQuestion(Map<String, Object> map) {
		List<Question> list = null;
		
		try {
			list = mapper.listQuestion(map);
			
			String s;
			for (Question dto : list) {
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
				
				dto.setQuestion(dto.getQuestion().replaceAll("\n", "<br>"));
				
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
	public List<Question> listQuestion2(Map<String, Object> map) {
		List<Question> list = null;
		
		try {
			list = mapper.listQuestion2(map);
			for (Question dto : list) {
				if(dto.getFilename() != null) {
					dto.setListFilename(dto.getFilename().split(",")); 
				}
				
				dto.setQuestion(dto.getQuestion().replaceAll("\n", "<br>"));
				
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
	public void updateQuestion(Question dto) throws Exception {
		try {
			mapper.updateQuestion(dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}

}
