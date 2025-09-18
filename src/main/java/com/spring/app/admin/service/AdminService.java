package com.spring.app.admin.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.data.domain.Page;

import com.spring.app.category.domain.CategoryDTO;
import com.spring.app.entity.Report;
import com.spring.app.users.domain.UsersDTO;

public interface AdminService {

	// 회원목록 전체보기(페이징 처리)
	Page<UsersDTO> getPageUserList(String searchType, String searchWord, int currentShowPageNo, int sizePerPage)
								throws Exception;

	// 특정 회원 1명 상세보기(Detail)
	UsersDTO getUsers(String id);

	// 카테고리별 인원 통계 (장유민 제작)
	List<CategoryDTO> categoryChart();
	
	// 문자메시지 보내기 관련 코드 작성
	JSONObject smsSend(String mobile, String smsContent, String datetime) throws Exception;
	
	// 신고목록 전체보기(페이징 처리)
	Page<Report> getPageReport(int currentShowPageNo, int sizePerPage) throws Exception;
	
	// 신고 처리 완료해주기
	int reportComplete(Long reportNo);
	
}
