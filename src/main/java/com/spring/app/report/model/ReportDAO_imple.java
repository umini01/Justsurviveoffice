package com.spring.app.report.model;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.report.domain.ReportDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ReportDAO_imple implements ReportDAO {
	
	@Qualifier("sqlsession")
	private final SqlSessionTemplate sql;
	
	@Override
	public int isReported(Map<String, Object> paramMap) {
		return sql.selectOne("report.isReported", paramMap);
	}

	@Override
	public int insertReport(ReportDTO reportDto) {
        return sql.insert("report.insertReport", reportDto); 
	}

}
