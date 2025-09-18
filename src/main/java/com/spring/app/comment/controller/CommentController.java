package com.spring.app.comment.controller;


import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.comment.domain.CommentDTO;
import com.spring.app.comment.service.CommentService;
import com.spring.app.pointlog.model.PointLogDAO;
import com.spring.app.users.domain.UsersDTO;
import com.spring.app.users.service.UsersService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/comment")
@RequiredArgsConstructor
public class CommentController {
	
	private final CommentService commentService;
	private final UsersService usersService;
	private final PointLogDAO pointLogDao;
	
	
	
	// 댓글 작성
	@PostMapping("writeComment")
	public String writeComment(ModelAndView modelview, 
								CommentDTO comment,
								Map<String, String> paraMap,
	                         	HttpSession session) {

	    UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
	    if (loginUser == null) {
	        return "redirect:/login";
	    }
	    
	    comment.setFk_id(loginUser.getId());
	    comment.setFk_name(loginUser.getName());

	    commentService.insertComment(comment);
	    
	    int cnt = pointLogDao.getCreatedAtLogCommentCnt(loginUser.getId());
	    if(cnt < 3) { // 유저가 하루동안 쓴 댓글이 3개 이하면 포인트 추가해주기!
	    	paraMap.put("id", loginUser.getId());
			paraMap.put("point", "300");
			
			// paraMap에 저장한 해쉬맵정보는, users용이기 때문에... 레포지토리로 보내야함.
			usersService.getPoint(paraMap); // 300point만큼 user 업데이트!
			pointLogDao.insertPointLogComment(paraMap); // log 도 남기기!
			
			// DB에 각각 update, insert가 끝났다면, 세션까지 포인트 바꿔주기!
			loginUser.setPoint(loginUser.getPoint()+300);
			session.setAttribute("loginUser", loginUser);
			
			System.out.println(loginUser.getPoint());
		} 
		else System.out.println(cnt+"만큼 작성하셨네요! 포인트 stop");
	    
	    return "redirect:/board/view?boardNo="+comment.getFk_boardNo();
	}

	 // 댓글 수정
    @PostMapping("/updateComment")
    public String updateComment( @RequestParam(name="commentNo") Long commentNo,
						            @RequestParam(name="content") String content,
		                            @RequestParam(name = "fk_boardNo") Long fkBoardNo,
						            HttpSession session) {

        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "login";
        }

        boolean result = commentService.updateComment(commentNo, content, loginUser.getId());
	 
