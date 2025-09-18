package com.spring.app.entity;

import java.time.LocalDateTime;

import com.spring.app.comment.domain.CommentDTO;
import com.spring.app.users.domain.UsersDTO;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;


@Entity
@Table(name = "comments")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class Comments {

	@Id
	@Column(name="commentno", columnDefinition = "NUMBER") 
	@SequenceGenerator(name="Comment_SEQ_GENERATOR", sequenceName = "comment_seq", allocationSize = 1)
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Comment_SEQ_GENERATOR")
	private Long commentNo;

	@Column(name="content",nullable = false, length = 1000)
	private String content;
	
	@Column(name="parentno" ,nullable = false) // int형은 자동으로 0이 디폴트값임!!
	private Long parentNo;
	
	@Column(name = "createdatcomment",
			nullable = false, columnDefinition = "DATE DEFAULT SYSDATE",
			insertable = false)
	private LocalDateTime createdAtComment;
	
	
	@Column(name="fk_name",nullable = false, length = 30)
	private String fk_name;
	
	@ManyToOne // 외래키 제약을 걸고 싶을 때 추가!
	@JoinColumn(name = "FK_ID", referencedColumnName = "ID", nullable = true)
	private Users users;


	@ManyToOne // 외래키 제약을 걸고 싶을 때 추가!
	@JoinColumn(name = "FK_BOARDNO", referencedColumnName = "boardNo", nullable = true)
	private Board board;

	public CommentDTO toDTO() {
		return CommentDTO.builder()
					   .commentNo(commentNo)
					   .content(content)
					   .parentNo(parentNo)
					   .createdAtComment(createdAtComment)
					   .fk_name(fk_name)
					   .users(users)
					   .board(board)
					   .build();
	}
	
	
}