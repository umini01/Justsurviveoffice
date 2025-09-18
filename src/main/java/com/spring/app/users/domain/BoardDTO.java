package com.spring.app.users.domain;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.web.multipart.MultipartFile;

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

	private Long boardNo;

	private Long fk_categoryNo;

	private String boardName;

	private String boardContent;

	private LocalDateTime createdAtBoard;
	
	private LocalDateTime updatedAtBoard;
	
	private int readCount;

	private String fk_id;

	private String boardFileName;

	private String boardFileOriginName;

	private int boardDeleted ;
	
	private Users users;
	
	private String name;
	
	// 스마트 에디터로 글 작성 시 Jsoup를 통한 텍스트 및 이미지 경로 저장
	private String boardContentText;
	private String boardContentImg;
	
	// 날짜 포맷 메소드
	public String getCreatedAtBoardFormatted() {
	    if (createdAtBoard == null) return "";
	    return createdAtBoard.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	}
	
	public String getUpdatedAtBoardFormatted() {
	    if (updatedAtBoard == null) return "";
	    return updatedAtBoard.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	}
	
	
	private MultipartFile attach;
	/*
		form 태그에서 type="file" 인 파일을 받아서 저장되는 필드이다. 
		진짜파일 ==> WAS(톰캣) 디스크에 저장됨.
		조심할것은 MultipartFile attach 는 오라클 데이터베이스 tbl_board 테이블의 컬럼이 아니다.
		/myspring/src/main/webapp/WEB-INF/views/mycontent1/board/add.jsp 파일에서 input type="file" 인 name 의 이름(attach) 과 
		동일해야만 파일첨부가 가능해진다.!!!!           
	*/
	
}
