package com.sp.app.domain;

import java.util.List;

public class Order {
	private long productNum;
	private String productName;
	private String thumbnail;
	private int price;
	private int discountRate;
	private int discountPrice;
	private int savedMoney;
	private int delivery;
	private int optionCount;

	private long memberIdx;
	private String userId;

	private String orderNum;
	private long orderDetailNum;
	private String orderDate;
	private int usedSaved;
	private int payment;
	private int totalMoney;
	private int deliveryCharge;
	private int salePrice;
	private int qty;
	private int productMoney;

	private long stockNum;
	private int totalStock;	

	private Long detailNum;
	private Long detailNum2;
	private String optionValue;
	private String optionValue2;
	
	private String optionName;
	private String optionName2;
	private List<String> optionNames;
	private List<String> optionNames2;

	private List<Long> productNums;

	private List<Long> stockNums;
	private List<Long> detailNums;
	private List<Long> detailNums2;
	private List<String> optionValues;
	private List<String> optionValues2;
	private List<Integer> buyQtys;
	private List<Integer> productMoneys;
	private List<Integer> prices;
	private List<Integer> salePrices;
	private List<Integer> savedMoneys;
	
	private Long cartNum;

	// 배송지 정보
	private String recipientName;
	private String tel;
	private String zip;
	private String addr1;
	private String addr2;
	private String destMemo;

	// 결제 내역 정보
	private String payMethod;
	private String cardName;
	private String authNumber;
	private String authDate;
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
	public int getDiscountPrice() {
		return discountPrice;
	}
	public void setDiscountPrice(int discountPrice) {
		this.discountPrice = discountPrice;
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
	public int getOptionCount() {
		return optionCount;
	}
	public void setOptionCount(int optionCount) {
		this.optionCount = optionCount;
	}
	public long getMemberIdx() {
		return memberIdx;
	}
	public void setMemberIdx(long memberIdx) {
		this.memberIdx = memberIdx;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getOrderNum() {
		return orderNum;
	}
	public void setOrderNum(String orderNum) {
		this.orderNum = orderNum;
	}
	public long getOrderDetailNum() {
		return orderDetailNum;
	}
	public void setOrderDetailNum(long orderDetailNum) {
		this.orderDetailNum = orderDetailNum;
	}
	public String getOrderDate() {
		return orderDate;
	}
	public void setOrderDate(String orderDate) {
		this.orderDate = orderDate;
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
	public long getStockNum() {
		return stockNum;
	}
	public void setStockNum(long stockNum) {
		this.stockNum = stockNum;
	}
	public int getTotalStock() {
		return totalStock;
	}
	public void setTotalStock(int totalStock) {
		this.totalStock = totalStock;
	}
	public Long getDetailNum() {
		return detailNum;
	}
	public void setDetailNum(Long detailNum) {
		this.detailNum = detailNum;
	}
	public Long getDetailNum2() {
		return detailNum2;
	}
	public void setDetailNum2(Long detailNum2) {
		this.detailNum2 = detailNum2;
	}
	public String getOptionValue() {
		return optionValue;
	}
	public void setOptionValue(String optionValue) {
		this.optionValue = optionValue;
	}
	public String getOptionValue2() {
		return optionValue2;
	}
	public void setOptionValue2(String optionValue2) {
		this.optionValue2 = optionValue2;
	}
	public String getOptionName() {
		return optionName;
	}
	public void setOptionName(String optionName) {
		this.optionName = optionName;
	}
	public String getOptionName2() {
		return optionName2;
	}
	public void setOptionName2(String optionName2) {
		this.optionName2 = optionName2;
	}
	public List<String> getOptionNames() {
		return optionNames;
	}
	public void setOptionNames(List<String> optionNames) {
		this.optionNames = optionNames;
	}
	public List<String> getOptionNames2() {
		return optionNames2;
	}
	public void setOptionNames2(List<String> optionNames2) {
		this.optionNames2 = optionNames2;
	}
	public List<Long> getProductNums() {
		return productNums;
	}
	public void setProductNums(List<Long> productNums) {
		this.productNums = productNums;
	}
	public List<Long> getStockNums() {
		return stockNums;
	}
	public void setStockNums(List<Long> stockNums) {
		this.stockNums = stockNums;
	}
	public List<Long> getDetailNums() {
		return detailNums;
	}
	public void setDetailNums(List<Long> detailNums) {
		this.detailNums = detailNums;
	}
	public List<Long> getDetailNums2() {
		return detailNums2;
	}
	public void setDetailNums2(List<Long> detailNums2) {
		this.detailNums2 = detailNums2;
	}
	public List<String> getOptionValues() {
		return optionValues;
	}
	public void setOptionValues(List<String> optionValues) {
		this.optionValues = optionValues;
	}
	public List<String> getOptionValues2() {
		return optionValues2;
	}
	public void setOptionValues2(List<String> optionValues2) {
		this.optionValues2 = optionValues2;
	}
	public List<Integer> getBuyQtys() {
		return buyQtys;
	}
	public void setBuyQtys(List<Integer> buyQtys) {
		this.buyQtys = buyQtys;
	}
	public List<Integer> getProductMoneys() {
		return productMoneys;
	}
	public void setProductMoneys(List<Integer> productMoneys) {
		this.productMoneys = productMoneys;
	}
	public List<Integer> getPrices() {
		return prices;
	}
	public void setPrices(List<Integer> prices) {
		this.prices = prices;
	}
	public List<Integer> getSalePrices() {
		return salePrices;
	}
	public void setSalePrices(List<Integer> salePrices) {
		this.salePrices = salePrices;
	}
	public List<Integer> getSavedMoneys() {
		return savedMoneys;
	}
	public void setSavedMoneys(List<Integer> savedMoneys) {
		this.savedMoneys = savedMoneys;
	}
	public Long getCartNum() {
		return cartNum;
	}
	public void setCartNum(Long cartNum) {
		this.cartNum = cartNum;
	}
	public String getRecipientName() {
		return recipientName;
	}
	public void setRecipientName(String recipientName) {
		this.recipientName = recipientName;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getZip() {
		return zip;
	}
	public void setZip(String zip) {
		this.zip = zip;
	}
	public String getAddr1() {
		return addr1;
	}
	public void setAddr1(String addr1) {
		this.addr1 = addr1;
	}
	public String getAddr2() {
		return addr2;
	}
	public void setAddr2(String addr2) {
		this.addr2 = addr2;
	}
	public String getDestMemo() {
		return destMemo;
	}
	public void setDestMemo(String destMemo) {
		this.destMemo = destMemo;
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
	public String getAuthNumber() {
		return authNumber;
	}
	public void setAuthNumber(String authNumber) {
		this.authNumber = authNumber;
	}
	public String getAuthDate() {
		return authDate;
	}
	public void setAuthDate(String authDate) {
		this.authDate = authDate;
	}
}
