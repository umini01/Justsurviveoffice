package com.spring.app.users.domain;

import java.time.LocalDateTime;

import com.spring.app.entity.Category;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter               // private 으로 설정된 필드 변수를 외부에서 접근하여 사용하도록 getter()메소드를 만들어 주는 것.
@Setter               // private 으로 설정된 필드 변수를 외부에서 접근하여 수정하도록 setter()메소드를 만들어 주는 것.
@AllArgsConstructor   // 모든 필드 값을 파라미터로 받는 생성자를 만들어주는 것
@NoArgsConstructor    // 파라미터가 없는 기본생성자를 만들어주는 것
@Builder              // 생성자 대신, 필요한 값만 선택해서 체이닝 방식으로 객체를 만들 수 있게 해주는 것.
public class UsersDTO {
	
	private String id;
	private String name;
	private String password;
	private String email;
	private String mobile;
	private int point;
	private LocalDateTime registerday;
	private LocalDateTime passwordChanged;
	private int isDormant;
	private int isDeleted;
	private String role;
	
	private Category category;
	
}
