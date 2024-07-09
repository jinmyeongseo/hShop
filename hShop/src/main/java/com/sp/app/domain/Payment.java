package com.sp.app.domain;

public class Payment {
	private String userId;

	private long productNum;
	private String productName;
	private int optionCount;
	private String thumbnail;
	private int price;
	private int discountRate;
	private int savedMoney;
	private int delivery;

	private String orderNum;
	private String orderDate;
	private long orderDetailNum;
	private int usedSaved;
	private int payment;
	private int totalMoney;
	private int deliveryCharge;
	private int salePrice;
	private int qty;
	private int productMoney;
	
	private String payMethod;
	private String cardName;
	private String authDate;
	
	private long detailNum;
	private String optionValue;
	private Long detailNum2;
	private String optionValue2;

	private int orderState;
	private String orderStateInfo;
	private int detailState;
	private String detailStateInfo;
	private String stateMemo;
	private String stateDate;
	private String stateProduct;

	private String orderStateDate; // 상태변경일
	private String deliveryName; // 배송업체
	private String invoiceNumber; // 송장 번호
	private long afterDelivery; // 배송완료 후 날짜

	private int reviewWrite; // 리뷰 유무

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public long getProductNum() {
		return productNum;
	}

	public void setProductNum(long productNum) {
		this.productNum = productNum;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public int getOptionCount() {
		return optionCount;
	}

	public void setOptionCount(int optionCount) {
		this.optionCount = optionCount;
	}

	public String getThumbnail() {
		return thumbnail;
	}

	public void setThumbnail(String thumbnail) {
		this.thumbnail = thumbnail;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public int getDiscountRate() {
		return discountRate;
	}

	public void setDiscountRate(int discountRate) {
		this.discountRate = discountRate;
	}

	public int getSavedMoney() {
		return savedMoney;
	}

	public void setSavedMoney(int savedMoney) {
		this.savedMoney = savedMoney;
	}

	public int getDelivery() {
		return delivery;
	}

	public void setDelivery(int delivery) {
		this.delivery = delivery;
	}

	public String getOrderNum() {
		return orderNum;
	}

	public void setOrderNum(String orderNum) {
		this.orderNum = orderNum;
	}

	public String getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(String orderDate) {
		this.orderDate = orderDate;
	}

	public long getOrderDetailNum() {
		return orderDetailNum;
	}

	public void setOrderDetailNum(long orderDetailNum) {
		this.orderDetailNum = orderDetailNum;
	}

	public int getUsedSaved() {
		return usedSaved;
	}

	public void setUsedSaved(int usedSaved) {
		this.usedSaved = usedSaved;
	}

	public int getPayment() {
		return payment;
	}

	public void setPayment(int payment) {
		this.payment = payment;
	}

	public int getTotalMoney() {
		return totalMoney;
	}

	public void setTotalMoney(int totalMoney) {
		this.totalMoney = totalMoney;
	}

	public int getDeliveryCharge() {
		return deliveryCharge;
	}

	public void setDeliveryCharge(int deliveryCharge) {
		this.deliveryCharge = deliveryCharge;
	}

	public int getSalePrice() {
		return salePrice;
	}

	public void setSalePrice(int salePrice) {
		this.salePrice = salePrice;
	}

	public int getQty() {
		return qty;
	}

	public void setQty(int qty) {
		this.qty = qty;
	}

	public int getProductMoney() {
		return productMoney;
	}

	public void setProductMoney(int productMoney) {
		this.productMoney = productMoney;
	}

	public String getPayMethod() {
		return payMethod;
	}

	public void setPayMethod(String payMethod) {
		this.payMethod = payMethod;
	}

	public String getCardName() {
		return cardName;
	}

	public void setCardName(String cardName) {
		this.cardName = cardName;
	}

	public String getAuthDate() {
		return authDate;
	}

	public void setAuthDate(String authDate) {
		this.authDate = authDate;
	}

	public long getDetailNum() {
		return detailNum;
	}

	public void setDetailNum(long detailNum) {
		this.detailNum = detailNum;
	}

	public String getOptionValue() {
		return optionValue;
	}

	public void setOptionValue(String optionValue) {
		this.optionValue = optionValue;
	}

	public Long getDetailNum2() {
		return detailNum2;
	}

	public void setDetailNum2(Long detailNum2) {
		this.detailNum2 = detailNum2;
	}

	public String getOptionValue2() {
		return optionValue2;
	}

	public void setOptionValue2(String optionValue2) {
		this.optionValue2 = optionValue2;
	}

	public int getOrderState() {
		return orderState;
	}

	public void setOrderState(int orderState) {
		this.orderState = orderState;
	}

	public String getOrderStateInfo() {
		return orderStateInfo;
	}

	public void setOrderStateInfo(String orderStateInfo) {
		this.orderStateInfo = orderStateInfo;
	}

	public int getDetailState() {
		return detailState;
	}

	public void setDetailState(int detailState) {
		this.detailState = detailState;
	}

	public String getDetailStateInfo() {
		return detailStateInfo;
	}

	public void setDetailStateInfo(String detailStateInfo) {
		this.detailStateInfo = detailStateInfo;
	}

	public String getStateMemo() {
		return stateMemo;
	}

	public void setStateMemo(String stateMemo) {
		this.stateMemo = stateMemo;
	}

	public String getStateDate() {
		return stateDate;
	}

	public void setStateDate(String stateDate) {
		this.stateDate = stateDate;
	}

	public String getStateProduct() {
		return stateProduct;
	}

	public void setStateProduct(String stateProduct) {
		this.stateProduct = stateProduct;
	}

	public String getOrderStateDate() {
		return orderStateDate;
	}

	public void setOrderStateDate(String orderStateDate) {
		this.orderStateDate = orderStateDate;
	}

	public String getDeliveryName() {
		return deliveryName;
	}

	public void setDeliveryName(String deliveryName) {
		this.deliveryName = deliveryName;
	}

	public String getInvoiceNumber() {
		return invoiceNumber;
	}

	public void setInvoiceNumber(String invoiceNumber) {
		this.invoiceNumber = invoiceNumber;
	}

	public long getAfterDelivery() {
		return afterDelivery;
	}

	public void setAfterDelivery(long afterDelivery) {
		this.afterDelivery = afterDelivery;
	}

	public int getReviewWrite() {
		return reviewWrite;
	}

	public void setReviewWrite(int reviewWrite) {
		this.reviewWrite = reviewWrite;
	}
}
