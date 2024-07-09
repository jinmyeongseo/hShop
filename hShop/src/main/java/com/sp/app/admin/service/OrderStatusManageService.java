package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

import com.sp.app.admin.domain.OrderDetailManage;
import com.sp.app.admin.domain.OrderManage;

public interface OrderStatusManageService {
	public int orderCount(Map<String, Object> map);
	public List<OrderManage> listOrder(Map<String, Object> map);
	public OrderManage findById(String orderNum);
	public List<OrderDetailManage> orderDetails(String orderNum);
	
	public int orderDetailCount(Map<String, Object> map);
	public List<OrderDetailManage> listOrderDetail(Map<String, Object> map);
	
	public void updateOrder(String mode, Map<String, Object> map) throws Exception;
	public void updateOrderDetailState(Map<String, Object> map) throws Exception;
	
	public List<Map<String, Object>> listDeliveryCompany();
	public List<Map<String, Object>> listDetailStateInfo(long orderDetailNum);
}
