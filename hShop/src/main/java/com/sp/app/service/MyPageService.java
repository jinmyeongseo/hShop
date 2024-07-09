package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.domain.Destination;
import com.sp.app.domain.Order;
import com.sp.app.domain.Payment;

public interface MyPageService {
	public int countPayment(Map<String, Object> map);
	public List<Payment> listPayment(Map<String, Object> map);
	public List<Payment> listPurchase(Map<String, Object> map);
	
	public Payment findByOrderDetail(Map<String, Object> map);
	public Destination findByOrderDelivery(Map<String, Object> map);
	public void updateOrderDetailState(Map<String, Object> map) throws Exception;
	public void updateOrderHistory(long orderDetailNum) throws Exception;
	
	public void insertCart(Order dto) throws Exception;
	public List<Order> listCart(String userId);
	public void deleteCart(Map<String, Object> map) throws Exception;
}
