package com.spring.app.entity;

import java.time.LocalDateTime;

import com.spring.app.bookmark.domain.BookMarkDTO;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name="bookmark")
@Getter               
@Setter               
@AllArgsConstructor   
@NoArgsConstructor    
@Builder			  
@ToString
public class Bookmark {

	  	@Id
		@Column(name="bookmarkno", columnDefinition = "NUMBER") 
		@SequenceGenerator(name="BOOKMARK_SEQ_GENERATOR", sequenceName = "bookmark_seq", allocationSize = 1)
		@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "BOOKMARK_SEQ_GENERATOR")
	  	private Long bookmarkNo;
	  	
		@Column(name="fk_id", nullable = false, length = 50, updatable = false)
		private String fk_id;
		

		@Column(name="fk_boardno", columnDefinition = "NUMBER") 
		private Long fk_boardNo;
		
		@Column(name="createatmark", nullable = false, updatable = false)
		private LocalDateTime createdAtMark;	
	    
	 // 연관관계 정의
		@ManyToOne
		@JoinColumn(name = "fk_id", referencedColumnName = "id", insertable=false, updatable=false) 
		private Users users; 
		
		@ManyToOne
		@JoinColumn(name = "fk_boardno", referencedColumnName = "boardNo", insertable=false, updatable=false) 
		private Board board; 
		
		
		@PrePersist 
		public void createdAtMark() {
			 if (this.createdAtMark == null) {
		            this.createdAtMark = LocalDateTime.now();
		        }
		}
	
	 			
	
	 // Entity 를 DTO로 변환하기 
		public BookMarkDTO toDTO() {
		
			return BookMarkDTO.builder()
					.bookmarkNo(bookmarkNo)
					.fk_id(this.fk_id)
					.fk_boardNo(this.fk_boardNo)
					.createdAtMark(createdAtMark)
					.build();
				
		}
	    
	    
	
}
