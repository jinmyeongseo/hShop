package com.sp.app.admin.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sp.app.admin.domain.OrderDetailManage;
import com.sp.app.admin.domain.OrderManage;
import com.sp.app.admin.mapper.OrderManageMapper;
import com.sp.app.domain.UserPoint;
import com.sp.app.mapper.OrderMapper;
import com.sp.app.state.OrderState;

@Service
public class OrderStatusManageServiceImpl implements OrderStatusManageService {
	@Autowired
	private OrderManageMapper mapper;
	
	@Autowired
	private OrderMapper orderMapper;
	
	@Override
	public int orderCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.orderCount(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	@Override
	public List<OrderManage> listOrder(Map<String, Object> map) {
		List<OrderManage> list = null;

		// OrderState.ORDERSTATEINFO : 주문상태 정보
		// OrderState.DETAILSTATEMANAGER : 주문상세상태 정보(관리자)
		
		try {
			list = mapper.listOrder(map);
			for(OrderManage dto : list) {
				dto.setOrderStateInfo(OrderState.ORDERSTATEINFO[dto.getOrderState()]);
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	@Override
	public OrderManage findById(String orderNum) {
		OrderManage dto = null;
		
		// OrderState.ORDERSTATEINFO : 주문상태 정보
		
		try {
			dto = mapper.findById(orderNum);
			if(dto != null) {
				dto.setOrderStateInfo(OrderState.ORDERSTATEINFO[dto.getOrderState()]);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override
	public List<OrderDetailManage> orderDetails(String orderNum) {
		List<OrderDetailManage> list = null;

		// OrderState.DETAILSTATEMANAGER : 주문상세상태 정보(관리자)
		
		try {
			list = mapper.findByOrderDetails(orderNum);
			for(OrderDetailManage dto : list) {
				dto.setDetailStateInfo(OrderState.DETAILSTATEMANAGER[dto.getDetailState()]);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public int orderDetailCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.orderDetailCount(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	@Override
	public List<OrderDetailManage> listOrderDetail(Map<String, Object> map) {
		List<OrderDetailManage> list = null;
		
		try {
			list = mapper.listOrderDetail(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public void updateOrder(String mode, Map<String, Object> map) throws Exception {
		try {
			if(mode.equals("state")) {
				mapper.updateOrderState(map);
			} else if(mode.equals("invoiceNumber")) { // 송장번호 등록
				mapper.updateOrderInvoiceNumber(map);
			} else if(mode.equals("delivery")) { // 배송 변경
				mapper.updateOrderState(map);
			} else if(mode.equals("cancelAmount")) { // 주문취소 금액 수정
				mapper.updateCancelAmount(map);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void updateOrderDetailState(Map<String, Object> map) throws Exception {
		try {
			String orderNum = (String)map.get("orderNum");
			int detailState = Integer.parseInt((String)map.get("detailState"));
			int productMoney = Integer.parseInt((String)map.get("productMoney"));
			int payment = Integer.parseInt((String)map.get("payment"));
			
			// 주문에 대한 전체 취소 금액 가져오기
			int cancelAmount = 0;
			if(detailState == 3 || detailState == 5 || detailState == 12) {
				// totalCancelAmount = dao.selectOne("adminOrder.readTotalCancelAmount", orderNum);
				cancelAmount = Integer.parseInt((String)map.get("cancelAmount"));
			}
			
			// orderDetail 테이블 상태 변경
			mapper.updateOrderDetailState(map);
			
			// detailStateInfo 테이블에 상태 변경 내용 및 날짜 저장
			mapper.insertDetailStateInfo(map);

			// productOrder 테이블 취소금액 변경
			// 환불-개별판매취소(관리자),주문취소완료(관리자),반품완료(관리자)
			if(detailState == 3 || detailState == 5 || detailState == 12) {
				cancelAmount += productMoney;
				int amount = cancelAmount;
				if(cancelAmount > payment) {
					amount = payment;
				}
				
				map.put("cancelAmount", amount);

				mapper.updateCancelAmount(map);
				
				// 주문정보에 대한 모든 주문 내역이 주문 취소이면 주문정보의 상태는 판매 취소로 변경
				int totalOrderCount = mapper.totalOrderCount(orderNum);
				if(totalOrderCount == 0) {
					map.put("orderState", 6);
					mapper.updateOrderState(map);
				}
				
				// 판매취소 개수 만큼 재고 증가 -----
				mapper.updateProductStockInc(map);
				
				// 카드 취소내역 저장
				
				
				// 포인트
				String userId = (String)map.get("userId");
				int usedSaved = Integer.parseInt((String)map.get("usedSaved"));
				String orderDate = (String)map.get("orderDate");
				// LocalDateTime now = LocalDateTime.now();
				// String dateTime = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
				if(userId.length() != 0) {
					if(totalOrderCount == 0) {
						UserPoint up = new UserPoint();
						up.setUserId(userId);
						up.setOrderNum(orderNum);
						up.setPoint(usedSaved);
						up.setClassify(4); // 1:적립, 2:사용, 3:소멸, 4:주문취소/판매취소
						up.setBase_date(orderDate);
						up.setMemo("구매취소");
						orderMapper.insertUserPoint(up);					
					} else {
						int diff = cancelAmount - payment;
						if( diff > 0 ) {
							UserPoint up = new UserPoint();
							up.setUserId(userId);
							up.setOrderNum(orderNum);
							up.setPoint(diff);
							up.setClassify(4); // 1:적립, 2:사용, 3:소멸, 4:주문취소/판매취소
							up.setBase_date(orderDate);
							up.setMemo("구매취소에 따른 남은 포인트");
							orderMapper.insertUserPoint(up);					
						}
					}
				}
				
			} else if(detailState == 2) { // 관리자에 의해 자동 구매확정
				// 구매 상품에 대한 포인트 적립
				String userId = (String)map.get("userId");
				String orderDate = (String)map.get("orderDate");
				if(userId.length() != 0) {
					int savedMoney = Integer.parseInt((String)map.get("savedMoney"));
					
					UserPoint up = new UserPoint();
					up.setUserId(userId);
					up.setOrderNum(orderNum);
					up.setPoint(savedMoney);
					up.setClassify(1); // 1:적립, 2:사용, 3:소멸, 4:주문취소/판매취소
					up.setBase_date(orderDate);
					up.setMemo("자동 구매확정");
					orderMapper.insertUserPoint(up);
				}
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
	
	@Override
	public List<Map<String, Object>> listDeliveryCompany() {
		List<Map<String, Object>> list = null;
		
		try {
			list = mapper.listDeliveryCompany();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	@Override
	public List<Map<String, Object>> listDetailStateInfo(long orderDetailNum) {
		List<Map<String, Object>> list = null;
		
		// OrderState.DETAILSTATEMANAGER : 주문상세상태 정보(관리자)
		try {
			list = mapper.listDetailStateInfo(orderDetailNum);
			
			String detalStateInfo;
			for(Map<String, Object> map : list) {
				int detailState = ((BigDecimal) map.get("DETAILSTATE")).intValue(); 
				detalStateInfo = OrderState.DETAILSTATEMANAGER[detailState];
				map.put("DETALSTATEINFO", detalStateInfo);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
}
