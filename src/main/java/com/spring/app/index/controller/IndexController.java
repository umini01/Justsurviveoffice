package com.spring.app.index.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.app.board.domain.BoardDTO;
import com.spring.app.board.service.BoardService;
import com.spring.app.category.domain.CategoryDTO;
import com.spring.app.users.service.UsersService;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor // final 인스턴스 생성자 처리해주기
@Controller
@RequestMapping("/")
public class IndexController {

	private final UsersService service;
	private final BoardService boardService;
	
	@GetMapping("")
	public String start() {
		return "redirect:/index";
	}

	// 0901 김윤호 인덱스 불러오기 수정 완료
	@GetMapping("index")
	public String index(HttpServletRequest request, 
			  			HttpServletResponse response,
			   			Model model
						) {
		/* 0825 인덱스 카테고리 자동으로 보이기 시작 - 김예준 */
		List<CategoryDTO> IndexList = boardService.getIndexList();
		model.addAttribute("IndexList", IndexList);
		/* 0825 인덱스 카테고리 자동으로 보이기 끝 - 김예준 */ // index.jsp 에서 카테고리번호는 의미 없는 것 같아서 삭제했습니다.
		
	    // Hot 게시글 리스트 (조회수 많은 순)
	    List<BoardDTO> hotReadList = boardService.getTopBoardsByViewCount();
	    model.addAttribute("hotReadList", hotReadList);
	      
	    // 댓글 많은 게시글 리스트
	    List<BoardDTO> hotCommentList = boardService.getTopBoardsByCommentCount();
	    model.addAttribute("hotCommentList", hotCommentList);
		
		
		return "index";
	}
	
	// footer 개인정책 jsp
    @GetMapping("privacy/privacy")
    public String privacyPolicy() {
        return "privacy/privacy";
    }
    
    // footer 오시는 길 jsp
    @GetMapping("privacy/location")
    public String location() {
        return "privacy/location";
    }
    
    // footer 회사소개 jsp
    @GetMapping("company/company")
    public String company() {
        return "company/company";
    }
	
	@GetMapping("users/list")
	public String memberList() {
		return "users/list";
		//	/WEB-INF/views/users/list.jsp 파일을 만들어야 한다.
	}
	
	
}
