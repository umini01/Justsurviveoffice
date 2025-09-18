package com.spring.app.survey.domain;

import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Getter;
import lombok.Setter;
// == 몽고DB 설문 관련 순서1
@Getter
@Setter
@Document(collection = "jso_question")
public class Mongo_QuestionDTO {
	
	@Id
	private String id;
	private String text;
	
	// 옵션을 별도의 클래스로 정의
	private List<Option> options;
	
	@Getter
	@Setter
	public static class Option {
        private String text;
        private String categoryNo;
    }
	
}
