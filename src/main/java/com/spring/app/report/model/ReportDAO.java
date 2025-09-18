package com.spring.app.report.model;

import java.util.Map;

import com.spring.app.report.domain.ReportDTO;

public interface ReportDAO {

	//중복신고여부
	int isReported(Map<String, Object> paramMap);

	//신고추가하기
	int insertReport(ReportDTO reportDto);

}
