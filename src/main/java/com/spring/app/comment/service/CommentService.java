package com.spring.app.comment.service;

import java.util.List;
import java.util.Map;

import com.spring.app.comment.domain.CommentDTO;

public interface CommentService {
	
	// 댓글 작성
    void insertComment(CommentDTO comment);

    //댓글삭제
	int deleteComment(Long commentNo);
	
	//댓글수정
	boolean updateComment(Long commentNo, String newContent, String fk_id);
	
	// 유저가 하루동안 쓴 댓글의 개수를 얻어오는 메소드 (3개 이하면 pointUp)
	public int getCreatedAtCommentCnt(String id);

	
// ========================================================= //	
	//대댓글 작성
	int insertReply(CommentDTO comment);

	//대댓글삭제
	int deleteReply(Long commentNo);

	//대댓글 목록 조회
	CommentDTO getReplyById(Long commentNo);
	
// ========================================================= //	
	
	//댓글 좋아요 여부
	boolean iscommentLiked(String fk_id, Long commentNo);

	//댓글 좋아요 취소
	int deleteCommentLike(String fk_id, Long commentNo);

	//댓글 좋아요 추가
	int insertCommentLike(String fk_id, Long commentNo);

	//댓글 좋아요 수 가져오기
	int getCommentLikeCount(Long commentNo);

	//댓글 싫어요 여부
	boolean iscommentDisliked(String fk_id, Long commentNo);

	//댓글 싫어요 취소
	int deleteCommentDislike(String fk_id, Long commentNo);

	//댓글 싫어요 추가
	int insertCommentDislike(String fk_id, Long commentNo);

	//댓글 싫어요 수
	int getCommentDislikeCount(Long commentNo);

// ========================================================= //	

	//대댓글 좋아요 여부
	boolean isreplyLiked(String fk_id, Long commentNo);

	//대댓글 좋아요 취소
	int deleteReplyLike(String fk_id, Long commentNo);

	//대댓글 좋아요 추가
	int insertReplyLike(String fk_id, Long commentNo);

	//대댓글 좋아요 수 가져오기
	int getReplyLikeCount(Long commentNo);

	//대댓글 싫어요 여부
	boolean isreplyDisliked(String fk_id, Long commentNo);

	//대댓글 싫어요 취소
	int deleteReplyDislike(String fk_id, Long commentNo);

	//대댓글 싫어요 추가
	int insertReplyDislike(String fk_id, Long commentNo);

	//대댓글 싫어요 수
	int getReplyDislikeCount(Long commentNo);
	
	
}
