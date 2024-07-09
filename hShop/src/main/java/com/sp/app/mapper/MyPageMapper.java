package com.sp.app.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.domain.Destination;
import com.sp.app.domain.Order;
import com.sp.app.domain.Payment;

@Mapper
public interface MyPageMapper {
	public int countPayment(Map<String, Object> map);
	public List<Payment> listPayment(Map<String, Object> map);
	public List<Payment> listPurchase(Map<String, Object> map);
	
	public Payment findByOrderDetail(Map<String, Object> map);
	public Destination findByOrderDelivery(Map<String, Object> map);
	public void updateOrderDetailState(Map<String, Object> map) throws SQLException;
	public void updateOrderHistory(long orderDetailNum) throws SQLException;
	
	public void insertDetailStateInfo(Map<String, Object> map) throws SQLException;
	public void insertCart(Order dto) throws SQLException;
	public void updateCart(Order dto) throws SQLException;
	public Order findByCartId(Map<String, Object> map);
	public List<Order> listCart(String userId);
	public void deleteCart(Map<String, Object> map) throws SQLException;
	public void deleteCartExpiration() throws SQLException;
}
