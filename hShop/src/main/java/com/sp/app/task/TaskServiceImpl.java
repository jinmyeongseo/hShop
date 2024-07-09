package com.sp.app.task;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.sp.app.mapper.MyPageMapper;

@Service
public class TaskServiceImpl implements TaskService {
	@Autowired
	private MyPageMapper mapper;
	
	@Scheduled(cron="0 0 1 * * *")  // 매일 밤 1시
	@Override
	public void automaticRepeatOperation() {
		try {
			// 15일이 지난 장바구니 지우기
			mapper.deleteCartExpiration();
		} catch (Exception e) {
		}
	}
}
