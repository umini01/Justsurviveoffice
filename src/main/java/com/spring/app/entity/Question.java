package com.spring.app.entity;


import com.spring.app.users.domain.QuestionDTO;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "question")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class Question {
	
	@Id
	@Column(name="questionNo", columnDefinition = "NUMBER") 
	@SequenceGenerator(name="Question_SEQ_GENERATOR", sequenceName = "question_seq", allocationSize = 1)
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Question_SEQ_GENERATOR")
	private Long questionNo;
	
	@Column(nullable = false, length = 255)
	private String questionContent;
	
	
	public QuestionDTO toDTO() {
		return QuestionDTO.builder()
					   .questionNo(questionNo)
					   .questionContent(questionContent)
					   .build();
	}

	
	
}
