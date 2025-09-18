package com.spring.app.model;

import org.springframework.data.jpa.repository.JpaRepository;

import com.spring.app.entity.LoginHistory;

public interface HistoryRepository extends JpaRepository<LoginHistory, Integer> {

	// String 이라고 쓴 이유는 Member 엔티티 클래스에 @ID 로 사용되는 userId 필드의 타입이 String 이기 때문이다.

		/*
		   HistoryRepository 를 이용해 엔티티클래스명의 테이블(LoginHistory)에 SQL문장 없이 CRUD 작업이 되어진다. 
		   JpaRepository 는 아래와 같은 내장된 쿼리메소드를 사용하여 CRUD 작업이 되어진다.
		   
		   - insert 작업 : save(엔티티 객체) 
		   - select 작업 : findAll(), findById(키 타입)
		   - update 작업 : save(엔티티 객체) 
		   - delete 작업 : deleteById(키 타입) 
		   
		   특이하게도 insert와 update 작업에는 동일한 메서드인 save()를 이용하는데 
		   그 이유는 JPA의 구현체가 메모리상(엔티티들을 관리해주는 Entity Manager 가 메모리에 올라감)에서 
		   엔티티 객체(행)가 없다면 insert, 엔티티 객체(행)가 존재한다면 update 를 동작시키는 방식으로 실행되기 때문이다.
		   save는 행이 없으면 insert해준다.
		 */
	
		// === 쿼리메소드 생성하기 ===
		// !!! findBy 다음에 붙는 것은 필드명이지 컬럼명이 아니다. !!!
		// userName 으로 조회
	
		// Long 이라고 쓴 이유는 Board 클래스에 @ID 로 사용되는 num 필트의 타입이 Long 이기 때문이다.
	
		// === 사용자가 정의하는 쿼리메소드 생성하기 === //
		// findBy필드명()
	
}
