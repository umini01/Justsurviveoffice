
package com.spring.app.common;

import java.util.List;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.spring.app.board.domain.BoardDTO;
import com.spring.app.board.service.BoardService;

import lombok.RequiredArgsConstructor;

@ControllerAdvice(basePackages = "com.spring.app")
@RequiredArgsConstructor
public class GlobalModelAdvice {

	private final BoardService boardService;
	
	@ModelAttribute
    public void addHotLists(Model model) {
		
		// Hot 게시글 리스트 (조회수 많은 순)
		List<BoardDTO> hotReadList = boardService.getTopBoardsByViewCount();
		model.addAttribute("hotReadList", hotReadList);
		
		// 댓글 많은 게시글 리스트
		List<BoardDTO> hotCommentList = boardService.getTopBoardsByCommentCount();
		model.addAttribute("hotCommentList", hotCommentList);
		
    }
	
}
