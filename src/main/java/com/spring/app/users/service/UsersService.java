package com.spring.app.users.service;

import java.util.List;
import java.util.Map;

import org.springframework.ui.Model;

import com.spring.app.category.domain.CategoryDTO;
import com.spring.app.entity.Users;
import com.spring.app.users.domain.LoginHistoryDTO;
import com.spring.app.users.domain.UsersDTO;

public interface UsersService {

	// 로그인
	UsersDTO getUser(String id, String Pwd);

	// 아이디 중복 체크
	boolean isIdExists(String id);

	// 이메일 존재 여부
	boolean isEmailExists(String email);
	
	//이메일 중복
	public boolean isEmailDuplicated(String email);
	
	// 회원가입
	void registerUser(Users user);

	// 유저 존재 여부 확인
	Users findByIdAndEmail(String id, String email);

	// 비밀번호 업데이트
	void updatePassword(String id, String newPassword);

	//  회원 수정 하기
	public UsersDTO updateUser(UsersDTO userDto);

	// 회원 탈퇴하기
	public int delete(String id);
	
	// loginHistory의 user엔티티 생성용 메소드
	Users toEntity(UsersDTO userDto);

	// 로그인 기록 남기기
	void saveLoginHistory(LoginHistoryDTO loginHistoryDTO);

	UsersDTO getIdFind(String name, String email);

	//휴면상태로 업데이트 (비밀번호 변경대상)
	boolean updateDormantStatus(String id);

	// 저장된 id에게 저장된 point만큼 point를 증가시키는 메소드.
	void getPoint(Map<String, String> paraMap); 
	// 게시물 업로드시, 1000p, 좋아요 누를시 500p, 댓글 500p

	// 카테고리별 게시물 통계
	List<CategoryDTO> categoryByBoard();

	// 카테고리별 인원수 통계
	List<CategoryDTO> categoryByUsers();

	// 250828 01:30 차트 수정
	List<Map<String,String>> registerChart(int year);
	 
 	default List<Map<String,String>> registerChart() {
 		return registerChart(java.time.LocalDate.now().getYear());
 	}	
 
 	List<Map<String, String>> registerChartday(int month);

 	// 차트 월 - 일자별 보이도록
 	default List<Map<String, String>> registerChartday(){
 		return registerChartday(java.time.LocalDate.now().getMonthValue());
 	}
 	
 	// 성향테스트 이후 카테고리 저장하기
	UsersDTO saveCategoryNo(String id, Long categoryNo);

 	// 엑셀 저장
	void userExcelList_to_Excel(String chart, Integer month, Model model);
	 
}
