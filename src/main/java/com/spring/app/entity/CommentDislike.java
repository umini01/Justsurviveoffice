package com.spring.app.entity;


import com.spring.app.comment.domain.CommentDislikeDTO;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "CommentDislike")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class CommentDislike {

	@Id
	@ManyToOne // 외래키 제약을 걸고 싶을 때 추가!
	@JoinColumn(name = "FK_ID", referencedColumnName = "ID", nullable = true)
	private Users users;

	
	@Id
	@ManyToOne // 외래키 제약을 걸고 싶을 때 추가!
	@JoinColumn(name = "FK_COMMENTNO", referencedColumnName = "commentNo", nullable = true)
	private Comments comment;

	
	
	 public CommentDislikeDTO toDTO() {
	        return CommentDislikeDTO.builder()
	                .fk_id(users.getId())
	                .fk_commentNo(comment.getCommentNo())
	                .build();
	    }
	
}
