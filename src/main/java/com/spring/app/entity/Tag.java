package com.spring.app.entity;


import com.spring.app.users.domain.TagDTO;

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
@Table(name = "tag")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class Tag {

	@Id
	@Column(name="tagNo", columnDefinition = "NUMBER") 
	@SequenceGenerator(name="Tag_SEQ_GENERATOR", sequenceName = "tag_seq", allocationSize = 1)
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Tag_SEQ_GENERATOR")
	private Long tagNo;

	@Column(name="tagName", nullable = false, length = 50, updatable = false)
	private String tagName;
	
	@ManyToOne
	@JoinColumn(name = "FK_CATEGORYNO", referencedColumnName = "CATEGORYNO", nullable = true)
	private Category category;
	
	
	// Entity 를 DTO로 변환하기 
		public TagDTO toDTO() {
			
			return TagDTO.builder()
                .tagNo(tagNo)
                .fk_categoryNo(category != null ? category.getCategoryNo() : 0)
                .tagName(tagName)
                .category(category)
                .build();
    }
		
	

}
