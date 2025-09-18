package com.spring.app.entity;

import com.spring.app.users.domain.OptionDTO;

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
@Table(name = "options")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class Options {
	
	@Id
	@Column(name="optionno", columnDefinition = "NUMBER") 
	@SequenceGenerator(name="Option_SEQ_GENERATOR", sequenceName = "options_seq", allocationSize = 1)
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Option_SEQ_GENERATOR")
	private Long optionNo;
	
	@Column(name="optiontext", nullable = false, length = 200, updatable = false)
	private String optionText;
	
  @ManyToOne
    @JoinColumn(name = "FK_QUESTIONNO", referencedColumnName = "QUESTIONNO", nullable = true)
    private Question question;

	@ManyToOne
	@JoinColumn(name = "FK_CATEGORYNO", referencedColumnName = "CATEGORYNO", nullable = true)
	private Category category;
	
	
	// Entity 를 DTO로 변환하기 
	public OptionDTO toDTO() {
		
		return OptionDTO.builder()
            .optionNo(optionNo)
            .optionText(optionText)
            .question(question)
            .category(category)
            .build();	
	}


}
