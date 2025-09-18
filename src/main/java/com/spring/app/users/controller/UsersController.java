package com.spring.app.users.controller;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.users.domain.LoginHistoryDTO;
import com.spring.app.common.Sha256;

import com.spring.app.entity.Users;
import com.spring.app.mail.controller.GoogleMail;
import com.spring.app.users.domain.LoginHistoryDTO;
import com.spring.app.users.domain.UsersDTO;
import com.spring.app.users.service.UsersService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("users/")
@RequiredArgsConstructor  //Lombok이 제공하는 기능으로,final이나 @NonNull이 붙은 필드를 대상으로 생성자를 자동 생성
public class UsersController {

	private final UsersService usersService; //@RequiredArgsConstructor를 선언해야만 자동으로 fianl 생성자 생성.
	private final GoogleMail mail;
	
	@GetMapping("loginForm")
	public String login() {
		return "login/loginForm";
	}
	
	@PostMapping("login")	
	public String loginEnd(@RequestParam(name="id") String id,
	                       @RequestParam(name="password") String Pwd,
	                       HttpServletRequest request,
	                       HttpServletResponse response) {

	    UsersDTO usersDto = usersService.getUser(id, Pwd); 

	    String enPwd;
	    try {
	    	enPwd = Sha256.encrypt(Pwd);
	    	
	    } catch (Exception e) {
	        request.setAttribute("message", "암호화 실패!!");
	        request.setAttribute("loc", request.getContextPath()+"/users/loginForm");
	        return "msg";
	    }

	    if (usersDto == null || !enPwd.equalsIgnoreCase(usersDto.getPassword())) {
	        request.setAttribute("message", "로그인 실패!");
	        request.setAttribute("loc", request.getContextPath()+"/users/loginForm");
	        return "msg";
	    }

	    usersDto.setPassword(null);
	    
	    boolean isDormant = usersService.updateDormantStatus(id);

	    if (isDormant || usersDto.getIsDormant() == 1) {
	    	String message = "비밀번호 변경이 1년이 지나 휴면 처리되었습니다. 비밀번호를 변경해주세요. ";
			request.setAttribute("message", message);
			String loc = request.getContextPath() + "/login/pwdUpdate?id=" + id; // 변경 페이지로 이동할 링크

		    request.setAttribute("message", message);
		    request.setAttribute("loc", loc);

		    return "msg";
	    }

	    HttpSession session = request.getSession();
	    session.setAttribute("loginUser", usersDto);
	    
	    UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
	    

	    LoginHistoryDTO loginHistoryDTO = LoginHistoryDTO.builder()
							             .lastLogin(LocalDateTime.now())
							             .ip(request.getRemoteAddr())
							             .users(usersService.toEntity(usersDto))
							             .build();
	    
	    usersService.saveLoginHistory(loginHistoryDTO);
	    System.out.println("로그인 아이디 : " + loginUser.getId());
	    return "redirect:/index";
	}
	
	@GetMapping("logout")
	public String loginout(HttpServletRequest request) {
	      
		HttpSession session = request.getSession();
		session.invalidate();
	      
		String message = "로그아웃 되었습니다.";
		String loc = request.getContextPath()+"/";  // 시작 페이지로 이동
	                
		request.setAttribute("message", message);
		request.setAttribute("loc", loc);
		return "msg";
	}
	
	@GetMapping("register")
	public String register() {
		return "users/register";
	}
	
	// 회원가입 약관 (iframe 용)
    @GetMapping("/agree")
    public String agreePage() {
        return "users/agree";
    }
	
	@PostMapping("registerUser")
    public String registerUser(
			    		@RequestParam(name="id") String id,
			            @RequestParam(name="password") String Pwd,
    					@RequestParam(name="hp1") String hp1,
                        @RequestParam(name="hp2") String hp2,
                        @RequestParam(name="hp3") String hp3,
                        Users user, 
                        HttpServletRequest request, HttpSession session) {
       // 연락처 합치기
       String mobile = hp1 + hp2 + hp3;
       user.setMobile(mobile);

       try {
          // 회원가입
          usersService.registerUser(user);
          UsersDTO usersDto = usersService.getUser(id, Pwd);
          // 세션에 로그인 정보 저장
          session.setAttribute("loginUser", usersDto);
          return "redirect:/index";
          
       } catch (Exception e) {
          e.printStackTrace();
          String message = "회원가입 실패!!";
          String loc = request.getContextPath()+"/login/register"; // 로그인 페이지로 이동

          request.setAttribute("message", message);
          request.setAttribute("loc", loc);
          return "msg";
       }
    }

	@GetMapping("idFind")
	public String idFind() {
		return "login/idFind";
	}
	
