package com.spring.app.report.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.spring.app.report.domain.ReportDTO;
import com.spring.app.report.model.ReportDAO;
import com.spring.app.survey.model.SurveyDAO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReportService_imple implements ReportService {
	
	private final ReportDAO reportDao;
	
	
	//중복신고여부
	@Override
	public boolean isReported(String fk_id, Long fk_boardNo) {
		Map<String, Object> paramMap = new HashMap<>();
		
		paramMap.put("fk_id", fk_id);
		paramMap.put("fk_boardNo", fk_boardNo);
		
		int count = reportDao.isReported(paramMap);
	    return count > 0; // 신고가 존재하면 true		
	}

	//게시글 신고하기
	public int insertReport(ReportDTO reportDto) {
		int n = reportDao.insertReport(reportDto);
		return n;
	}


}
