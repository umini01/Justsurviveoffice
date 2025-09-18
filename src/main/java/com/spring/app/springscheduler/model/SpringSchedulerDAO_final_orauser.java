package com.spring.app.springscheduler.model;

import java.util.List;
import java.util.Map;

import com.spring.app.board.domain.BoardDTO;

public interface SpringSchedulerDAO_final_orauser {
	
	// 기존 보드 랭킹 테이블안에 내용 비워주기
	void deleteFromRank();
	
	// 보드 랭킹 테이블에 새로운 데이터 넣기
	int insertGetTopBoardsByViewCount();
	
	// 보드 랭킹 테이블에 댓글순 기준 새로운 데이터 넣기
	int insertGetTopBoardsByCommentCount();
	
	// 랭킹 테이블에 데이터 있는지 검사
	int selectRankBoard();
	
}
