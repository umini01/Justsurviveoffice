package com.spring.app.comment.domain;

import java.time.LocalDateTime;

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
public class CommentLikeDTO {
	
	private String fk_id;

	private Long fk_commentNo;

}
