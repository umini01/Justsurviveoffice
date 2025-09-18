package com.spring.app.comment.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.app.comment.domain.CommentDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class CommentDAO_imple implements CommentDAO {

    private final SqlSessionTemplate sql;

   
    // 댓글 작성
    @Override
    public int insertComment(CommentDTO comment) {
        return sql.insert("comments.insertComment", comment);
    }

    // 특정 게시글의 댓글 목록
    @Override
	public	List<CommentDTO> getCommentList(Long boardNo) {
        return sql.selectList("comments.getCommentsByBoardNo", boardNo);
    }

    // 댓글 삭제
    @Override
    public int deleteComment(Long commentNo) {
        return sql.delete("comments.deleteComment", commentNo);
    }
	
	// 댓글 수정
    @Override
    public int updateComment(Long commentNo, String content, String fk_id) {
        java.util.Map<String, Object> paramMap = new java.util.HashMap<>();
        paramMap.put("commentNo", commentNo);
        paramMap.put("content", content);
        paramMap.put("fk_id", fk_id);
        return sql.update("comments.updateComment", paramMap);
    }
    
    // 유저가 하루동안 쓴 댓글의 개수를 얻어오는 메소드 (3개 이하면 pointUp)
	@Override
	public int getCreatedAtCommentCnt(String id) {
		int n = sql.selectOne("comments.getCreatedAtCommentCnt", id);
		return n;
	}
	
	//대댓글 목록
	@Override
	public List<CommentDTO> getRepliesByParentNo(Long commentNo) {
		return sql.selectList("comments.getRepliesByParentNo", commentNo);
	}

	//대댓글 작성
	@Override
	public int insertReply(CommentDTO comment) {
		return sql.insert("comments.insertReply", comment);
	}

    //대댓글 삭제
	@Override
	public int deleteReply(Long commentNo) {
        return sql.delete("comments.deleteReply", commentNo);
	}
	
	//대댓글 조회
	@Override
	public CommentDTO getReplyById(Long commentNo) {
		return sql.selectOne("comments.getReplyById",commentNo);
	}

	//댓글 좋아요 여부
	@Override
	public int iscommentLiked(Map<String, Object> paramMap) {
	    return sql.selectOne("commentLike.iscommentLiked", paramMap);
	}


	//댓글 좋아요 추가
	@Override
	public int insertCommentLike(String fk_id, Long commentNo) {
		Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fk_id", fk_id);
        paramMap.put("commentNo", commentNo);
        return sql.insert("commentLike.insertCommentLike", paramMap); 
	}
	
	//댓글 좋아요 취소
	@Override
	public int deleteCommentLike(String fk_id, Long commentNo) {
		Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fk_id", fk_id);
        paramMap.put("commentNo", commentNo);
		return sql.delete("commentLike.deleteCommentLike", paramMap);
	}

	//댓글 좋아요 수
	@Override
	public int getCommentLikeCount(Long commentNo) {
        return sql.selectOne("commentLike.getCommentLikeCount", commentNo);
	}

	//댓글 싫어요 여부
	@Override
	public int iscommentDisliked(Map<String, Object> paramMap) {
	    return sql.selectOne("commentDislike.iscommentDisliked", paramMap);
	}

	//댓글 싫어요 추가
	@Override
	public int insertCommentDislike(String fk_id, Long commentNo) {
		Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fk_id", fk_id);
        paramMap.put("commentNo", commentNo);
        return sql.insert("commentDislike.insertCommentDislike", paramMap); 
	}
		
		
	//댓글 싫어요 취소
	@Override
	public int deleteCommentDislike(String fk_id, Long commentNo) {
		Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fk_id", fk_id);
        paramMap.put("commentNo", commentNo);
		return sql.delete("commentDislike.deleteCommentDislike", paramMap);
	}

	

	//댓글 싫어요 수
	@Override
	public int getCommentDislikeCount(Long commentNo) {
        return sql.selectOne("commentDislike.getCommentDislikeCount", commentNo);
	}
	

// ========================================================= //	
	
	
	//대댓글 좋아요 여부
	@Override
	public int isreplyLiked(Map<String, Object> paramMap) {
	    return sql.selectOne("commentLike.isreplyLiked", paramMap);

	}

	//대댓글 좋아요 취소
	@Override
	public int deleteReplyLike(String fk_id, Long commentNo) {
		Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fk_id", fk_id);
        paramMap.put("commentNo", commentNo);
		return sql.delete("commentLike.deleteReplyLike", paramMap);
	}

	//대댓글 좋아요 추가
	@Override
	public int insertReplyLike(String fk_id, Long commentNo) {
		Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fk_id", fk_id);
        paramMap.put("commentNo", commentNo);
        return sql.insert("commentLike.insertReplyLike", paramMap); 
	}

	//대댓글 좋아요 수 
	@Override
	public int getReplyLikeCount(Long commentNo) {
        return sql.selectOne("commentLike.getReplyLikeCount", commentNo);
	}
	
	//대댓글 싫어요 여부
	@Override
	public int isreplyDisliked(Map<String, Object> paramMap) {
	    return sql.selectOne("commentDislike.isreplyDisliked", paramMap);
	}

	//대댓글 싫어요 취소
	@Override
	public int deleteReplyDislike(String fk_id, Long commentNo) {
		Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fk_id", fk_id);
        paramMap.put("commentNo", commentNo);
		return sql.delete("commentDislike.deleteReplyDislike", paramMap);
	}

	//대댓글 싫어요 추가
	@Override
	public int insertReplyDislike(String fk_id, Long commentNo) {
		Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fk_id", fk_id);
        paramMap.put("commentNo", commentNo);
        return sql.insert("commentDislike.insertReplyDislike", paramMap); 
	}

	//대댓글 싫어요 수
	@Override
	public int getReplyDislikeCount(Long commentNo) {
        return sql.selectOne("commentDislike.getReplyDislikeCount", commentNo);
	}

	
	

  
  
}