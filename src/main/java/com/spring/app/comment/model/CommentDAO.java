package com.spring.app.comment.model;

import java.util.List;
import java.util.Map;

import com.spring.app.comment.domain.CommentDTO;

public interface CommentDAO {
	
    // 댓글 작성
    int insertComment(CommentDTO comment);

    //  댓글 목록
	List<CommentDTO> getCommentList(Long boardNo);

	// 댓글 수정
	int updateComment(Long commentNo, String content, String fk_id);
	
    // 댓글 삭제
	int deleteComment(Long commentNo);

	// ========================================================= //	
	
	//대댓글 삭제
	int deleteReply(Long commentNo);

	//대댓글 작성
	int insertReply(CommentDTO comment);

	//대댓글 목록
	List<CommentDTO> getRepliesByParentNo(Long commentNo);

	//대댓글조회
	CommentDTO getReplyById(Long commentNo);
	
	// ========================================================= //	


    // 유저가 하루동안 쓴 댓글의 개수를 얻어오는 메소드 (3개 이하면 pointUp)
	int getCreatedAtCommentCnt(String id);

	// ========================================================= //	

	//댓글 좋아요 여부
	int iscommentLiked(Map<String, Object> paramMap);

	//댓글 좋아요 취소
	int deleteCommentLike(String fk_id, Long commentNo);

	//댓글 좋아요 추가
	int insertCommentLike(String fk_id, Long commentNo);

	//댓글 좋아요 수 
	int getCommentLikeCount(Long commentNo);

	//댓글 싫어요 여부
	int iscommentDisliked(Map<String, Object> paramMap);

	//댓글 싫어요 취소
	int deleteCommentDislike(String fk_id, Long commentNo);

	//댓글 싫어요 추가
	int insertCommentDislike(String fk_id, Long commentNo);

	//댓글 싫어요 수
	int getCommentDislikeCount(Long commentNo);

	// ========================================================= //	

	//대댓글 좋아요 여부
	int isreplyLiked(Map<String, Object> paramMap);

	//대댓글 좋아요 취소
	int deleteReplyLike(String fk_id, Long commentNo);

	//대댓글 좋아요 추가
	int insertReplyLike(String fk_id, Long commentNo);

	//대댓글 좋아요 수 가져오기
	int getReplyLikeCount(Long commentNo);

	//대댓글 싫어요 여부
	int isreplyDisliked(Map<String, Object> paramMap);


	//대댓글 싫어요 취소
	int deleteReplyDislike(String fk_id, Long commentNo);

	//대댓글 싫어요 추가
	int insertReplyDislike(String fk_id, Long commentNo);

	//대댓글 싫어요 수
	int getReplyDislikeCount(Long commentNo);

}