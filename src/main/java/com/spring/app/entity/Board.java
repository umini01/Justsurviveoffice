package com.spring.app.entity;

import java.time.LocalDateTime;

import com.spring.app.board.domain.BoardDTO;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name="board")
@Getter               
@Setter               
@AllArgsConstructor   
@NoArgsConstructor    
@Builder			  
@ToString
public class Board {
	
	@Id
	@Column(name="boardno", columnDefinition = "NUMBER") 
	@SequenceGenerator(name="BOARD_SEQ_GENERATOR", sequenceName = "board_seq", allocationSize = 1)
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "BOARD_SEQ_GENERATOR")
	private Long boardNo;
	
	@ManyToOne
    @JoinColumn(name = "fk_categoryno", referencedColumnName = "categoryNo", nullable = false)
    private Category category; // Category 엔티티와 연결
	
	@Column(name="boardname", nullable = false, length = 255, updatable = false)
	private String boardName;
	
	@Column(name="boardcontent", nullable = false, length = 1000, updatable = false)
	private String boardContent;
	
	@Column(name="createdatboard", nullable = false, updatable = false) // 이 필드는 UPDATE 는 할 수 없도록 제외시킴. 즉, 한번 데이터 입력 후 reg_date 컬럼의 값은 수정 불가라는 뜻이다.
	private LocalDateTime createdAtBoard;
	
	@Column(name = "updatedatboard", nullable = false)
	private LocalDateTime updatedAtBoard;
	
	@Column(name = "readcount" ,nullable = false, columnDefinition = "NUMBER DEFAULT 0", insertable = false, updatable = false) // 이 필드는 columnDefinition = "NUMBER DEFAULT 0" 으로 되어 있어서 INSERT 시 제외시켜도 괜찮음. 또한 UPDATE 도 할 수 없도록 제외시킴.
	private int readCount;
	

	@Column(name="fk_id", nullable = false, length = 50, updatable = false)
	private String fkId;
	

	@Column(name="boardfilename" ,nullable = false, length = 500)
	private String boardFileName;
	
	@Column(name="boardfileoriginname",nullable = false, length = 500)
	private String boardFileOriginName;

	@Column(name="boarddeleted",nullable = false, columnDefinition = "NUMBER DEFAULT 0", insertable = false, updatable = false) // 이 필드는 columnDefinition = "NUMBER DEFAULT 0" 으로 되어 있어서 INSERT 시 제외시켜도 괜찮음. 또한 UPDATE 도 할 수 없도록 제외시킴.
	private int boardDeleted;
	
	
	// 연관관계 정의
	@ManyToOne
	@JoinColumn(name = "fk_id", referencedColumnName = "id", insertable=false, updatable=false) 
	private Users users; 
	
	@PrePersist 
	public void createdAtBoard() {
		 if (this.createdAtBoard == null) {
	            this.createdAtBoard = LocalDateTime.now();
	        }
	}
	
	@PreUpdate 
	public void updatedAtBoard() {
        this.updatedAtBoard = LocalDateTime.now();
	}
	
	
	// Entity 를 DTO로 변환하기 
	public BoardDTO toDTO() {
		
		   return BoardDTO.builder()
	                .boardNo(boardNo)
	                .fk_categoryNo(category != null ? category.getCategoryNo() : 0)
	                .boardName(boardName)
	                .boardContent(boardContent)
	                .createdAtBoard(createdAtBoard)
	                .updatedAtBoard(updatedAtBoard)
	                .readCount(readCount)
	                .fk_id(fkId)
	                .boardFileName(boardFileName)
	                .boardFileOriginName(boardFileOriginName)
	                .boardDeleted(boardDeleted)
	                .users(users)
	                .build();
	    }
	

	
}