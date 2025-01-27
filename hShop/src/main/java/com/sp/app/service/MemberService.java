package com.sp.app.service;

import java.util.Map;

import com.sp.app.domain.Member;

public interface MemberService {
	public Member loginMember(String userId);
	
	public void insertMember(Member dto) throws Exception;
	
	public void updateMembership(Map<String, Object> map) throws Exception;
	public void updateLastLogin(String userId) throws Exception;
	public void updateMember(Member dto) throws Exception;
	
	public Member findById(String userId);
	public Member findById(long memberIdx);
	
	public void deleteMember(Map<String, Object> map) throws Exception;
	
	public void generatePwd(Member dto) throws Exception;
}
