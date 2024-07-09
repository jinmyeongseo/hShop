package com.sp.app.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sp.app.domain.Member;
import com.sp.app.mapper.MemberMapper;

@Service
public class MemberServiceImpl implements MemberService {
	@Autowired
	private MemberMapper mapper;
	
	@Override
	public Member loginMember(String userId) {
		Member dto = null;

		try {
			dto = mapper.loginMember(userId);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return dto;
	}

	@Override
	public void insertMember(Member dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateMembership(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateLastLogin(String userId) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateMember(Member dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public Member findById(String userId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Member findById(long memberIdx) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void deleteMember(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void generatePwd(Member dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

}
