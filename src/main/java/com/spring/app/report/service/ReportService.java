package com.spring.app.report.service;

import com.spring.app.report.domain.ReportDTO;

public interface ReportService {

	// 중복신고 확인
	boolean isReported(String fk_id, Long fk_boardNo);

	//신고 추가하기
	int insertReport(ReportDTO reportDto);

}
