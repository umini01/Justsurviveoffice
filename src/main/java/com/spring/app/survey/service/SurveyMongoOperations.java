package com.spring.app.survey.service;

import java.util.List;

import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.stereotype.Service;

import com.spring.app.survey.domain.Mongo_QuestionDTO;

import lombok.RequiredArgsConstructor;

//== 몽고DB 설문 관련 순서3
@Service
@RequiredArgsConstructor
public class SurveyMongoOperations {
	
	private final MongoOperations mongoTemplate;
	
	
	public void insertMessage(Mongo_QuestionDTO document) {
		
		try {
			mongoTemplate.save(document, "jso_question");	// 없으면 추가, 있으면 수정. 이것을 실행되면 mongodb 의 데이터베이스 mydb 에 jso_question 라는 컬렉션이 없다라도 자동적으로 먼저 jso_question 컬렉션을 생성해준 다음에 도큐먼트를 추가시켜준다.
						
		} catch (Exception e) {
			e.printStackTrace();
			
			throw e;
		}
		
	}
	
	
	// 몽고DB에서 설문 데이터 가져오기 
	public List<Mongo_QuestionDTO> findAllQuestions() {
		
		List<Mongo_QuestionDTO> list = null;
		
		try {
			// 전체조회
			list = mongoTemplate.findAll(Mongo_QuestionDTO.class);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
}
