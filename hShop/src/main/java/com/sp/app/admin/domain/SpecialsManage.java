package com.sp.app.admin.domain;

import org.springframework.web.multipart.MultipartFile;

public class SpecialsManage {
	private long specialNum;
	private int classify;
	private String subject;
	private String content;
	private String startDate;
	private String endDate;
	private String sday;
	private String stime;
	private String eday;
	private String etime;
	private int showSpecial;
	private String reg_date;
	private int productCount;
	
	private MultipartFile selectFile;
	private String imageFilename;
	public long getSpecialNum() {
		return specialNum;
	}
	public void setSpecialNum(long specialNum) {
		this.specialNum = specialNum;
	}
	public int getClassify() {
		return classify;
	}
	public void setClassify(int classify) {
		this.classify = classify;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getSday() {
		return sday;
	}
	public void setSday(String sday) {
		this.sday = sday;
	}
	public String getStime() {
		return stime;
	}
	public void setStime(String stime) {
		this.stime = stime;
	}
	public String getEday() {
		return eday;
	}
	public void setEday(String eday) {
		this.eday = eday;
	}
	public String getEtime() {
		return etime;
	}
	public void setEtime(String etime) {
		this.etime = etime;
	}
	public int getShowSpecial() {
		return showSpecial;
	}
	public void setShowSpecial(int showSpecial) {
		this.showSpecial = showSpecial;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public int getProductCount() {
		return productCount;
	}
	public void setProductCount(int productCount) {
		this.productCount = productCount;
	}
	public MultipartFile getSelectFile() {
		return selectFile;
	}
	public void setSelectFile(MultipartFile selectFile) {
		this.selectFile = selectFile;
	}
	public String getImageFilename() {
		return imageFilename;
	}
	public void setImageFilename(String imageFilename) {
		this.imageFilename = imageFilename;
	}
}
