package com.spring.app.security.filter;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AdminFilter extends OncePerRequestFilter {	// 추후 ADMIN 2차 보안이 필요할 시, 코드 사용 활성화.

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {
		
		String ctxPath = request.getContextPath();
		String uri = request.getRequestURI();
		
		// 2차비밀번호 페이지/액션은 통과
		String mfaForm = ctxPath + "/admin/filter/adminPwd";
		if (uri.equals(mfaForm)) {
			filterChain.doFilter(request, response);
			return;
		}
		
		// 관리자 영역만 검사
		if (uri.startsWith(ctxPath + "/admin/")) {
		    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		    boolean isAdmin = auth != null && auth.getAuthorities().stream()
					.map(GrantedAuthority::getAuthority)
					.anyMatch("ROLE_ADMIN"::equals);

		    if (isAdmin) {
				var session = request.getSession(false);
				boolean mfaOk = session != null && Boolean.TRUE.equals(session.getAttribute("ADMIN_MFA_OK"));
				if (!mfaOk) {
					response.sendRedirect(ctxPath + "/admin/filter/adminPwd"); // 아직 통과 전이면 2차 비밀번호 폼으로
					return;
		        }
		    }
		}
		
		filterChain.doFilter(request, response);
	}

}
