package com.spring.app.springscheduler.service;

public interface SpringSechedulerService {
	
	// === 먼저 com.spring.app.JustsurviveofficeApplication 에 가서 @EnableScheduling 을 해주어야 한다. === //
	
	// !!<주의>!! 스프링 스케줄러로 사용되는 메소드는 반드시 리턴다입은 void 이어야 하고, 파라미터가 없어야 한다.!!!!
	
	// 매주 월요일 01:00 에 랭킹 테이블 초기화 및 업데이트 해주기
	void weeklyRankingTable();
	
	// 랭킹 테이블에 데이터 있는지 검사
	void selectRankingTable();
	
	// 매일 키워드 테이블 초기화 및 업데이트
	void selectRankingKeyword();
	
	// 키워드 테이블에 데이터 있는지 검사
	void selectKeywordTable();
	
}