        return "redirect:/board/view?boardNo=" + fkBoardNo;
        
    }
	
    //댓글삭제
    @PostMapping("deleteComment")
    @ResponseBody
    public ModelAndView deleteComment(ModelAndView modelview, 
    								 CommentDTO commentDto, HttpSession session) {
    	
        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        
        if(loginUser.getId().equals(commentDto.getFk_id())) { //로그인한 사용자의 아이디가 댓글작성자의 아이디와 같다면
        	
        	int n = commentService.deleteComment(commentDto.getCommentNo());
        	
        	if(n == 1) {
        		modelview.addObject("message", "댓글이 삭제되었습니다");
        	} else {
        		modelview.addObject("message", "이미 삭제된 댓글입니다.");
        	}
            String ctxPath = session.getServletContext().getContextPath();
        	
            modelview.addObject("loc", ctxPath + "/board/view?boardNo=" + commentDto.getFk_boardNo());
            modelview.setViewName("msg");

        	
        } else {
        	modelview.addObject("message", "접근 불가능한 경로입니다.");
			modelview.addObject("loc", "javascript:history.back()");
			modelview.setViewName("msg");

		}
        return modelview;  
	    
    }
    
    //대댓글 작성
    @PostMapping("/writeReply")
    @ResponseBody
    public Map<String, Object> writeReply(CommentDTO comment, HttpSession session) {

        Map<String, Object> result = new HashMap<>();

 	    UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
 	    
 	    if (loginUser == null) {
 	    	result.put("success", false);
 	        result.put("message", "로그인이 필요합니다.");
 	        return result;
 	    }

 	    comment.setFk_id(loginUser.getId());
 	    comment.setFk_name(loginUser.getName());
 
 	    int n = commentService.insertReply(comment);

 	    if (n == 1) {
 	    	
 	    	//  새로 생성된 commentNo 가져오기
 	        Long newCommentNo = comment.getCommentNo();
 	    	
 	        CommentDTO savedReply = commentService.getReplyById(newCommentNo); //대댓글에 commentNo 부여하기
 	        
 	       if(savedReply.getContent() == null) { //내용이 비어있다면
 	    	    savedReply.setContent("");
 	    	}
 	        
 	    	
 	        result.put("success", true);
 	        result.put("message", "대댓글 작성 성공!");
 	        result.put("reply", savedReply);
 	    } else {
 	        result.put("success", false);
 	        result.put("message", "대댓글 작성 실패!");
 	    }

 	    return result;
 	}
    
    
    //대댓글삭제
    @PostMapping("deleteReply")
    @ResponseBody
    public Map<String, Object> deleteReply(@RequestParam(name="commentNo") Long commentNo,
    								HttpSession session) {
    	
    	Map<String, Object> result = new HashMap<>();
        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        
        if (loginUser == null) {
	    	 result.put("success", false);
	        result.put("message", "로그인이 필요합니다.");
	        return result;
	    }
        
        	int n = commentService.deleteReply(commentNo); 
        	
        	if(n == 1) {
        		 result.put("success", true);
      	         result.put("message", "대댓글이 삭제되었습니다.");
      	    } else {
      	    	 result.put("success", false);
      	        result.put("message", "이미 삭제되었거나 존재하지 않는 댓글입니다.");
      	    }
            
        return result;  
	    
    }
    
    
    //댓글 좋아요
    @PostMapping("commentLike")
    @ResponseBody
    public Map<String, Object> commentLike(@RequestParam(name="commentNo") Long commentNo, HttpSession session) {
       
    	Map<String, Object> result = new HashMap<>();

        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        System.out.println("===> loginUser: " + loginUser);
        
        if (loginUser == null) { //로그인이 안되어있다면
            result.put("success", false);
            result.put("notLogin", true);
            result.put("message", "로그인이 필요한 서비스입니다.");
            return result;
        }
        
        String fk_id = loginUser.getId();
        System.out.println("===> fk_id: " + fk_id);
        

        // 싫어요가 눌려있으면 삭제
        if (commentService.iscommentDisliked(fk_id, commentNo)) {
            commentService.deleteCommentDislike(fk_id, commentNo);
        }

        // 좋아요가 눌러져있는지 확인
        boolean iscommentLiked = commentService.iscommentLiked(fk_id, commentNo);
        
        //이미 좋아요를 눌렀다면 
        if(iscommentLiked == true) {
        	commentService.deleteCommentLike(fk_id,commentNo); //좋아요 삭제
        	result.put("status", "unliked");
        } 
        else {//좋아요가 눌러져있지 않다면 좋아요 추가
        	commentService.insertCommentLike(fk_id,commentNo);
        	result.put("status", "liked");
        }
        
        // 현재 게시글의 좋아요/싫어요 수
        int commentLikeCount = commentService.getCommentLikeCount(commentNo);
        int commentDislikeCount = commentService.getCommentDislikeCount(commentNo);
        
        boolean newStatus = commentService.iscommentLiked(fk_id, commentNo); // 최신 상태 재조회

        result.put("success", true);
        result.put("commentLikeCount", commentLikeCount);
        result.put("commentDislikeCount", commentDislikeCount);

        return result;
    }
    
    
    //댓글 싫어요
    @PostMapping("commentDislike")
    @ResponseBody
    public Map<String, Object> commentDislike(@RequestParam(name="commentNo") Long commentNo, HttpSession session) {
       
    	Map<String, Object> result = new HashMap<>();

        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        System.out.println("===> loginUser: " + loginUser);
        
        if (loginUser == null) {
            result.put("success", false);
            result.put("notLogin", true);
            result.put("message", "로그인이 필요한 서비스입니다.");
            return result;
        }
        
        String fk_id = loginUser.getId();
        System.out.println("===> fk_id: " + fk_id);
        
     // 좋아요가 눌려있으면 좋아요를 삭제한 후 -> 싫어요 추가
        if (commentService.iscommentLiked(fk_id, commentNo)) {
            commentService.deleteCommentLike(fk_id, commentNo);
        }

        // 싫어요가 눌러져있는지 여부 확인
        boolean iscommentDisliked = commentService.iscommentDisliked(fk_id, commentNo);
        
        // 이미 싫어요를 눌렀다면?
        if(iscommentDisliked == true) {
        	commentService.deleteCommentDislike(fk_id,commentNo); //싫어요 삭제
        	result.put("status", "unliked");
        } 
        else { // 싫어요가 안눌러져있다면 싫어요 추가!
        	commentService.insertCommentDislike(fk_id,commentNo);
        	result.put("status", "disliked");
        }
        
        // 현재 게시글의 좋아요/싫어요 수
        int commentDislikeCount = commentService.getCommentDislikeCount(commentNo);
        int commentLikeCount = commentService.getCommentLikeCount(commentNo);
        
        boolean newStatus = commentService.iscommentDisliked(fk_id, commentNo); // 최신 상태 재조회

        result.put("success", true);
        result.put("commentDislikeCount", commentDislikeCount);
        result.put("commentLikeCount", commentLikeCount);

        return result;
    }
    
  //대댓글 좋아요
    @PostMapping("replyLike")
    @ResponseBody
    public Map<String, Object> replyLike(@RequestParam(name="commentNo") Long commentNo, HttpSession session) {
       
    	Map<String, Object> result = new HashMap<>();

        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        System.out.println("===> loginUser: " + loginUser);
        
        if (loginUser == null) {
            result.put("success", false);
            result.put("notLogin", true);
            result.put("message", "로그인이 필요한 서비스입니다.");
            return result;
        }
        
        String fk_id = loginUser.getId();
        System.out.println("===> fk_id: " + fk_id);
        
        
        // 싫어요가 눌려있으면 삭제한 후에 좋아요 추가 실행
           if (commentService.isreplyDisliked(fk_id, commentNo)) {
               commentService.deleteReplyDislike(fk_id, commentNo);
           }


       // 좋아요가 눌러져있는지 여부 확인
        boolean isreplyLiked = commentService.isreplyLiked(fk_id, commentNo);
        
        //이미 좋아요를 눌렀다면 좋아요 삭제
        if(isreplyLiked == true) {
        	commentService.deleteReplyLike(fk_id,commentNo);
        } 
        else { // 좋아요 추가
        	commentService.insertReplyLike(fk_id,commentNo);
        }
        
        // 현재 게시글의 좋아요/싫어요 수
        int replyLikeCount = commentService.getReplyLikeCount(commentNo);
        int replyDislikeCount = commentService.getReplyDislikeCount(commentNo);
        
        boolean newStatus = commentService.isreplyLiked(fk_id, commentNo); // 최신 상태 재조회

        result.put("success", true);
        result.put("status", isreplyLiked ? "unliked" : "liked");
        result.put("replyLikeCount", replyLikeCount);
        result.put("replyDislikeCount", replyDislikeCount);
        return result;
    }
    
    
    //대댓글 싫어요
    @PostMapping("replyDislike")
    @ResponseBody
    public Map<String, Object> replyDislike(@RequestParam(name="commentNo") Long commentNo, HttpSession session) {
       
    	Map<String, Object> result = new HashMap<>();

        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        System.out.println("===> loginUser: " + loginUser);
        
        if (loginUser == null) {
            result.put("success", false);
            result.put("notLogin", true);
            result.put("message", "로그인이 필요한 서비스입니다.");
            return result;
        }
        
        String fk_id = loginUser.getId();
        System.out.println("===> fk_id: " + fk_id);
        
        
        // 좋아요가 눌려있으면 삭제
           if (commentService.isreplyLiked(fk_id, commentNo)) {
               commentService.deleteReplyLike(fk_id, commentNo);
           }

       // 싫어요가 눌러져있는지 여부 확인
        boolean isreplyDisliked = commentService.isreplyDisliked(fk_id, commentNo);
        
        //싫어요를 이미 눌러놨다면 삭제
        if(isreplyDisliked == true) {
        	commentService.deleteReplyDislike(fk_id,commentNo);
        	result.put("status", "unliked");
        } 
        else { //싫어요 추가
        	commentService.insertReplyDislike(fk_id,commentNo);
        	result.put("status", "disliked");
        }
        
        // 현재 게시글의 좋아요/싫어요 수
        int replyDislikeCount = commentService.getReplyDislikeCount(commentNo);
        int replyLikeCount = commentService.getReplyLikeCount(commentNo);
        
        boolean newStatus = commentService.isreplyDisliked(fk_id, commentNo); // 최신 상태 재조회

        result.put("success", true);
        result.put("status", isreplyDisliked ? "unliked" : "disliked");
        result.put("replyLikeCount", replyLikeCount);
        result.put("replyDislikeCount", replyDislikeCount);
        return result;
        
    }
    
    
}
   
	
	

