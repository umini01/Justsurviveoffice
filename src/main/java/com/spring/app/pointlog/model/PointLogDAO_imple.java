package com.spring.app.pointlog.model;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class PointLogDAO_imple implements PointLogDAO{

	@Qualifier("sqlsession")
	private final SqlSessionTemplate sql;

	@Override
	// 유저가 게시글 작성시 해당 Point를 얻고, log에 기록.
	public int insertPointLogBoard(Map<String, String> paraMap) {
		return sql.insert("pointLog.addPointLogBoard", paraMap);
	}
	@Override
	// 유저가 게시글 작성시 해당 Point를 얻고, log에 기록.
	public int insertPointLogComment(Map<String, String> paraMap) {
		return sql.insert("pointLog.addPointLogComment", paraMap);
	}
	
	@Override 
	// 해당 유저가 하루 동안 작성한 게시글 수를 반환.
	public int getCreatedAtLogBoardCnt(String id) {
		int n = sql.selectOne("pointLog.getCreatedAtLogBoardCnt", id);
		return n;
	}

	@Override
	// 해당 유저가 하루 동안 작성한 댓글 수를 반환.
	public int getCreatedAtLogCommentCnt(String id) {
		int n = sql.selectOne("pointLog.getCreatedAtLogCommentCnt", id);
		return n;
	}


	
	
}
