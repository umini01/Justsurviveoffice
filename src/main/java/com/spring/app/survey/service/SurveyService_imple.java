package com.spring.app.survey.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.spring.app.survey.model.SurveyDAO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor  // @RequiredArgsConstructor는 Lombok 라이브러리에서 제공하는 애너테이션으로, final 필드 또는 @NonNull이 붙은 필드에 대해 생성자를 자동으로 생성해준다.
public class SurveyService_imple implements SurveyService {
	
	// 의존객체를 생성자 주입(DI : Dependency Injection)
	private final SurveyDAO sdao;
	
	// 설문과 옵션 내용 가져오기
	public List<Map<String, String>> surveyStart() {
		List<Map<String, String>> surveyList = sdao.surveyStart();
		return surveyList;
	}
	
	
	
}
