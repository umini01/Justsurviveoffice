package com.spring.app.users.domain;

import java.time.LocalDateTime;

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
public class BookMarkDTO {

  	private Long bookmarkNo;

	private String fk_id;

	private Long fk_boardNo;

	private LocalDateTime createdAtMark;
	
	private Long fk_categoryNo; // 카테고리번호 // jsp에서 계속 받아와야함.
	
	private String boardName;        
	private LocalDateTime createdAtBoard; // 게시글 작성일
	private int readCount;           // 게시글 조회수
	
	
}
