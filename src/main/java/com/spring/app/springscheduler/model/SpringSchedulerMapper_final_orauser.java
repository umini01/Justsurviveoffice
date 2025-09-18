package com.spring.app.springscheduler.model;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface SpringSchedulerMapper_final_orauser {
	
	// 기존 보드 랭킹 테이블안에 내용 비워주기
	void deleteFromRank();
	
	// 보드 랭킹 테이블에 새로운 데이터 넣기
	int insertGetTopBoardsByViewCount();
	
	// 보드 랭킹 테이블에 댓글순 기준 새로운 데이터 넣기
	int insertGetTopBoardsByCommentCount();
	
	// 랭킹 테이블에 데이터 있는지 검사
	int selectRankBoard();
	
	// KEYWORD_RANKING 테이블 데이터 전부 제거
	void deleteFromKeyword();
	
	// 보드 테이블에서 제목과 내용, 카테고리번호 가져오기(DB)
	List<Map<String, Object>> getgetBoardContents(Integer category);
	
	// KEYWORD_RANKING 테이블에 데이터 넣어주기
	int insertGetKeyWord(List<Map<String, Object>> resultList);	// MyBatis에서 컬렉션 이름이 자동으로 list 가 되어진다.
	
	// 키워드 테이블에 데이터 있는지 검사
	int selectRank();

}
