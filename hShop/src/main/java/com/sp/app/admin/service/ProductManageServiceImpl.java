package com.sp.app.admin.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.admin.domain.ProductManage;
import com.sp.app.admin.domain.ProductStockManage;
import com.sp.app.admin.mapper.ProductManageMapper;
import com.sp.app.common.FileManager;

@Service
public class ProductManageServiceImpl implements ProductManageService {
	@Autowired
	private ProductManageMapper mapper;
	
	@Autowired
	private FileManager fileManager;
	
	@Override
	public void insertProduct(ProductManage dto, String pathname) throws Exception {
		try {
			// 썸네일 이미지
			String filename = fileManager.doFileUpload(dto.getThumbnailFile(), pathname);
			dto.setThumbnail(filename);
			
			// 상품 저장
			long productNum = mapper.productSeq();
			
			dto.setProductNum(productNum);
			mapper.insertProduct(dto);
			
			// 추가 이미지 저장
			if(! dto.getAddFiles().isEmpty()) {
				for(MultipartFile mf : dto.getAddFiles()) {
					filename = fileManager.doFileUpload(mf, pathname);
					if(filename == null) {
						continue;
					}
					dto.setFilename(filename);
					
					mapper.insertProductFile(dto);
				}
			}
			
			// 옵션추가
			if(dto.getOptionCount() > 0) {
				insertProductOption(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void updateProduct(ProductManage dto, String pathname) throws Exception {
		try {
			// 썸네일 이미지
			String filename = fileManager.doFileUpload(dto.getThumbnailFile(), pathname);
			if(filename != null) {
				// 이전 파일 지우기
				if (dto.getThumbnail().length() != 0) {
					fileManager.doFileDelete(dto.getThumbnail(), pathname);
				}
				
				dto.setThumbnail(filename);
			}
			
			// 상품 수정
			mapper.updateProduct(dto);
			
			// 추가 이미지
			if(! dto.getAddFiles().isEmpty()) {
				for(MultipartFile mf : dto.getAddFiles()) {
					filename = fileManager.doFileUpload(mf, pathname);
					if(filename == null) {
						continue;
					}
					dto.setFilename(filename);
					
					mapper.insertProductFile(dto);
				}
			}
			
			// 옵션 수정
			updateProductOption(dto);
		
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
	 
	private void insertProductOption(ProductManage dto) throws Exception {
		try {
			long optionNum = 0, optionNum2 = 0;
			long detailNum;
			
			// 옵션1 추가 -----
			if(dto.getOptionCount() > 0) {
				optionNum = mapper.optionSeq();
				dto.setOptionNum(optionNum);
				dto.setParentOption(null);
				mapper.insertProductOption(dto);
				
				// 옵션1 값 추가
				dto.setDetailNums(new ArrayList<Long>());
				for(String optionValue : dto.getOptionValues()) {
					detailNum = mapper.detailSeq(); 
					dto.setDetailNum(detailNum);
					dto.setOptionValue(optionValue);
	
					mapper.insertOptionDetail(dto);
					
					dto.getDetailNums().add(detailNum);
				}
			}
			
			// 옵션2 추가 -----
			if(dto.getOptionCount() > 1) {
				optionNum2 = mapper.optionSeq();
				dto.setOptionNum(optionNum2);
				dto.setOptionName(dto.getOptionName2());
				dto.setParentOption(optionNum);
				mapper.insertProductOption(dto);
				
				// 옵션 2 값 추가
				dto.setDetailNums2(new ArrayList<Long>());
				for(String optionValue2 : dto.getOptionValues2()) {
					detailNum = mapper.detailSeq(); 
					dto.setDetailNum(detailNum);
					dto.setOptionValue(optionValue2);
					mapper.insertOptionDetail(dto);
					
					dto.getDetailNums2().add(detailNum);
				}
			}
		} catch (Exception e) {
			throw e;
		}
	}

	private void updateProductOption(ProductManage dto) throws Exception {
		try {
			if(dto.getOptionCount() == 0) {
				// 기존 옵션1, 옵션2 삭제
				if(dto.getPrevOptionNum2() != 0) {
					mapper.deleteOptionDetail2(dto.getPrevOptionNum2());
					mapper.deleteProductOption(dto.getPrevOptionNum2());
				}
				
				if(dto.getPrevOptionNum() != 0) {
					mapper.deleteOptionDetail2(dto.getPrevOptionNum());
					mapper.deleteProductOption(dto.getPrevOptionNum());
				}
				
				return;
			} else if(dto.getOptionCount() == 1) {
				// 기존 옵션 2 삭제
				if(dto.getPrevOptionNum2() != 0) {
					mapper.deleteOptionDetail2(dto.getPrevOptionNum2());
					mapper.deleteProductOption(dto.getPrevOptionNum2());
				}
			}
			
			long detailNum, parentNum;
			
			// 옵션1 -----
			// 옵션1이 없는 상태에서 옵션1을 추가한 경우
			if(dto.getOptionNum() == 0) {
				insertProductOption(dto);
				return;
			}
			// 옵션1이 존재하는 경우 옵션1 수정
			mapper.updateProductOption(dto);
			
			// 기존 옵션1 옵션값 수정
			int size = dto.getDetailNums().size();
			for(int i = 0; i < size; i++) {
				dto.setDetailNum(dto.getDetailNums().get(i));
				dto.setOptionValue(dto.getOptionValues().get(i));
				mapper.updateOptionDetail(dto);
			}

			// 새로운 옵션1 옵션값 추가
			dto.setDetailNums(new ArrayList<Long>());
			for(int i = size; i < dto.getOptionValues().size(); i++) {
				detailNum = mapper.detailSeq(); 
				dto.setDetailNum(detailNum);
				dto.setOptionValue(dto.getOptionValues().get(i));
				mapper.insertOptionDetail(dto);
				
				dto.getDetailNums().add(detailNum);
			}

			// 옵션2 -----
			if(dto.getOptionCount() > 1) {
				//  옵션2가 없는 상태에서 옵션2를 추가한 경우
				parentNum = dto.getOptionNum(); // 옵션1 옵션번호 
				if(dto.getOptionNum2() == 0) {
					long optionNum2 = mapper.optionSeq();
					dto.setOptionNum(optionNum2);
					dto.setOptionName(dto.getOptionName2());
					dto.setParentOption(parentNum);
					mapper.insertProductOption(dto);
					
					// 옵션 2 값 추가
					dto.setDetailNums2(new ArrayList<Long>());
					for(String optionValue2 : dto.getOptionValues2()) {
						detailNum = mapper.detailSeq(); 
						dto.setDetailNum(detailNum);
						dto.setOptionValue(optionValue2);
						mapper.insertOptionDetail(dto);
						
						dto.getDetailNums2().add(detailNum);
					}
					
					return;
				} 
				
				// 옵션2 가 존재하는 경우 옵션2 수정
				dto.setOptionNum(dto.getOptionNum2());
				dto.setOptionName(dto.getOptionName2());
				mapper.updateProductOption(dto);
				
				// 기존 옵션2 옵션값 수정
				int size2 = dto.getDetailNums2().size();
				for(int i = 0; i < size2; i++) {
					dto.setDetailNum(dto.getDetailNums2().get(i));
					dto.setOptionValue(dto.getOptionValues2().get(i));
					mapper.updateOptionDetail(dto);
				}
	
				// 새로운 옵션2 옵션값 추가
				dto.setDetailNums2(new ArrayList<Long>());
				for(int i = size2; i < dto.getOptionValues2().size(); i++) {
					detailNum = mapper.detailSeq(); 
					dto.setDetailNum(detailNum);
					dto.setOptionValue(dto.getOptionValues2().get(i));
					mapper.insertOptionDetail(dto);
					
					dto.getDetailNums2().add(detailNum);
				}
			}
		} catch (Exception e) {
			throw e;
		}
	}
	
	@Override
	public void deleteProduct(long productNum, String pathname) throws Exception {
		try {
			// 파일 삭제(thumbnail)

			// 추가 파일 삭제
			
			// 재고 삭제

			// 옵션2 삭제
			
			// 옵션1 삭제
			
			// 상품 삭제
			// mapper.deleteProduct(productNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void deleteProductFile(long fileNum, String pathname) throws Exception {
		try {
			if (pathname != null) {
				fileManager.doFileDelete(pathname);
			}

			mapper.deleteProductFile(fileNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
	
	@Override
	public void deleteOptionDetail(long detailNum) throws Exception {
		try {
			mapper.deleteOptionDetail(detailNum);
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
	public List<ProductManage> listProduct(Map<String, Object> map) {
		 List<ProductManage> list = null;
		 
		 try {
			list = mapper.listProduct(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		 
		return list;
	}

	@Override
	public ProductManage findById(long productNum) {
		ProductManage dto = null;
		
		try {
			dto = mapper.findById(productNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override
	public ProductManage findByPrev(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ProductManage findByNext(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ProductManage> listProductFile(long productNum) {
		List<ProductManage> list = null;
		
		try {
			list = mapper.listProductFile(productNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public List<ProductManage> listProductOption(long productNum) {
		List<ProductManage> list = null;
		
		try {
			list = mapper.listProductOption(productNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public List<ProductManage> listOptionDetail(long optionNum) {
		List<ProductManage> list = null;
		
		try {
			list = mapper.listOptionDetail(optionNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	@Override
	public ProductManage findByCategory(long categoryNum) {
		ProductManage dto = null;
		
		try {
			dto = mapper.findByCategory(categoryNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override
	public List<ProductManage> listCategory() {
		List<ProductManage> list = null;
		
		try {
			list = mapper.listCategory();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	@Override
	public List<ProductManage> listSubCategory(long parentNum) {
		List<ProductManage> list = null;
		
		try {
			list = mapper.listSubCategory(parentNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	@Override
	public List<ProductStockManage> listProductStock(Map<String, Object> map) {
		List<ProductStockManage> list = null;
		
		try {
			// 상세 옵션별 재고 현황 -----
			list = mapper.listProductStock(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public void updateProductStock(ProductStockManage dto) throws Exception{
		try {
			// 상세 옵션별 재고 추가 또는 변경 -----
			for(int idx = 0; idx < dto.getStockNums().size(); idx++) {
				dto.setStockNum(dto.getStockNums().get(idx));
				if(dto.getDetailNums() != null && dto.getDetailNums().get(idx) != 0) {
					dto.setDetailNum(dto.getDetailNums().get(idx));
				}
				if(dto.getDetailNums2() != null && dto.getDetailNums2().get(idx) != 0) {
					dto.setDetailNum2(dto.getDetailNums2().get(idx));
				}
				dto.setTotalStock(dto.getTotalStocks().get(idx));
				
				if(dto.getStockNum() == 0) {
					mapper.insertProductStock(dto);
				} else {
					mapper.updateProductStock(dto);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
}
