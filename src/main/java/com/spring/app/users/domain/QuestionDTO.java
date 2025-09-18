package com.spring.app.users.domain;

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
public class QuestionDTO {

	private Long questionNo;

	private String questionContent;

}
