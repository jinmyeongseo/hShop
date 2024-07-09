package com.sp.app.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sp.app.domain.Destination;
import com.sp.app.domain.Order;
import com.sp.app.domain.Payment;
import com.sp.app.domain.UserPoint;
import com.sp.app.mapper.MyPageMapper;
import com.sp.app.mapper.OrderMapper;
import com.sp.app.state.OrderState;

@Service
public class MyPageServiceImpl implements MyPageService {
	@Autowired
	private MyPageMapper mapper;

	@Autowired
	private OrderMapper orderMapper;
	
	@Override
	public int countPayment(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.countPayment(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	@Override
	public List<Payment> listPayment(Map<String, Object> map) {
		List<Payment> list = null;
		
		try {
			// OrderState.ORDERSTATEINFO : 주문상태 정보
			// OrderState.DETAILSTATEINFO : 주문상세상태 정보
			
			String productState;
			
			list = mapper.listPayment(map);

			Date endDate = new Date();
			long gap;
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			for(Payment dto : list) {
				dto.setOrderDate(dto.getOrderDate().replaceAll("-", ".").substring(5,10));
				dto.setOrderStateInfo(OrderState.ORDERSTATEINFO[dto.getOrderState()]);
				dto.setDetailStateInfo(OrderState.DETAILSTATEINFO[dto.getDetailState()]);
				
				productState = OrderState.ORDERSTATEINFO[dto.getOrderState()];
				if(dto.getDetailState() > 0) {
					productState = OrderState.DETAILSTATEINFO[dto.getDetailState()];
				}
				dto.setStateProduct(productState);
				
				// 배송 완료후 지난 일자
				if(dto.getOrderState() == 5 && dto.getStateDate() != null) {
					Date beginDate = formatter.parse(dto.getStateDate());
					gap = (endDate.getTime() - beginDate.getTime()) / (24 * 60 * 60 * 1000);
					dto.setAfterDelivery(gap);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	// 퍼처스(구매) 리스트
	public List<Payment> listPurchase(Map<String, Object> map) {
		List<Payment> list = null;
		
		try {
			list = mapper.listPurchase(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public Payment findByOrderDetail(Map<String, Object> map) {
		Payment dto = null;
		
		try {
			dto = mapper.findByOrderDetail(map);
			if(dto != null) {
				dto.setDetailStateInfo(OrderState.DETAILSTATEMANAGER[dto.getDetailState()]);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}
	
	@Override
	public Destination findByOrderDelivery(Map<String, Object> map) {
		Destination dto = null;
		
		try {
			dto = mapper.findByOrderDelivery(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}
	
	@Override
	public void updateOrderDetailState(Map<String, Object> map) throws Exception {
		try {
			// orderDetail 테이블 상태 변경
			mapper.updateOrderDetailState(map);
			
			// detailStateInfo 테이블에 상태 변경 내용 및 날짜 저장
			mapper.insertDetailStateInfo(map);
			
			int detailState = Optional.ofNullable((Integer)map.get("detailState")).orElse(0);
			if(detailState == 1) {
				// 구매 확정인 경우 적립금 추가
				long orderDetailNum = Long.parseLong((String)map.get("orderDetailNum"));
				String userId = (String)map.get("userId");
				
				Order order = orderMapper.findByOrderDetail(orderDetailNum);
				
				UserPoint up = new UserPoint();
				up.setUserId(userId);
				up.setOrderNum(order.getOrderNum());
				up.setPoint(order.getSavedMoney());
				up.setClassify(1); // 1:적립, 2:사용, 3:소멸, 4:주문취소/판매취소
				up.setBase_date(order.getOrderDate());
				up.setMemo("구매확정");
				orderMapper.insertUserPoint(up);
			}

		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
	
	@Override
	public void updateOrderHistory(long orderDetailNum) throws Exception {
		try {
			mapper.updateOrderHistory(orderDetailNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void insertCart(Order dto) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", dto.getUserId());
		
		try {
			for(int i = 0; i < dto.getStockNums().size(); i++) {
				dto.setProductNum(dto.getProductNums().get(i));
				dto.setStockNum(dto.getStockNums().get(i));
				dto.setQty(dto.getBuyQtys().get(i));
				
				map.put("stockNum", dto.getStockNums().get(i));
				if(mapper.findByCartId(map) == null) {
					mapper.insertCart(dto);
				} else {
					mapper.updateCart(dto);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public List<Order> listCart(String userId) {
		List<Order> list = null;
		
		try {
			list = mapper.listCart(userId);
			
			for(Order dto : list) {
				int discountPrice = 0;
				if(dto.getDiscountRate() > 0) {
					discountPrice = (int)(dto.getPrice() * (dto.getDiscountRate()/100.0));
					dto.setDiscountPrice(discountPrice);
				}
				
				dto.setSalePrice(dto.getPrice() - discountPrice);
				dto.setProductMoney(dto.getSalePrice() * dto.getQty());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public void deleteCart(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteCart(map);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
}
