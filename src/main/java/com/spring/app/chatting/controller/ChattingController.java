package com.spring.app.chatting.controller;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.locks.ReentrantLock;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.app.users.domain.UsersDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//=== (#웹채팅관련3) ===

@Controller
@RequestMapping("/chatting/")
public class ChattingController {

	@GetMapping("multichat")
	public String requiredLogin_multichat(HttpServletRequest request, HttpServletResponse response) { 
		
		return "chatting/multichat";
	}
	
	
}

