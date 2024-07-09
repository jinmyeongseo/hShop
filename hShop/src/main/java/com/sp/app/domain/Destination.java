package com.sp.app.domain;

// 배송지
public class Destination {
	private long num;
	private String userId;
	private String recipientName;
	private int defaultDest;
	private String tel;
	private String zip;
	private String addr1;
	private String addr2;
	private String destMemo;
	
	private String orderNum;

	public long getNum() {
		return num;
	}

	public void setNum(long num) {
		this.num = num;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getRecipientName() {
		return recipientName;
	}

	public void setRecipientName(String recipientName) {
		this.recipientName = recipientName;
	}

	public int getDefaultDest() {
		return defaultDest;
	}

	public void setDefaultDest(int defaultDest) {
		this.defaultDest = defaultDest;
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

	public String getOrderNum() {
		return orderNum;
	}

	public void setOrderNum(String orderNum) {
		this.orderNum = orderNum;
	}
}
