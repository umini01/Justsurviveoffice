package com.spring.app.interceptor;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class LoginCheckInterceptor implements HandlerInterceptor {
	
	@Override
	public boolean preHandle(HttpServletRequest request, 
							  HttpServletResponse response,
							  Object handler) throws Exception {

		
		
		HttpSession session = request.getSession();
		
		if(session.getAttribute("loginUser") == null) {
			
			String message = "로그인이 필요한 서비스입니다";
			String loc = request.getContextPath()+"/users/loginForm";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
		
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/msg.jsp");
			// 브라우저 주소(URL)은 바뀌지 않은채, 요청과 응답의 제어를 다른 자원에 넘겨서
			// 서버 내부에서만 페이지 전환만 하도록 RequestDispatcher를 사용!
			dispatcher.forward(request, response);
			
			return false; 
		 // 세션에 로그인 유저가 없는 경우 요청 처리를 중단(false)한 후 포워딩.
		}
		return true; 
		 // 세션에 로그인 유저가 있는 경우 패스
	}
	
}