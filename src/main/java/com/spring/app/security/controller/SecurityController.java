package com.spring.app.security.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.app.security.filter.AdminOneTimeCode;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("admin/filter/")
@RequiredArgsConstructor
public class SecurityController {	// 추후 ADMIN 2차 보안이 필요할 시, 코드 사용 활성화.
/*	
	private final AdminOneTimeCode adminOneTimeCode;
	
	@GetMapping("adminPwd")
	public String mfaForm(@RequestParam(value = "error", required = false) String error, Model model) {
		
		if (error != null) model.addAttribute("error", "코드가 일치하지 않습니다.");
		
		return "admin/filter/adminPwd";
	}
	
	
	@PostMapping("adminPwd")
    public String verify(@RequestParam("code") String code, HttpServletRequest request) {
        if (adminOneTimeCode.current().equals(code)) {
        	request.getSession(true).setAttribute("ADMIN_MFA_OK", true);
            return "redirect:/admin/adm"; // 관리자 대시보드 등 원하는 경로
        }
        return "redirect:/admin/filter/adminPwd?error=1";
    }
*/	
}
