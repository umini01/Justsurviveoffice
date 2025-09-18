package com.spring.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.scheduling.annotation.EnableScheduling;


@SpringBootApplication
@EnableAspectJAutoProxy  // Application 클래스에 @EnableAspectJAutoProxy 를 추가하여 AOP(Aspect Oriented Programming)클래스를 찾을 수 있게 해준다. 우리는 com.spring.app.aop.CommonAop 이 AOP 클래스 이다.
@EnableScheduling 		 // 스프링 스케줄러 기능을 사용하도록 해주는 것이다.
public class JustsurviveofficeApplication {

	public static void main(String[] args) {
		SpringApplication.run(JustsurviveofficeApplication.class, args);
	}

}
