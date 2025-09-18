package com.spring.app.springscheduler.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Repository;

import com.spring.app.board.domain.BoardDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
@Qualifier("SpringSchedulerDAO_final_orauser_imple")
@Primary
public class SpringSchedulerDAO_final_orauser_imple implements SpringSchedulerDAO_final_orauser {
	
	// 의존객체를 생성자 주입(DI : Dependency Injection)
	@Qualifier("sqlsession")
	private final SqlSessionTemplate sql;
	
	
	// 기존 보드 랭킹 테이블안에 내용 비워주기
	@Override
	public void deleteFromRank() {
		sql.delete("springScheduler_jso.deleteFromRank");
	}
	
	
	// 보드 랭킹 테이블에 새로운 데이터 넣기
	@Override
	public int insertGetTopBoardsByViewCount() {
		int n = sql.insert("springScheduler_jso.insertGetTopBoardsByViewCount");
		return n;
	}
	
	
	// 보드 랭킹 테이블에 댓글순 기준 새로운 데이터 넣기
	@Override
	public int insertGetTopBoardsByCommentCount() {
		int m = sql.insert("springScheduler_jso.insertGetTopBoardsByCommentCount");
		return m;
	}
	
	
	// 랭킹 테이블에 데이터 있는지 검사
	@Override
	public int selectRankBoard() {
		int n = sql.selectOne("springScheduler_jso.selectRankBoard");
		return n;
	}
	
	
	
}
