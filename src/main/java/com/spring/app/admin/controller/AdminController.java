package com.spring.app.admin.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

import org.json.simple.JSONObject;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.admin.domain.ReportDTO;
import com.spring.app.admin.service.AdminService;
import com.spring.app.common.MyUtil;
import com.spring.app.entity.Report;
import com.spring.app.users.domain.UsersDTO;
import com.spring.app.users.service.UsersService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor  // @RequiredArgsConstructor는 Lombok 라이브러리에서 제공하는 애너테이션으로, final 필드 또는 @NonNull이 붙은 필드에 대해 생성자를 자동으로 생성해준다.
@RequestMapping("admin/")
public class AdminController {
   
   // === 생성자 주입(Constructor Injection) === //
   private final AdminService adminService;
   private final UsersService usersService;

   @GetMapping("/adm")
   public String adminIndex() {
	   return "admin/adm";
   }
   
   // 회원목록 전체보기(페이징 처리)
   @GetMapping("usersList")
   public String userList(@RequestParam(name="searchType", defaultValue="")  String searchType,
                     @RequestParam(name="searchWord", defaultValue="")  String searchWord,
                     @RequestParam(value="pageno",    defaultValue="1") int currentShowPageNo   /* 현재 페이지번호 */,
                     @RequestParam(value = "sizePerPage", defaultValue = "5") int sizePerPage,   // 한 페이자당 보여질 행의 개수.
                     Model model,
                     HttpServletRequest request, HttpServletResponse response) {
      
      int totalPage = 0;        // 전체 페이지 개수
      long totalDataCount = 0;  // 전체 데이터의 개수
      String pageBar = "";      // 페이지바
      
      try {
         Page<UsersDTO> pageUsers = adminService.getPageUserList(searchType, searchWord, currentShowPageNo, sizePerPage);
         
         totalPage = pageUsers.getTotalPages();   // 전체 페이지수 개수
         
         if(currentShowPageNo > totalPage) {
            currentShowPageNo = totalPage;
            pageUsers = adminService.getPageUserList(searchType, searchWord, currentShowPageNo, sizePerPage);
         }
         
         totalDataCount = pageUsers.getTotalElements();   // 전체 데이터의 개수
         List<UsersDTO> UsersDtoList = pageUsers.getContent();   // 현재 페이지의 데이터 목록
      /*   
         // 현재 페이지의 데이터 목록인 List<Users> 를 List<UsersDTO> 로 변환한다.
         List<UsersDTO> UsersDtoList = usersList.stream()
                                    .map(Users::toDTO)
                                    .collect(Collectors.toList());
      */   
         model.addAttribute("UsersDtoList", UsersDtoList);
         
         if(!"".equals(searchType) && !"".equals(searchWord)) {
            model.addAttribute("searchType", searchType);   // view 단 페이지에서 검색타입 유지
            model.addAttribute("searchWord", searchWord);   // view 단 페이지에서 검색어 유지
         }
         // ================ 페이지바 만들기 시작 ================ //
         int blockSize = 10;
         // blockSize 는 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
         int loop = 1;
         /*
             loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.
         */
         int pageno = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
         // *** !! 공식이다. !! *** //
         String url = request.getContextPath() + "/admin/usersList";
         // === [맨처음][이전] 만들기 === //
         pageBar += "<li class='page-item'><a class='page-link' href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+ "&sizePerPage=" + sizePerPage + "&pageno=1'>⏪</a></li>";
         
         if(pageno != 1) {
            pageBar += "<li class='page-item'><a class='page-link' href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+ "&sizePerPage=" + sizePerPage + "&pageno="+(pageno-1)+"'>◀️</a></li>"; 
         }
         while( !(loop > blockSize || pageno > totalPage) ) {
            if(pageno == currentShowPageNo) {
               pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageno+"</a></li>";
            }
            else {
               pageBar += "<li class='page-item'><a class='page-link' href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+ "&sizePerPage=" + sizePerPage + "&pageno="+pageno+"'>"+pageno+"</a></li>"; 
            }
            loop++;
            pageno++;
         }// end of while------------------------
         
         // === [다음][마지막] 만들기 === //
         if(pageno <= totalPage) {
            pageBar += "<li class='page-item'><a class='page-link' href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+ "&sizePerPage=" + sizePerPage + "&pageno="+pageno+"'>▶️</a></li>";
         }
         pageBar += "<li class='page-item'><a class='page-link' href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+ "&sizePerPage=" + sizePerPage + "&pageno="+totalPage+"'>⏩</a></li>"; 
         
         model.addAttribute("pageBar", pageBar);
         // ================ 페이지바 만들기 끝 ================ //
         model.addAttribute("totalDataCount", totalDataCount); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임. 
         model.addAttribute("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
         model.addAttribute("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
         
         // 페이징 처리되어진 후 특정 글제목을 클릭하여 상세내용을 본 이후
         // 사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해 현재 페이지 URL 주소를 쿠키에 저장한다.
         String listURL = MyUtil.getCurrentURL(request);
         Cookie cookie = new Cookie("listURL", listURL); 
         // new Cookie(쿠키명, 쿠키값); 
         // Cookie 클래스 임포트시 jakarta.servlet.http.Cookie 임.
         cookie.setMaxAge(24*60*60); // 쿠키수명은 1일로 함
         cookie.setPath("/admin/");  // 쿠키가 브라우저에서 전송될 URL 경로 범위(Path)를 지정하는 설정임
         /*
            Path를 /board/ 로 설정하면:
            /board/view_2, /board/view 등 /board/ 로 시작하는 경로에서만 쿠키가 전송된다.
             * /, /index, /login 등의 다른 경로에서는 이 쿠키는 사용되지 않음.   
         */
         response.addCookie(cookie); // 쿠키에 저장. 접속한 클라이언트 PC로 쿠키를 보내줌
      } catch (Exception e) {
         e.printStackTrace();
      }
      return "admin/usersList";
   }
   
   // 특정 회원 1명 상세보기
   @GetMapping("usersDetail")
   public String userdetail(@RequestParam(name = "id") String id,
                      Model model) {
      
      UsersDTO usersDto = adminService.getUsers(id);
      model.addAttribute("usersDto", usersDto);
      
      return "admin/usersDetail";
   }
   
   @GetMapping("/chart")
   public String chart() {
       return "admin/chart";  
   }
   
   @GetMapping(value = "/chart/registerChart", produces = "application/json; charset=UTF-8")
   @ResponseBody
   public List<Map<String,String>> registerChart(
           @RequestParam(name = "year", required = false) Integer year) {
       	   return (year == null) ? usersService.registerChart()
       			   				 : usersService.registerChart(year);
   }

   
   @GetMapping(value = "/chart/registerChartday", produces = "application/json; charset=UTF-8")
   @ResponseBody
   public List<Map<String,String>> registerChartday(
           @RequestParam(name = "month", required = false) Integer month) {
       	   return (month == null) ? usersService.registerChartday()
       			   				  : usersService.registerChartday(month);
   }
   
   // <문자메시지 관련 순서3>
   // 관리자전용 회원에게 문자메시지 보내기
   @PostMapping("smsSend")
   @ResponseBody
   public Map<String, Object> smsSend(@RequestParam(name = "mobile") String mobile,
		   				 @RequestParam(name = "smsContent") String smsContent,
		   				 @RequestParam(name = "datetime", required = false) String datetime) {
	   
	   Map<String, Object> map = new HashMap<>();
	   JSONObject jsobj = null;
	   
	   // <문자메시지 관련 순서7>
	   try {
		   // 문자메시지 보내기 관련 코드 작성, import org.json.simple.JSONObject;
		   jsobj = adminService.smsSend(mobile, smsContent, datetime);

		   map.put("success_count", jsobj.get("success_count"));
		   map.put("error_count", jsobj.get("error_count"));
		   
	   } catch (Exception e) {
		   e.printStackTrace();
		   
		   map.put("success_count", 0);
		   map.put("error_count", 1);
		   map.put("message", "문자메시지 보내기 실패!!");
	   }
	   
	   return map;
   }
   

   /////////////////////////////////////////////////////////////////////////////////////////
	// 엑셀 저장과 테이블을 보여주기 위한 공통 메소드
   	private Map<String, Object> chartData(String chart, Integer month) {

   		List<Map<String, String>> list;

   	    if ("registerDay".equals(chart)) {
   	        list = (month == null) 
   	                ? usersService.registerChartday() 
   	                : usersService.registerChartday(month);
   	    } else {
   	        list = usersService.registerChart(); // 월별은 month 필요 없음
   	    }

   	    int total = list.stream()
   	                    .mapToInt(row -> Integer.parseInt(row.get("cnt")))
   	                    .sum();

   	    Map<String, Object> result = new HashMap<>();
   	    result.put("list", list);
   	    result.put("total", total);

   	    return result;
	}
	
	// 통계 테이블 페이지
	@GetMapping("userExcelList")
	public String userExcelList(@RequestParam(name="chart", defaultValue = "register") String chart,
	                            @RequestParam(name="month", required = false) Integer month,
	                            Model model) {
		
		if ("registerDay".equals(chart) && month == null) {
	        month = LocalDate.now().getMonthValue(); // 1~12
	    }
	
	    Map<String, Object> data = chartData(chart, month);
	
	    model.addAttribute("chart", chart);
	    model.addAttribute("month", month);
	    model.addAllAttributes(data);
	
	    return "admin/excelList";
	}
	
	// 엑셀 다운로드
	@PostMapping("downloadExcelFile")
	public String downloadExcelFile(@RequestParam(name="chart", defaultValue = "register") String chart,
	                                @RequestParam(name="month", required = false) Integer month,
	                                Model model, Locale locale) {
	
	    // 동일한 데이터 로직 사용
		Map<String, Object> data = chartData(chart, month);

	    model.addAttribute("chart", chart);
	    model.addAttribute("month", month);
	    model.addAllAttributes(data);

	    model.addAttribute("locale", locale);
	    
	    // ✅ 파일 이름 분기
	    String workbookName = "user_stat";
	    if ("registerDay".equals(chart)) {
	    	 workbookName = (month != null) ? "일자별 가입자 통계_" + month + "월" : "일자별 가입자 통계";
	    } else if ("register".equals(chart)) {
	        workbookName = "월별 가입자 통계"; 
	    }
	    
	    model.addAttribute("workbookName", workbookName); 

	    usersService.userExcelList_to_Excel(chart, month, model);

	    return "excelDownloadView"; // ViewConfig에 등록된 bean
	}


   @GetMapping("reportList")
   public String reportList(@RequestParam(value="pageno",    defaultValue="1") int currentShowPageNo,   /* 현재 페이지번호 */
						    Model model,
				            HttpServletRequest request, HttpServletResponse response) {
	   
	   int sizePerPage = 10;	// 한 페이자당 보여질 행의 개수.
	   
	   int totalPage = 0;        // 전체 페이지 개수
	   long totalDataCount = 0;  // 전체 데이터의 개수
	   String pageBar = "";      // 페이지바
	   
	   try {
		   Page<Report> pageReport = adminService.getPageReport(currentShowPageNo, sizePerPage);
		   
		   totalPage = pageReport.getTotalPages();	// 전체 페이지수 개수
		   
		   if(currentShowPageNo > totalPage) {
			   currentShowPageNo = totalPage;
			   pageReport = adminService.getPageReport(currentShowPageNo, sizePerPage);
		   }
		   
		   totalDataCount = pageReport.getTotalElements();	// 전체 데이터의 개수
		   
		   List<Report> reportList = pageReport.getContent();	// 현재 페이지의 데이터 목록
		   
		   // 현재 페이지의 데이터 목록인 List<Report> 를 List<ReportDTO> 로 변환한다.
		   List<ReportDTO> reportDtoList = reportList.stream()
				   								.map(Report::toDTO)
				   								.collect(Collectors.toList());
		   
		   model.addAttribute("reportDtoList", reportDtoList);
		   
		   int blockSize = 10;
		   int loop = 1;
		   int pageno = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		   
		   
		   String url = request.getContextPath() + "/admin/reportList";
		   String q = "&sizePerPage=" + sizePerPage; // 페이지 이동 시에도 유지
		   
		   // === [맨처음][이전] 만들기 === //
		   pageBar += "<li class='page-item'><a class='page-link' href='" + url + "?pageno=1" + q + "'>⏪</a></li>";
		   
		   if(pageno != 1) {
			  
			   pageBar += "<li class='page-item'><a class='page-link' href='" + url + "?pageno=" + (pageno - 1) + q + "'>[이전]</a></li>";
		   }
		   
		   while( !(loop > blockSize || pageno > totalPage) ) {
			   
			   if(pageno == currentShowPageNo) {
				   pageBar += "<li class='page-item active'><a class='page-link' href='#'>" + pageno + "</a></li>";
			   }
			   else {
				   pageBar += "<li class='page-item'><a class='page-link' href='" + url + "?pageno=" + pageno + q + "'>" + pageno + "</a></li>";
			   }
			   
			   loop++;
			   pageno++;
		   }// end of while----------------------------
		   
		   // === [다음][마지막] 만들기 === //
		   if(pageno <= totalPage) {
			   pageBar += "<li class='page-item'><a class='page-link' href='" + url + "?pageno=" + pageno + q + "'>[다음]</a></li>";
			   
		   }
		   pageBar += "<li class='page-item'><a class='page-link' href='" + url + "?pageno=" + totalPage + q + "'>⏩</a></li>";
		   
		   model.addAttribute("pageBar", pageBar);
		   
		   model.addAttribute("totalDataCount", totalDataCount); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임. 
		   model.addAttribute("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		   model.addAttribute("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		   
	   } catch (Exception e) {
		   e.printStackTrace();
	   }
	   
	   return "admin/reportList";
   }
   
   
   @GetMapping("reportComplete")
   @ResponseBody
   public int reportComplete(@RequestParam(name = "reportNo") Long reportNo) {
	   
	   int n = adminService.reportComplete(reportNo);	// 신고 처리 완료해주기
	   
	   return n;
   }
   
   
}
