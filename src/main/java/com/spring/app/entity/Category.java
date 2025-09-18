package com.spring.app.entity;

import com.spring.app.category.domain.CategoryDTO;

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
@Table(name = "category")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class Category {
	
	
	@Id
	@Column(name="categoryno", columnDefinition = "NUMBER") 
	@SequenceGenerator(name="CATEGORY_SEQ_GENERATOR", sequenceName = "category_seq", allocationSize = 1)
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "CATEGORY_SEQ_GENERATOR")
	private Long categoryNo;
	
	@Column(name="categoryname" ,nullable = false, length = 50)
	private String categoryName;
	
	@Column(name="categorydescribe" ,nullable = false, length = 200)
	private String categoryDescribe;	
	
	@Column(name="categoryimagepath" ,nullable = false, length = 255)
	private String categoryImagePath;
	
	public CategoryDTO toDTO() {
		return CategoryDTO.builder()
					   .categoryNo(categoryNo)
					   .categoryName(categoryName)
					   .categoryDescribe(categoryDescribe)
					   .categoryImagePath(categoryImagePath)
					   .build();
	}
	
	
	
	
}
