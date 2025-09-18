package com.spring.app.entity;

import java.time.LocalDateTime;

import com.spring.app.admin.domain.ReportDTO;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name="report")
@Getter               
@Setter               
@AllArgsConstructor   
@NoArgsConstructor    
@Builder			  
@ToString
public class Report {
	
	@Id
	@Column(name = "reportno", columnDefinition = "NUMBER")
	@SequenceGenerator(name = "REPORT_SEQ_GENERATOR", sequenceName = "report_seq", allocationSize = 1)
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "REPORT_SEQ_GENERATOR")
	private Long reportNo;
	
	@ManyToOne
	@JoinColumn(name = "fk_id", referencedColumnName = "id", nullable = false)
	private Users users;	// Users 엔티티와 연결
	
	@ManyToOne
	@JoinColumn(name = "fk_boardno", referencedColumnName = "boardno", nullable = false)
	private Board board;	// Board 엔티티와 연결
	
	@Column(name = "reportreason", nullable = false, length = 500, updatable = false)
	private String reportReason;
	
	@Column(name="reportstatus",nullable = false, columnDefinition = "NUMBER DEFAULT 0", insertable = false, updatable = false) // 이 필드는 columnDefinition = "NUMBER DEFAULT 0" 으로 되어 있어서 INSERT 시 제외시켜도 괜찮음. 또한 UPDATE 도 할 수 없도록 제외시킴.
	private int reportStatus;
	
	@Column(name="createdatreport", nullable = false, updatable = false) // 이 필드는 UPDATE 는 할 수 없도록 제외시킴. 즉, 한번 데이터 입력 후 reg_date 컬럼의 값은 수정 불가라는 뜻이다.
	private LocalDateTime createdAtReport;
	
	
	@PrePersist 
	public void PrePersist() {
		 if (this.createdAtReport == null) {
	            this.createdAtReport = LocalDateTime.now();
	        }
	}
	
	
	public ReportDTO toDTO() {
		
		return ReportDTO.builder()
				.reportNo(reportNo)
				.fk_id(users != null ? users.getId() : "" )
				.fk_boardno(board != null ? board.getBoardNo() : 0L)
				.board(board)
				.users(users)
				.reportReason(reportReason)
				.reportStatus(reportStatus)
				.createdAtReport(createdAtReport)
				.build();
	}
	
}
