package com.spring.app.mail.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.app.common.FileManager;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;


// ==== 다중 파일첨부가 있는 복수 사용자에게 이메일 보내기 ==== //
@Controller
@RequiredArgsConstructor
@RequestMapping("/email/")
public class EmailController {
	
	private final GoogleMail mail;
	private final FileManager fileManager;
	
	@GetMapping("emailWrite")
	public String emailWrite() {
				
		return "mycontent1/email/emailWrite";
	}
	
		
	@PostMapping("emailWrite")
	@ResponseBody
	public Map<String, Integer> emailWrite(MultipartHttpServletRequest mtp_request) {
		
		Map<String, Integer> map = new HashMap<>();
		
		String recipient = mtp_request.getParameter("recipient");
		String subject = mtp_request.getParameter("subject");
		String content = mtp_request.getParameter("content");
		
		List<MultipartFile> fileList = mtp_request.getFiles("file_arr"); // "file_arr" 은 /myspring/src/main/webapp/WEB-INF/views/mycontent1/email/emailWrite.jsp 페이지의 317 라인에 보여지는 formData.append("file_arr", item); 의 값이다.           
	    // !! 주의 !! 복수개의 파일은 mtp_request.getFile 이 아니라 mtp_request.getFiles 이다.!!
	    // MultipartFile interface는 Spring에서 업로드된 파일을 다룰 때 사용되는 인터페이스로 파일의 이름과 실제 데이터, 파일 크기 등을 구할 수 있다.
		
		/*
        	>>>> 첨부파일이 업로드 되어질 특정 경로(폴더)지정해주기
            우리는 WAS 의 webapp/resources/email_attach_file 라는 폴더로 지정해준다.
		*/
		
		// WAS 의 webapp 의 절대경로를 알아와야 한다.
		HttpSession session = mtp_request.getSession();
		String root = session.getServletContext().getRealPath("/");
		String path = root + "resources"+File.separator+"email_attach_file";
		// path 가 첨부파일들을 저장할 WAS(톰캣)의 폴더가 된다.
     
   // 	System.out.println("~~~~ 확인용 path => " + path);
		// ~~~~ 확인용 path => C:\NCS\workspace_spring_boot_17\myspring\src\main\webapp\resources\email_attach_file
		
		File dir = new File(path);
		if(!dir.exists()) {
			dir.mkdirs();
		}
		
		// >>>> 첨부파일을 위의 path 경로에 올리기 <<<< //
	    String[] arr_attachFilename = null; // 첨부파일명들을 기록하기 위한 용도  
	    
	    if(fileList != null && fileList.size() > 0) {
	    	
	    	arr_attachFilename = new String[fileList.size()];
	    	
	    	for(int i=0; i<fileList.size(); i++) {
	    		MultipartFile mtfile = fileList.get(i);
	    	//	System.out.println("파일명 : " + mtfile.getOriginalFilename() + " / 파일크기 : " + mtfile.getSize());
	    		/*
	    			파일명 : berkelekle심플라운드01.jpg / 파일크기 : 71317
					파일명 : Electrolux냉장고_사용설명서.pdf / 파일크기 : 791567
					파일명 : 쉐보레전면.jpg / 파일크기 : 131110
	    		*/
	    		
	    		// === MultipartFile 을 File 로 변환하여 탐색기 저장폴더에 저장하기 시작 === //
	    		try {
	    			File attachFile = new File(path+File.separator+mtfile.getOriginalFilename());
	    			mtfile.transferTo(attachFile); // !!!! 이것이 파일을 업로드해주는 것이다. !!!!
	    			
	    			arr_attachFilename[i] = mtfile.getOriginalFilename(); // 첨부파일명들을 기록한다.
	    			
	    		} catch(Exception e) {
	    			e.printStackTrace();
	    		}   		
	    		// === MultipartFile 을 File 로 변환하여 탐색기 저장폴더에 저장하기 끝 === //
	    		
	    	} // end of for
	    	
	    } // end of if(fileList != null && fileList.size() > 0)
	    
	    
	//  System.out.println("recipient : " + recipient);
	    // recipient : dbals1986@naver.com;dbals010321@naver.com;
	    
	//  System.out.println("subject : " + subject);
	    // subject : 첨부파일이 있는 메일 보내기 염습
	    
	//  System.out.println("content : " + content);
	    // content : <p>첨부파일이 있는 메일 보내기 염습 입니다</p>
		
	    String[] arr_recipient = recipient.split("\\;");
	    
	    for(String recipient_email : arr_recipient) {
	    	
	    	Map<String, Object> paraMap = new HashMap<>();
	    	paraMap.put("recipient", recipient_email);
	    	paraMap.put("subject", subject);
	    	paraMap.put("content", content);
	    	
	    	if(fileList != null && fileList.size() > 0) {
	    		paraMap.put("path", path); // path 는 첨부파일들이 저장된 WAS(톰캣)의 폴더의 경로명이다. 
	    		paraMap.put("arr_attachFilename", arr_attachFilename); // arr_attachFilename 은 첨부파일명들이 저장된 배열이다.
	    	}
	    	
	    	try {
	    		mail.sendmail_withFile(paraMap);
	    		
	    		map.put("result", 1);
	    		
	    	} catch(Exception e) {
	    		e.printStackTrace();
	    		
	    		map.put("result", 0);
	    		break;
	    	}
	    		
	    } // end of for
	    
	    // 메일 전송 후 업로드한 첨부파일 지우기
	    if(arr_attachFilename != null) {
	    	for(String attachFilename : arr_attachFilename) {
	    		try {
	    			fileManager.doFileDelete(attachFilename, path);
	    		} catch(Exception e) {
	    			e.printStackTrace();
	    		}
	    	} // end of for
	    }
	    	    
		return map;
	}
	
	
	@GetMapping("emailWrite/done")
	public String emailWriteDone() {
		
		return "mycontent1/email/emailWriteDone";
	}
	
	

}
