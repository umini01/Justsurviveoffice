package com.spring.app.bookmark.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.bookmark.domain.BookMarkDTO;
import com.spring.app.bookmark.service.BookmarkService;
import com.spring.app.users.domain.UsersDTO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/bookmark/")
public class BookmarkController {

    private final BookmarkService bookMarkService;

    // 북마크 추가
    @ResponseBody // JSON 으로 전달할 경우, key value 로 전달하기 위해 어노테이션 필수!
    @PostMapping("add")
    public Map<String, Object> addBookmark(@RequestParam(name="fk_boardNo") Long fk_boardNo,
    								HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            result.put("notLogin", true);
            result.put("message", "로그인이 필요한 서비스입니다.");
            return result;
        }
    	
        int n = bookMarkService.addBookmark(loginUser.getId(), fk_boardNo);
        
    	if(n==1) {
        	result.put("success", true);
            //result.put("message", "북마크가 추가되었습니다.");
		}
        return result;
    }

    // 북마크 삭제
    @ResponseBody // JSON 으로 전달할 경우, key value 로 전달하기 위해 어노테이션 필수!
    @PostMapping("remove")
    public Map<String, Object> removeBookmark(@RequestParam(name="fk_boardNo") Long fk_boardNo,
                                             HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            result.put("notLogin", true);
            result.put("message", "로그인이 필요한 서비스입니다.");
            return result;
        }
        
        int n = bookMarkService.removeBookmark(loginUser.getId(), fk_boardNo);
        
        if(n==1) {
        	result.put("success", true);
        }
        return result;
    }

    // 마이페이지 북마크 목록
    @GetMapping("mypage")
    public String getBookmarks(HttpSession session, Model model) {
        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "login/loginForm";

        return "mypage/bookmarks";
    }
    
    // 마이페이지 북마크 목록 스크롤
    @GetMapping("bookmarksMore")
    @ResponseBody
    public List<BookMarkDTO> bookmarksMore(HttpSession session,
    									   @RequestParam(name="id") String id,
                                           @RequestParam(name="start") int start,
                                           @RequestParam(name="len") int len) {
        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("id", loginUser.getId());
        paramMap.put("start", start);
        paramMap.put("len", len);

        return bookMarkService.bookmarkScroll(paramMap);
    }
    
}