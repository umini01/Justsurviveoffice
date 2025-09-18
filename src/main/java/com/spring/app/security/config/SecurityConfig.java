package com.spring.app.security.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.session.HttpSessionEventPublisher;

import com.spring.app.security.filter.AdminFilter;
import com.spring.app.security.filter.SecurityUserFilter;

import lombok.RequiredArgsConstructor;

// 대사살 스프링 시큐리티03

@Configuration		// 스프링 컨테이너에 빈(Bean) 설정을 담는 클래스
// SecurityFilterChain = 스프링 시큐리티가 “요청 → 컨트롤러” 앞단에서 돌리는 필터들의 묶음(체인)
// @Bean으로 이 체인을 “어떤 요청은 허용/인증/권한/로그인 방식/CSRF 등”을 정책으로 설정
// 내가 이 빈을 안 만들면, 부트 기본 정책(거의 모든 요청 인증 필요, 기본 로그인 폼, 메모리 사용자)이 적용돼서 “다 막히는” 듯 보임!
@EnableWebSecurity	// 스프링 시큐리티를 활성화
// @EnableMethodSecurity	// 이 어노테이션은 URL 말고 "메소드" 단위로 권한을 걸고 싶을 때 쓴다! 지금은 관리자만 막으면되니까 주석처리
//@RequiredArgsConstructor	// final 필드들을 생성자 주입으로 자동 처리
public class SecurityConfig {
	
//	private final SecurityUserFilter securityUserFilter;
	
	// 해당 빈을 만든 이유 스프링부트 시작시 임시코드 알려주고 로그인 하라는데 이를 방지하기 위해서 추가했음
	@Bean
    public UserDetailsService userDetailsService() {
        // 사용자 0명짜리 InMemoryUserDetailsManager 등록
        // → Spring Boot가 "기본 계정"을 자동 생성하지 않음
        return new InMemoryUserDetailsManager();
    }
	
	
	// [추가] SessionRegistry Bean – 누가 어떤 세션을 쓰는지 관리하는 저장소
	@Bean
    public SessionRegistry sessionRegistry() {
        return new SessionRegistryImpl();
    }

    // [추가] 세션 소멸 이벤트를 Spring Security에 알려줌 (만료/로그아웃 시 정리)
    @Bean
    public HttpSessionEventPublisher httpSessionEventPublisher() {
        return new HttpSessionEventPublisher();
    }
	
	
	@Bean	// 이 메소드를 Bean 으로 정의하는 순간, 기본 설정 대신 내가 만든 정책이 적용
	public SecurityFilterChain filterChain(HttpSecurity http,
										   SecurityUserFilter securityUserFilter,
										   SessionRegistry sessionRegistry ) throws Exception{
		
		// SecurityFilterChain >> 스프링 시큐리티에서 제공하는 인터페이스
		// HTTP 요청이 컨트롤러로 들어오기 전에 여기서 거름망 작업!
		
		// CSRF - 사이트 간 요청 위조(Cross-Site Request Forgery) 공격
		/*
			사용자가 로그인해서 세션/쿠키가 살아있는 상태에서, 공격자가 만든 다른 사이트/스크립트를 통해 의도치 않은 요청이 서버로 전송되는 걸 막는 기술
		 	예시로 은행에 로그인 한다음 세션이나 쿠키가 남아있음
		 	어떤 악성 사용자가 만든 사이트로 이동했고 숨겨진 <form>이 있음 서버가 이걸 정상 사용자로 착각해서 정보 넘김
		 	그래서 POST, PUT, DELETE 같은 상태 변경 요청에는 CSRF 토큰이 꼭 필요
		*/
		// 지금은 비활성화 해주는 코드 작성 (대사살 프로젝트용)
		http
			.csrf((csrfConfig) -> csrfConfig
				.disable()
		);
		http.headers(headers -> headers
			    .frameOptions(frameOptions -> frameOptions.sameOrigin())
			); // 스마트 에디터가 막히는 것을 방지함!

		http.authorizeHttpRequests((auth) -> auth	// authorizeHttpRequests 는 스프링 시큐리티 DSL(도메인 특화 언어) 문법
													// 요청 URL 별로 접근 권한을 어떻게 줄지 설정하는 구간
				.requestMatchers("/admin/filter/**").permitAll()
				.requestMatchers("/admin/**").hasRole("ADMIN")	// requestMatchers() → 특정 URL 패턴을 지정
																// hasRole("네이밍") → "ROLE_네이밍" 권한이 있는 사용자만 접근 가능
				.anyRequest().permitAll()	// anyRequest() → requestMatchers(...) 로 지정하지 않은 나머지 모든 요청을 선택하는 예약 메소드
											// permitAll() → 그 요청은 누구나 접근 가능 (로그인 안 한 익명 사용자도 허용)
		);
		
        // UsernamePasswordAuthenticationFilter 는 아이디/비밀번호 로그인 처리를 맡는 기본 필터
		// addFilterBefore() -> 시큐리티에게 내 필터를 이 기준(시큐리티) 필터 앞에 추가하라는 것(커스텀 필터이므로)
		http.addFilterBefore(securityUserFilter, UsernamePasswordAuthenticationFilter.class);
        
		 // 관리자 MFA 강제 필터(브릿지 이후에 동작)
	//	http.addFilterAfter(new AdminFilter(), SecurityUserFilter.class);
		
		return http.build();	// 지금까지 설정한 보안 정책을 반영한 SecurityFilterChain Bean 을 반환
	}
	
}
