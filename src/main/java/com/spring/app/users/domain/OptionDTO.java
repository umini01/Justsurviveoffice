package com.spring.app.users.domain;



import com.spring.app.entity.Category;
import com.spring.app.entity.Question;

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
public class OptionDTO {

	
	private Long optionNo;

	private Long fk_questionNo;

	private String optionText;

	private Long fk_categoryNo;
	
	private Question question;
	
	private Category category;
	
}
