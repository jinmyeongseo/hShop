package com.sp.app.admin.domain;

public class SpecialsDetailManage {
	private long detailNum;
	private long specialNum;
	private long productNum;
	private int displayOrder;
	private int showDetail;
	private String productName;
	private int productShow;
	private String reg_date;
	
	public long getDetailNum() {
		return detailNum;
	}
	public void setDetailNum(long detailNum) {
		this.detailNum = detailNum;
	}
	public long getSpecialNum() {
		return specialNum;
	}
	public void setSpecialNum(long specialNum) {
		this.specialNum = specialNum;
	}
	public long getProductNum() {
		return productNum;
	}
	public void setProductNum(long productNum) {
		this.productNum = productNum;
	}
	public int getDisplayOrder() {
		return displayOrder;
	}
	public void setDisplayOrder(int displayOrder) {
		this.displayOrder = displayOrder;
	}
	public int getShowDetail() {
		return showDetail;
	}
	public void setShowDetail(int showDetail) {
		this.showDetail = showDetail;
	}
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public int getProductShow() {
		return productShow;
	}
	public void setProductShow(int productShow) {
		this.productShow = productShow;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
}
