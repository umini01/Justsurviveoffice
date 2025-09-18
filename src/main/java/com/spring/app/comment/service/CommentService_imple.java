package com.spring.app.comment.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.spring.app.comment.domain.CommentDTO;
import com.spring.app.comment.model.CommentDAO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommentService_imple implements CommentService {

    private final CommentDAO commentDao;



    // 댓글 추가
    @Override
    public void insertComment(CommentDTO comment) {
    	commentDao.insertComment(comment);
    }

    //댓글 수정
    @Override
    public boolean updateComment(Long commentNo, String content, String fk_id) {
        return commentDao.updateComment(commentNo, content, fk_id) > 0;
    }

   
    //댓글 삭제 (본인만 가능)
    @Override
    public int deleteComment(Long commentNo) {
        int n =  commentDao.deleteComment(commentNo) ;
        
        return n;
    }


    // 유저가 하루동안 쓴 댓글의 개수를 얻어오는 메소드 (3개 이하면 pointUp)
	@Override
	public int getCreatedAtCommentCnt(String id) {
		int n = commentDao.getCreatedAtCommentCnt(id);
		return n;
	}


	//대댓글 작성
	@Override
	public int insertReply(CommentDTO comment) {
		return commentDao.insertReply(comment);
	}

	//대댓글 삭제 (본인만 가능)
    @Override
    public int deleteReply(Long commentNo) {
        int n =  commentDao.deleteReply(commentNo) ;
        
        return n;
    }

	
    //대댓글 목록 조회
	@Override
	public CommentDTO getReplyById(Long commentNo) {
		return commentDao.getReplyById(commentNo);
	}

// ========================================================= //	


	// 댓글 좋아요 여부
	@Override
	public boolean iscommentLiked(String fk_id, Long commentNo) {
		Map<String, Object> paramMap = new HashMap<>();
		
		paramMap.put("fk_id", fk_id);
		paramMap.put("commentNo", commentNo);
		
		int commentLikeCount = commentDao.iscommentLiked(paramMap);
	    return commentLikeCount > 0; // 좋아요가 존재하면 true			
	}

	//	댓글 좋아요 취소
	@Override
	public int deleteCommentLike(String fk_id, Long commentNo) {
	    return commentDao.deleteCommentLike(fk_id, commentNo);
	}

	// 댓글 좋아요 추가
	@Override
	public int insertCommentLike(String fk_id, Long commentNo) {
		int n = commentDao.insertCommentLike( fk_id,commentNo );
		return n;
	}


	//	댓글 좋아요 수
	@Override
	public int getCommentLikeCount(Long commentNo) {
		return commentDao.getCommentLikeCount(commentNo);
	}
	
	// 댓글 싫어요 여부
	@Override
	public boolean iscommentDisliked(String fk_id, Long commentNo) {
		Map<String, Object> paramMap = new HashMap<>();
		
		paramMap.put("fk_id", fk_id);
		paramMap.put("commentNo", commentNo);
		
		int commentDislikeCount = commentDao.iscommentDisliked(paramMap);
	    return commentDislikeCount > 0; // 좋아요가 존재하면 true			
	}

	//	댓글 싫어요 취소
	@Override
	public int deleteCommentDislike(String fk_id, Long commentNo) {
	    return commentDao.deleteCommentDislike(fk_id, commentNo);
	}

	// 댓글 싫어요 추가
	@Override
	public int insertCommentDislike(String fk_id, Long commentNo) {
		int n = commentDao.insertCommentDislike( fk_id,commentNo );
		return n;
	}

	//	댓글 싫어요 수
	@Override
	public int getCommentDislikeCount(Long commentNo) {
		return commentDao.getCommentDislikeCount(commentNo);
	}

// ========================================================= //	

	//대댓글 좋아요 여부
	@Override
	public boolean isreplyLiked(String fk_id, Long commentNo) {
		Map<String, Object> paramMap = new HashMap<>();
		
		paramMap.put("fk_id", fk_id);
		paramMap.put("commentNo", commentNo);
		
		int replyLikeCount = commentDao.isreplyLiked(paramMap);
	    return replyLikeCount > 0; // 좋아요가 존재하면 true			
	}

	//대댓글 좋아요 취소
	@Override
	public int deleteReplyLike(String fk_id, Long commentNo) {
	    return commentDao.deleteReplyLike(fk_id, commentNo);
	}

	//대댓글 좋아요 추가
	@Override
	public int insertReplyLike(String fk_id, Long commentNo) {
		int n = commentDao.insertReplyLike( fk_id,commentNo );
		return n;
	}

	//대댓글 좋아요 수 가져오기
	@Override
	public int getReplyLikeCount(Long commentNo) {
		return commentDao.getReplyLikeCount(commentNo);
	}

	//대댓글 싫어요 여부
	@Override
	public boolean isreplyDisliked(String fk_id, Long commentNo) {
		Map<String, Object> paramMap = new HashMap<>();
		
		paramMap.put("fk_id", fk_id);
		paramMap.put("commentNo", commentNo);
		
		int replyDislikeCount = commentDao.isreplyDisliked(paramMap);
	    return replyDislikeCount > 0; // 좋아요가 존재하면 true			
	}

	//대댓글 싫어요 취소
	@Override
	public int deleteReplyDislike(String fk_id, Long commentNo) {
	    return commentDao.deleteReplyDislike(fk_id, commentNo);
	}

	//대댓글 싫어요 추가
	@Override
	public int insertReplyDislike(String fk_id, Long commentNo) {
		int n = commentDao.insertReplyDislike( fk_id,commentNo );
		return n;
	}

	//대댓글 싫어요 수
	@Override
	public int getReplyDislikeCount(Long commentNo) {
	    return commentDao.getReplyDislikeCount(commentNo); 

	}


    



	

   


}