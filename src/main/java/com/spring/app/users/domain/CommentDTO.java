package com.spring.app.users.domain;

import java.time.LocalDateTime;

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

	private  LocalDateTime updatedAtComment;

	private Long fk_boardNo;

	private int parentNo;
	
	private Users users;
	
	private Board board;
	
	private int rank; // Hot, 댓글 많은 게시글 순위를 위한 select 용
	private int commentCount; // 댓글 많은 게시글 댓글 수 알아오기 위한 select 용

}
