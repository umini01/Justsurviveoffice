package com.spring.app.entity;

import java.time.LocalDateTime;

import com.spring.app.users.domain.LoginHistoryDTO;

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
@Table(name = "loginHistory")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class LoginHistory {
	@Id
	@SequenceGenerator(
	  name = "SEQ_LOGIN_HISTORY_GENERATOR",
	  sequenceName = "LOGIN_HISTORY_SEQ",
	  allocationSize = 1
	)
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "SEQ_LOGIN_HISTORY_GENERATOR")
	@Column(name = "LOGINHISTORYNO", updatable = false, nullable = false)
	private Long loginHistoryNo;

	@Column(name = "LASTLOGIN",
			nullable = false, columnDefinition = "DATE DEFAULT SYSDATE",
			insertable = false)
	private LocalDateTime lastLogin;

	@Column(nullable = false)
	private String ip;

	
	@ManyToOne 
	@JoinColumn(name = "FK_ID", referencedColumnName = "id", nullable = true)
	private Users users;

	public LoginHistoryDTO toDTO() {
		return LoginHistoryDTO.builder()
							  .loginHistoryNo(this.loginHistoryNo)
							  .lastLogin(this.lastLogin)
							  .ip(this.ip)
							  .users(this.users)
							  .build();
	}
	
}
