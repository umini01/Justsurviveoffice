package com.spring.app.comment.domain;

import java.time.LocalDateTime;
import java.util.List;

import com.spring.app.entity.Board;
import com.spring.app.entity.Users;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CommentDTO {
	
	private Long commentNo;

	private String fk_id;

	private String fk_name;

	private String content;

	private  LocalDateTime createdAtComment;


	private Long fk_boardNo;

	private Long parentNo;
	
	private Users users;
	
	private Board board;
	
	// 좋아요/싫어요 카운트 추가
    private int commentLikeCount;      
    private int commentDislikeCount;   

    private int replyLikeCount;      
    private int replyDislikeCount;      
    
    private boolean commentLiked;   // 댓글 좋아요 여부
    private boolean commentDisliked; // 댓글 싫어요 여부
	
    
    private boolean replyLiked;     // 대댓글 좋아요 여부
    private boolean replyDisliked;  // 대댓글 싫어요 여부


    // 대댓글 리스트 추가
    private List<CommentDTO> replyList;
	

}
