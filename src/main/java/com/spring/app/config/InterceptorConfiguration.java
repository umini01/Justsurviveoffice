package com.spring.app.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.spring.app.interceptor.AdminLoginCheckInterceptor;
import com.spring.app.interceptor.LoginCheckInterceptor;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor // final 함수의 생성자 용도
public class InterceptorConfiguration implements WebMvcConfigurer{

	private final LoginCheckInterceptor loginCheckInterceptor;
	private final AdminLoginCheckInterceptor adminLoginCheckInterceptor;
	
//  addInterceptor() : 인터셉터를 등록해준다.
//  addPathPatterns() : 인터셉터를 호출하는 주소와 경로를 추가한다. 
//  excludePathPatterns() : 인터셉터 호출에서 제외하는 주소와 경로를 추가한다. 
    
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
	// 우리는 인터셉터 추가와 등록을 위한 메소드에, 등록(registry) 파라미터 활용.
		registry.addInterceptor(loginCheckInterceptor)
				.addPathPatterns("/**/*")
				.excludePathPatterns("/index",
								 	 "/users/**",
									 "/login/**",
									 "/board/listAll",
									 "/board/list/**",
									 "/board/view/**",
									 "/board/boardlike/**",
									 "/board/wordSearchShow/**",
									 "/bookmark/**",
									 "/comment/**",
									 "/admin/**",
									 "/categoryTest/**",
									 "categoryTest/survey/**",
	// Interceptor 가 /css/*, /js/**, /images/** 등의 정적(static) 자원까지 가로채고, 
	// 로그인하지 않은 사용자는 이런 리소스에 접근할 수 없게 되었기 때문에 반드시 포함.
			        		         "/bootstrap-4.6.2-dist/**",
			        		         "/js/**",
			        		         "/css/**",
			        	             "/images/**",
			        		         "/resources/**",
			        		         "/privacy/**",
			        		         "/company/**",
			        	             "/smarteditor/**",
			        	             "/report/**");
		
		registry.addInterceptor(adminLoginCheckInterceptor)
		.addPathPatterns("/admin/**")
		.excludePathPatterns(
				// Interceptor 가 /css/*, /js/**, /images/** 등의 정적 자원까지 가로채고, 
				// 로그인하지 않은 사용자는 이런 리소스에 접근할 수 없게 되었기 때문에 반드시 포함.
	        		         "/bootstrap-4.6.2-dist/**",
	        		         "/js/**",
	        		         "/css/**",
	        	             "/images/**",
							 "/smarteditor/**");
	}
	
	
}