	@PostMapping("idFind")
	public String idFind(@RequestParam(name="name") String name, // form 태그의 name 속성값과 같은것이 매핑되어짐
			   			 @RequestParam(name="email") String email,
			   			 Model model,
			   			 HttpServletRequest request) {

	    UsersDTO usersDTO = usersService.getIdFind(name, email);

		String message = "없습니다 되었습니다.";
		String loc = request.getContextPath()+"/";  // 시작 페이지로 이동
	    
	    if (usersDTO != null) {
	        model.addAttribute("usersDTO", usersDTO.getId());
	    } 
	    
	    request.setAttribute("method", "POST");

	    return "login/idFind"; // 기존 뷰
	}
	
	@GetMapping("pwdFindForm")
	public String pwdFind(HttpSession session, HttpServletRequest request) {
		
		// 세션에 값이 있으면 jsp 에 전달, 없으면 빈 값
		String id = (String) session.getAttribute("pwdFindId");
		String email = (String) session.getAttribute("pwdFindEmail");
		
		request.setAttribute("id", id != null ? id : "");
	    request.setAttribute("email", email != null ? email : "");
		
		return "login/pwdFind";
	}
	
	
	@PostMapping("passwordFind")
	public String passwordFind(@RequestParam(name="id") String id,
							   @RequestParam(name="email") String email,
							   HttpServletRequest request, HttpSession session) {
		
		// 1. 유저 존재 여부 확인
        Users users = usersService.findByIdAndEmail(id, email);

        if(users == null) {
        	request.setAttribute("n", 0);
            request.setAttribute("method", "POST");
            return "login/pwdFind"; 
        }
        
        // 2. 인증코드 생성 (6자리 랜덤 숫자)
        String certification_code = String.valueOf((int)(Math.random() * 900000) + 100000);

        // 3. 세션에 저장 
        session.setAttribute("certification_code", certification_code);
        
        // 4. 메일 전송
        try {
        	mail.send_certification_code(email, certification_code);
        	
			request.setAttribute("n", 1); 
        	
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("n", 0);
        }

        // JSP에서 보여줄 값 세팅
        request.setAttribute("id", id);
        request.setAttribute("email", email);
        request.setAttribute("method", "POST");

        return "login/pwdFind";
	}
	
	
	@PostMapping("verifyCertification")
	public String verifyCertification(@RequestParam(name="userCertificationCode") String userCertificationCode,
            						  @RequestParam(name="id") String id,
            						  HttpSession session,
            						  HttpServletRequest request) {
		
		String certification_code = (String) session.getAttribute("certification_code");
		
		String message = "";
		String loc = "";
		
		if(certification_code != null && certification_code.equals(userCertificationCode)) {
			
			message = "인증이 성공되었습니다.";
			loc = request.getContextPath() + "/users/pwdUpdate?id=" + id;
			
		}
		else {
			
			message = "발급된 인증코드가 아닙니다. 인증코드를 다시 발급받으세요.";
			loc = request.getContextPath() + "/users/pwdFindForm";
			
		}
		
		request.setAttribute("id", id);
		request.setAttribute("message", message);
		request.setAttribute("loc", loc);

		session.removeAttribute("certification_code");
		
		return "msg";
	}
	
	
	@GetMapping("pwdUpdate")
	public String pwdUpdateForm(@RequestParam(name="id") String id
			      			  , Model model) {
		model.addAttribute("id", id);
		return "login/pwdUpdate";
	}
	
	
	@PostMapping("pwdUpdate")
	public String pwdUpdate(@RequestParam(name="id") String id
						  , @RequestParam(name="newPassword2") String newPassword
						  , HttpServletRequest request) {
		
		usersService.updatePassword(id, newPassword);
		
		String message = "비밀번호가 변경되었습니다.";
		String loc = request.getContextPath() + "/users/loginForm";
		
		request.setAttribute("message", message);
		request.setAttribute("loc", loc);
		
		return "msg";
	}
	
	@PostMapping("checkIdDuplicate")
	@ResponseBody
	public Map<String, Boolean> checkIdDuplicate(@RequestParam(name="id") String id) {
		
	    boolean isExists = usersService.isIdExists(id);

	    Map<String, Boolean> map = new HashMap<>();
	    map.put("isExists", isExists);

	    return map;
	}
	
	
	@PostMapping("checkEmailDuplicate")
	@ResponseBody
	public Map<String, Boolean> checkEmailDuplicate(@RequestParam(name="email") String email) {
		
	    boolean isExists = usersService.isEmailExists(email);

	    Map<String, Boolean> map = new HashMap<>();
	    map.put("isExists", isExists);

	    return map;
	}
	

}