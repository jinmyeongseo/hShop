package com.sp.app.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sp.app.domain.Order;
import com.sp.app.domain.UserPoint;
import com.sp.app.mapper.MyPageMapper;
import com.sp.app.mapper.OrderMapper;

@Service
public class OrderServiceImpl implements OrderService {
	@Autowired
	private OrderMapper mapper;

	@Autowired
	private MyPageMapper myPageMapper;
	
	private static AtomicLong count = new AtomicLong(0);
	
	@Override
	public String productOrderNumber() {
		// 상품 주문 번호 생성
		String result = "";
		
		try {
			Calendar cal = Calendar.getInstance();
			String y =String.format("%04d", cal.get(Calendar.YEAR));
			String m = String.format("%02d", (cal.get(Calendar.MONTH) + 1));
			String d = String.format("%03d", cal.get(Calendar.DATE) * 7);
			
			String preNumber = y + m + d;
			String savedPreNumber = "0";
			long savedLastNumber = 0;
			String maxOrderNumber = mapper.findByMaxOrderNumber();
			if(maxOrderNumber != null && maxOrderNumber.length() > 9) {
				savedPreNumber = maxOrderNumber.substring(0, 9);
				savedLastNumber = Long.parseLong(maxOrderNumber.substring(9));
			}
			
			long lastNumber = 1;
			if(! preNumber.equals(savedPreNumber)) {
				count.set(0);
				lastNumber = count.incrementAndGet();
			} else {
				lastNumber = count.incrementAndGet();
				
				if( savedLastNumber >= lastNumber )  {
					count.set(savedLastNumber);
					lastNumber = count.incrementAndGet();
				}
			}
			
			result = preNumber + String.format("%09d", lastNumber);
			
		} catch (Exception e) {
		}
		
		return result;
	}
	
	@Override
	public void insertOrder(Order dto) throws Exception {
		try {
			// 주문 정보 저장
			mapper.insertOrder(dto);

			// 결재 내역 저장
			mapper.insertPayDetail(dto);
			
			// 상세 주문 정보 및 주문 상태 저장
			for(int i=0; i < dto.getProductNums().size(); i++) {
				dto.setProductNum(dto.getProductNums().get(i));
				dto.setQty(dto.getBuyQtys().get(i));
				if(dto.getDetailNums().get(i) != 0) {
					dto.setDetailNum(dto.getDetailNums().get(i));
				}
				if(dto.getDetailNums2().get(i) != 0) {
					dto.setDetailNum2(dto.getDetailNums2().get(i));
				}
				dto.setProductMoney(dto.getProductMoneys().get(i));
				dto.setPrice(dto.getPrices().get(i));
				dto.setSalePrice(dto.getSalePrices().get(i));
				dto.setSavedMoney(dto.getSavedMoneys().get(i));

				// 상세 주문 정보 저장
				mapper.insertOrderDetail(dto);
				
				// 판매 개수만큼 재고 감소 -----
				dto.setStockNum(dto.getStockNums().get(i));
				mapper.updateProductStockDec(dto);
			}
			
			// 사용 포인트 저장(포인트 적립은 구매 확정에서)
			if(dto.getUsedSaved() > 0) {
				LocalDateTime now = LocalDateTime.now();
				String dateTime = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
				
				UserPoint up = new UserPoint();
				up.setUserId(dto.getUserId());
				up.setOrderNum(dto.getOrderNum());
				up.setPoint(-dto.getUsedSaved());
				up.setClassify(2); // 1:적립, 2:사용, 3:소멸, 4:주문취소/판매취소
				up.setBase_date(dateTime);
				up.setMemo("구매");
				mapper.insertUserPoint(up);
			}
			
			// 배송지 저장 
			mapper.insertOrderDelivery(dto);
			
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}
	
	@Override
	public Order findByOrderDetail(long orderDetailNum) {
		Order dto = null;
		
		try {
			dto = mapper.findByOrderDetail(orderDetailNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}
	
	public UserPoint findByUserPoint(String userId) {
		UserPoint dto = null;
		
		try {
			dto = mapper.findByUserPoint(userId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override
	public void deleteCart(Map<String, Object> map) throws Exception{
		try {
			myPageMapper.deleteCart(map);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}

	@Override
	public List<Order> listOrderProduct(List<Map<String, Long>> list) {
		List<Order> listProduct = null;
		
		try {
			listProduct = mapper.listOrderProduct(list);
			for(Order dto : listProduct) {
				int discountPrice = 0;
				if(dto.getDiscountRate() > 0) {
					discountPrice = (int)(dto.getPrice() * (dto.getDiscountRate()/100.0));
					dto.setDiscountPrice(discountPrice);
				}
				
				dto.setSalePrice(dto.getPrice() - discountPrice);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return listProduct;
	}

	@Override
	public Order findByProduct(long productNum) {
		Order dto = null;
		
		try {
			dto = mapper.findByProduct(productNum); 
			
			if(dto != null) {
				int discountPrice = 0;
				if(dto.getDiscountRate() > 0) {
					discountPrice = (int)(dto.getPrice() * (dto.getDiscountRate()/100.0));
					dto.setDiscountPrice(discountPrice);
				}
				
				dto.setSalePrice(dto.getPrice() - discountPrice);
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}
	
	@Override
	public Order findByOptionDetail(long detailNum) {
		Order dto = null;
		
		try {
			dto = mapper.findByOptionDetail(detailNum); 
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override
	public List<Order> listOptionDetail(List<Long> detailNums) {
		List<Order> listOptionDetail = null;
		
		try {
			listOptionDetail = mapper.listOptionDetail(detailNums);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return listOptionDetail;
	}
}
