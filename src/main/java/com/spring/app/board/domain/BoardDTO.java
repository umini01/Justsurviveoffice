package com.spring.app.board.domain;

import java.time.LocalDateTime;

import org.springframework.web.multipart.MultipartFile;

import com.spring.app.category.domain.CategoryDTO;
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
public class BoardDTO {
	
	private Long boardNo; // 게시글 번호
	private String boardName; // 게시글 제목
	private String boardContent; // 게시글 내용 
						
	private LocalDateTime createdAtBoard; // 게시글 생성일자
	private LocalDateTime updatedAtBoard; // 게시글 업데이트일자 
	
	private String formattedDate; // 화면에 보여줄 용도!ex) 3일전, 1주일 전..
	
	private int readCount; // 조회수
	private int boardDeleted ;// 게시글 삭제여부 
	
	private String fk_id; // 작성자의 아이디
	
	// 얘도 접근하려면, 카테고리 서비스로 또 메소드 만들어야해서, 
	// 메소드를 만들게되면, boardNo로만 categoryNo를 가져올 수 있다. ㅇㅋ?
	private Long fk_categoryNo; // 카테고리번호 // jsp에서 계속 받아와야함.
	private String categoryName; // listAll, list, view에서 편하게 보여줄 select
	
	private String boardFileName;// 첨부된 파일명 
	private String boardFileOriginName;// 업로드 시 첨부된 파일명
	
	// 스마트 에디터로 글 작성 시 Jsoup를 통한 텍스트 및 이미지 경로 저장
	private String textForBoardList;
	private String imgForBoardList;
	
	private MultipartFile attach; //스프링에서 제공하는 업로드된 파일을 다루는 객체
	/*  주요 메소드:	getOriginalFilename() → 원본 파일명
				    getSize() → 파일 크기
				    getBytes() → 파일 내용을 바이트 배열로
				    transferTo(File dest) → 실제 서버에 저장 */
	
	private Boolean bookmarked; // select 용도
	private boolean boardLiked; // view 페이지에 입장 시, 좋아요 여부의 select 용도
	
	private Users users;// 게시글과 연관된 유저 
	
	private CategoryDTO categoryDTO; // boardDto.categoryDto.categoryNo
	// 얘도 접근하려면, 카테고리 서비스로 또 메소드 만들어야해서, 
	
	private int rank; // Hot, 댓글 많은 게시글 순위를 위한 select 용
	private int commentCount; // 댓글 많은 게시글 댓글 수 알아오기 위한 select 용
	
	
	// select 용
	private String preNo;    	 // 이전글번호
	private String preName; 	// 이전글제목
	private String nextNo;         // 다음글번호
	private String nextName;     // 다음글제목 
	
	

}
