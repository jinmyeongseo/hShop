package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sp.app.admin.domain.SpecialsDetailManage;
import com.sp.app.admin.domain.SpecialsManage;
import com.sp.app.admin.mapper.SpecialsManageMapper;
import com.sp.app.common.FileManager;

@Service
public class SpecialsManageServiceImpl implements SpecialsManageService {
	@Autowired
	private SpecialsManageMapper mapper;

	@Autowired
	private FileManager fileManager;
	
	@Override
	public void insertSpecials(SpecialsManage dto, String pathname) throws Exception {
		try {
			dto.setStartDate(dto.getSday() + " " + dto.getStime() + ":00");
			dto.setEndDate(dto.getEday() + " " + dto.getEtime() + ":00");
			
			String filename = fileManager.doFileUpload(dto.getSelectFile(), pathname);
			dto.setImageFilename(filename);
			
			mapper.insertSpecials(dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void updateSpecials(SpecialsManage dto, String pathname) throws Exception {
		try {
			dto.setStartDate(dto.getSday() + " " + dto.getStime() + ":00");
			dto.setEndDate(dto.getEday() + " " + dto.getEtime() + ":00");
			
			String filename = fileManager.doFileUpload(dto.getSelectFile(), pathname);
			if (filename != null) {
				// 이전 파일 지우기
				if (dto.getImageFilename().length() != 0) {
					fileManager.doFileDelete(dto.getImageFilename(), pathname);
				}

				dto.setImageFilename(filename);
			}			
			
			mapper.updateSpecials(dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void deleteSpecials(long specialNum, String pathname) throws Exception {
		try {
			if (pathname != null) {
				fileManager.doFileDelete(pathname);
			}

			mapper.deleteSpecials(specialNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public int dataCountSpecials(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.dataCountSpecials(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	@Override
	public List<SpecialsManage> listSpecials(Map<String, Object> map) {
		 List<SpecialsManage> list = null;
		 
		 try {
			list = mapper.listSpecials(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		 
		return list;
	}

	@Override
	public SpecialsManage findById(long specialNum) {
		SpecialsManage dto = null;
		
		try {
			dto = mapper.findById(specialNum);
			if(dto != null) {
				dto.setSday(dto.getStartDate().substring(0, 10));
				dto.setStime(dto.getStartDate().substring(11));
				
				dto.setEday(dto.getEndDate().substring(0, 10));
				dto.setEtime(dto.getEndDate().substring(11));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override
	public void insertSpecialsDetail(SpecialsDetailManage dto) throws Exception {
		try {
			mapper.insertSpecialsDetail(dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void updateSpecialsDetail(SpecialsDetailManage dto) throws Exception {
		try {
			mapper.updateSpecialsDetail(dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
	
	@Override
	public void deleteSpecialsDetail(long detailNum) throws Exception {
		try {
			mapper.deleteSpecialsDetail(detailNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public int dataCountDetail(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.dataCountDetail(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	@Override
	public List<SpecialsDetailManage> listSpecialsDetail(Map<String, Object> map) {
		 List<SpecialsDetailManage> list = null;
		 
		 try {
			list = mapper.listSpecialsDetail(map);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	@Override
	public List<SpecialsDetailManage> specialsProductSearch(Map<String, Object> map) {
		 List<SpecialsDetailManage> list = null;
		 
		 try {
			list = mapper.specialsProductSearch(map);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}
}
