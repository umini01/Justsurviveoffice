package com.spring.app.mypage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.admin.service.AdminService;
import com.spring.app.board.domain.BoardDTO;
import com.spring.app.board.service.BoardService;
import com.spring.app.category.domain.CategoryDTO;
import com.spring.app.users.domain.UsersDTO;
import com.spring.app.users.service.UsersService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("mypage/")
public class MyPageController {

    private final UsersService usersService;
    private final BoardService boardService;
    
    
    private final AdminService adminService;

    // 내정보 화면
    @GetMapping("info")
    public String info() {
        return "users/mypage/info";
    }

    // 내가 작성한 글 목록
    @GetMapping("forms")
    public String myBoardList(HttpSession session, Model model) {
        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "login/loginForm";
        }

        return "users/mypage/forms";
    }
    
    // 내가 작성한 글 목록 스크롤
    @GetMapping("myBoardsMore")
    @ResponseBody
    public List<BoardDTO> myBoardsMore(@RequestParam(name="id") String id,
                                       @RequestParam(name="start") int start,
                                       @RequestParam(name="len") int len) {
    	
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("id", id);
        paramMap.put("start", start);
        paramMap.put("len", len);
        
        List<BoardDTO> boardList = boardService.myBoardsScroll(paramMap);
        
        return boardList;
    }
    

    // 북마크 목록
    @GetMapping("bookmarks")
    public String myBookmarks(HttpSession session, Model model) {
        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "login/loginForm";
        }

        model.addAttribute("myBookmarks", boardService.getBookmarksById(loginUser.getId()));
        return "users/mypage/bookmarks";
    }

    // 회원 정보 수정
    @PostMapping("update")
    public String update(UsersDTO userDto, HttpServletRequest request, HttpSession session) {
        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");

        //입력한 이메일이 다른 사용자의 이메일인지 체크하기
        boolean emailDuplicate = usersService.isEmailDuplicated(userDto.getEmail());
        
        // 중복된 이메일이면서, 로그인한 사용자의 이메일도 아닐때 (에러)
        if(emailDuplicate && !loginUser.getEmail().equals(userDto.getEmail())) {
        	request.setAttribute("message", "이미 사용 중인 이메일입니다");
            request.setAttribute("loc", request.getContextPath()+"/mypage/info");
            
            return "msg";
        }
        
        // 중복된 이메일이 아니면 회원정보 업데이트
        UsersDTO updatedUser = usersService.updateUser(userDto);
	
        	
        // 세션 갱신
        session.setAttribute("loginUser", updatedUser);

        String message = "정보가 변경되었습니다.";
        String loc = request.getContextPath() + "/mypage/info";

        request.setAttribute("message", message);
        request.setAttribute("loc", loc);

        return "msg";
    }

    
    // 이메일 중복확인
    @GetMapping("emailDuplicate")
    @ResponseBody
    public Map<String, Object> emailDup(@RequestParam(name = "email") String email, HttpSession session) {
    	Map<String, Object> paraMap = new HashMap<>();

        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");

        // 현재 로그인한 사용자 이메일은 중복으로 보지 않음
        if (loginUser != null && email.equals(loginUser.getEmail())) {
        	paraMap.put("duplicated", false);
        	paraMap.put("message", "현재 사용 중인 이메일입니다.");
            return paraMap;
        }

        boolean duplicated = usersService.isEmailDuplicated(email);

        if (duplicated) {
        	paraMap.put("duplicated", true);
        	paraMap.put("message", "이미 사용 중인 이메일입니다.");
        } else {
        	paraMap.put("duplicated", false);
        	paraMap.put("message", "사용 가능한 이메일입니다.");
        }

        return paraMap;
    }
    
    // 회원 탈퇴
    @PostMapping("quit")
    @ResponseBody
    public Map<String, Object> delete(@RequestParam(name = "id") String id, HttpSession session) {
    	
    	Map<String, Object> paraMap = new HashMap<>();

        try {
            int result = usersService.delete(id);

            if (result == 1) {
                session.invalidate();  //  로그아웃
                paraMap.put("success", true);
                paraMap.put("message", "회원 탈퇴가 완료되었습니다.");
            } else {
            	paraMap.put("success", false);
            	paraMap.put("message", "회원 탈퇴에 실패했습니다. 다시 시도해주세요.");
            }
        } catch (Exception e) {
        	e.printStackTrace();
        	paraMap.put("success", false);
        	paraMap.put("message", "서버 에러가 발생했습니다.");
        }

        return paraMap;
    }

   
    
    
    // 마이페이지 내 통계로 이동
    @GetMapping("chart")
    public String chartForm() {
        return "users/mypage/chart";
    }
    
	
	// 카테고리별 게시물 통계
    @PostMapping("chart/categoryByBoard")
    @ResponseBody 
    public List<CategoryDTO> categoryByBoard() {
    	List<CategoryDTO> boardPercentageList = usersService.categoryByBoard(); 
    	return boardPercentageList;
    }
	 
    
    // 카테고리별 인원수 통계
    @PostMapping("chart/categoryByUsers")
    @ResponseBody
    public List<CategoryDTO> categoryByUsers() {
    	List<CategoryDTO> usersPercentageList = usersService.categoryByUsers(); 
    	return usersPercentageList;
    }
    
    
	// 마이페이지 게시글 복구하기
    @GetMapping("myBoardRecovery")
    @ResponseBody
    public int myBoardRecovery(@RequestParam(name = "boardNo") String boardNo) {
    	int data = boardService.recoveryBoard(boardNo);
    	return data;
    }
    
    
    
}