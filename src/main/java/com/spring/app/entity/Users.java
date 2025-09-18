package com.spring.app.entity;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;

import com.spring.app.common.AES256;
import com.spring.app.users.domain.UsersDTO;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "users")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class Users {

	@Id
	@Column(name = "id", nullable = false, length = 50)
	private String id;
	
	@Column(nullable = false, length = 30)
	private String name;
	
	@Column(nullable = false, length = 255)
	private String password;
	
	@Column(nullable = false, length = 50)
	private String email;
	
	@Column(nullable = false, length = 40)
	private String mobile;
	
	@Column(nullable = false) // int형은 자동으로 0이 디폴트값임!!
	private int point;
	
	@Column(name ="role", columnDefinition = "varchar(20) default 'USER",
			nullable = false, length = 20)
	private String role;

// insertable = false 로 설정하면 엔티티 저장(insert)시 이 필드를 빼라는 말이다.
// updatable = false 로 설정하면 엔티티 변경(update)이 안되게 한다는 뜻이다.
	@Column(nullable = false, columnDefinition = "DATE DEFAULT SYSDATE",
  		    insertable = false, updatable = false)  
	private LocalDateTime registerday;
	
	@Column(name = "passwordchanged",
			nullable = false, columnDefinition = "DATE DEFAULT SYSDATE",
			insertable = false)
	private LocalDateTime passwordChanged;
	
	@Column(name = "isdormant",
			nullable = false, columnDefinition = "NUMBER DEFAULT 0",
			insertable = false)
	private int isDormant;
			
	@Column(name = "isdeleted",
			nullable = false, columnDefinition = "NUMBER DEFAULT 0",
			insertable = false)
	private int isDeleted;
	
	@ManyToOne // 외래키 제약을 걸고 싶을 때 추가!
	@JoinColumn(name = "FK_CATEGORYNO", referencedColumnName = "CATEGORYNO", nullable = true)
	private Category category;

	
	
	public UsersDTO toDTO() {
		return UsersDTO.builder()
					   .id(this.id)
					   .name(this.name)
					   .password(this.password)
					   .email(this.email)
					   .mobile(this.mobile)
					   .point(this.point)
					   .role(this.role)
					   .registerday(this.registerday)
					   .passwordChanged(this.passwordChanged)
					   .category(this.category)
					   .isDormant(this.isDormant)
					   .isDeleted(this.isDeleted)
					   .build();
	}
	
	
}
