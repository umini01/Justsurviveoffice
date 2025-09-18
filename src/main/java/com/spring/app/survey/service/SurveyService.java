package com.spring.app.survey.service;

import java.util.List;
import java.util.Map;

public interface SurveyService {
	
	// 설문과 옵션 내용 가져오기
	List<Map<String, String>> surveyStart();

}
