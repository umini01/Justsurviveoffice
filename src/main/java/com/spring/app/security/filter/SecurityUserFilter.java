package com.spring.app.security.filter;

import java.io.IOException;
import java.util.List;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.spring.app.users.domain.UsersDTO;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

// 대사살 스프링 시큐리티04

// 해당 클래스 만든 이유 -->> 기존 로그인 로직(세션 기반) 과 Spring Security의 권한체크 시스템을 연결(bridge)하기 위해서 필터 패키지에 만듬!
@Component
@RequiredArgsConstructor   // [변경] SessionRegistry 주입을 위해 추가
public class SecurityUserFilter extends OncePerRequestFilter {
	// OncePerRequestFilter > Filter 인터페이스 구현체인데, Spring Security에서 제공하는 편의 추상 클래스
	
	private final SessionRegistry sessionRegistry; // [추가]
	
	// OncePerRequestFilter 안에 정의된 메소드 오버라이드!
	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {
		
		
		// 시큐리티 인증이 아직 없을 때만 세션 확인
		if (SecurityContextHolder.getContext().getAuthentication() == null) {
			// SecurityContextHolder는 현재 스레드(요청 단위)에 보안 컨텍스트(SecurityContext)를 보관하는 곳
			/*
				웹 서버는 동시에 여러 명이 접속 -> /admin 같은 페이지를 요청
				만약 인증 정보를 하나의 전역 변수에 저장한다면? >> 권한 뒤죽박죽
				그래서 Spring Security 요청(Request)마다 별도의 스레드 사용 >> 이 스레드를 저장하는 서랍 = ThreadLocal 
				SecurityContextHolder = "현재 스레드의 보안 서랍을 열어보는 도구"
				내부에 ThreadLocal<SecurityContext> 가 있음 <<< 요청별 인증 상태 보관 해줌
			*/
			// .getContext().getAuthentication() >> Spring Security에서 현재 로그인한 사용자 정보를 꺼내는 표준 방법
			
			HttpSession session = request.getSession(false);	// 세션이 없으면 -> null 반환
			
			if (session != null) {
				UsersDTO user = (UsersDTO) session.getAttribute("loginUser");
				
				if (user != null) {
					
					
					// ✅ 관리자 동시 로그인 "차단" 로직 (핵심)
                    if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                        var existing = sessionRegistry.getAllSessions(user.getId(), false);
                        boolean hasOtherActive = existing.stream()
                                .anyMatch(si -> !si.getSessionId().equals(session.getId()) && !si.isExpired());

                        if (hasOtherActive) {
                            // 새 로그인(현재 세션)을 거절: 세션 날리고 로그인으로 돌려보냄
                            session.invalidate();
                            response.sendRedirect(request.getContextPath() + "/index?error=1");
                            return; // 더 진행하지 않음
                        }
                    }
					
					
					// role 정리: "ADMIN" → ROLE_ADMIN --->> config에 있는 hasRole("ADMIN") 코드가 앞에 ROLE_네이밍 이런식으로 비교하므로 가공함
					String role = "ROLE_" + user.getRole();
					
					var authorities = List.of(new SimpleGrantedAuthority(role));
					// var -> 지역 변수 타입 추론 문법(컴파일할 때 타입이 확정) 즉, 알아서 리스트 형태로 만들어줌
					// SimpleGrantedAuthority -> 스프링 시큐리티에서 제공하는 권한(Authority)을 표현하는 가장 단순한 구현체 클래스
					// 쓰는 이유 -> 스프링 시큐리티는 문자열이 아니라 객체 컬렉션(List<GrantedAuthority>) 로 권한을 관리하도록 설계되어 있음
					
					var auth = new UsernamePasswordAuthenticationToken(
							// UsernamePasswordAuthenticationToken -> 스프링 시큐리티에서 인증(Authentication)을 표현하는 구현체 클래스
							// 스프링 시큐리티는 "누가 요청을 보냈는지", "비밀번호 맞는지", "권한은 뭔지"를 다루기 위해 Authentication이라는 인터페이스를 정의함
							// 즉, "아이디/비밀번호 기반 인증 객체"
					        user.getId(),     // principal(사용자 아이디)
					        null,             // credentials 필요 없음(비밀번호 같은 인증수단)
					        authorities       // 권한(ROLE_ADMIN, ROLE_USER 등)
					);
					// auth 객체는 곧 "이 사용자는 인증됨 + ADMIN 권한 있음" 이라는 인증 토큰이 됨
					
					// auth.setDetails -> Authentication 인터페이스에는 getDetails() 라는 필드가 있음
					// 여기에 사용자 인증과 관련된 추가 정보(예: 클라이언트 IP, 세션 ID 등) 담음
					// 사용자, 비밀번호, 권환 외에 부가적인 정보를 넣는 코드라고 생각하면 된다.
					// WebAuthenticationDetailsSource().buildDetails(request) → 현재 요청(request)에서 IP, 세션ID 같은 걸 뽑아서 넣어줌
					// 보안 로그나 감사(audit)용
					auth.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
					
					// SecurityContext에 인증 저장
					// 해당 코드는 시큐리티가 "아, 이 요청은 로그인된 사용자네" 하고 인식하게 해줌
					SecurityContextHolder.getContext().setAuthentication(auth);
					
					// SessionRegistry 등록(중복 제거 후 등록)
                    sessionRegistry.removeSessionInformation(session.getId());
                    sessionRegistry.registerNewSession(session.getId(), user.getId());
					
				}
            }
        }
		// 다음 필터/컨트롤러로 요청을 보내줌
		// 안 하면 요청이 여기서 끝나고 응답이 나가버림
		// 그래서 대부분의 커스텀 필터 마지막 줄에는 항상 이 코드가 들어감
        filterChain.doFilter(request, response);
	}

}
