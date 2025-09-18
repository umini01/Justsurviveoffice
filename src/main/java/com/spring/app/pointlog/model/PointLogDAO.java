package com.spring.app.pointlog.model;

import java.util.Map;

public interface PointLogDAO {
	
	// 유저가 게시글 작성시 해당 Point를 얻고, log에 기록.
	public int insertPointLogBoard(Map<String, String> paraMap);
	
	// 유저가 댓글 작성시 해당 Point를 얻고, log에 기록.
	public int insertPointLogComment(Map<String, String> paraMap);
	
	// 해당 유저가 하루 동안 작성한 게시글 수를 반환.
	public int getCreatedAtLogBoardCnt(String id);
	
	// 해당 유저가 하루 동안 작성한 댓글 수를 반환.
	public int getCreatedAtLogCommentCnt(String id);
	
}
