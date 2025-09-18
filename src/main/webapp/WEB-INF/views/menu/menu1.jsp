<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- 250828 웹 채팅시 IP필요해서 java.net 가져옴!!!!!!!!!!!!  --%>
<%@ page import="java.net.InetAddress" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
	// /justsurviveoffice
%>

<% 
	// === (#웹채팅관련2) === //	
		
	// === 서버 IP 주소 알아오기(사용중인 IP주소가 유동IP 이라면 IP주소를 알아와야 한다.) === 
//    InetAddress inet = InetAddress.getLocalHost();
//    String serverIP = inet.getHostAddress();
    
 	// System.out.println("serverIP : " + serverIP);
    // serverIP : 192.168.0.219
    
    // String serverIP = "192.168.10.213";
 	String serverIP = "13.209.96.17"; 
    // 자신의 EC2 퍼블릭 IPv4 주소임. // 아마존(AWS)에 배포를 하기 위한 것임. 
    // 만약에 사용중인 IP주소가 고정IP 이라면 IP주소를 직접입력해주면 된다. 
    
    // === 서버 포트번호 알아오기 === //
    int portnumber = request.getServerPort();
 	System.out.println("portnumber : " + portnumber);
 	// portnumber : 9089
 	
 	String serverName = "http://"+serverIP+":"+portnumber;
 	System.out.println("serverName : " + serverName);
 	// serverName : http://192.168.10.213:9089
%>

<style>
 
.navBookmk {
    display: inline-block; /* 또는 block */
    width: 20px;  /* 이미지 크기에 맞게 조정 */
    height: 20px; /* 이미지 크기에 맞게 조정 */
    background-image: url("<%= ctxPath%>/images/bookmark.png");
    background-size: contain;
    background-repeat: no-repeat;
    background-position: center;
}
@media screen and (max-width:768px){
	.mainUl > li {width:100%;text-align:center;}
	.moHd {display:none;}
}
</style>

<script>  
	// 250331 김예준 햄버거메뉴(모바일) 시 토글누르면 메뉴보이도록 함>> 굿!!
	$(function () {
	  $("button#menuToggle").on("click", function () {
	    let $nav = $("#mainNav");
	    let isExpanded = $(this).attr("aria-expanded") === "true";

	    $(this).attr("aria-expanded", !isExpanded);

	    $nav.toggleClass("show");
	  });
	});
	
  // === 전체 글목록 검색하기 요청 === //
  function searchBoardAll() {
	   const form = document.searchAllForm;
	   alert(form.action)
	   <%-- 
	   form.method = "get";
	   form.action = "<%=originPath%>/board/list?searchType=boardName_boardContent&searchWord="
			   		 + $('#searchWord').val; --%>
	   form.submit();
  }
  
</script>

<header style="opacity: 0.8; background-color:#A4B1DE; display: flex;">
  <h1><a href="<%=ctxPath%>/index" style="color: white;text-decoration: none;background-image: url(/justsurviveoffice/images/logo2.png);width: 173px;height: 50px;display: block;background-size: cover;background-repeat: no-repeat;background-position: center;"></a></h1>

  <button id="menuToggle" aria-label="메뉴 토글" aria-expanded="false">&#9776;</button>

  <nav id="mainNav" class="hidden">
    <ul class="mainUl">
      <li><a href="<%=ctxPath%>/board/listAll">전체게시판</a></li>
      <c:if test="${not empty sessionScope.loginUser}">
      	<li><a href="<%=ctxPath%>/chatting/multichat">랜덤톡방</a></li>
      </c:if>
      <c:if test="${empty sessionScope.loginUser}">
        <li><a href="<%=ctxPath%>/users/loginForm">로그인</a></li>
      </c:if>
      <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.id == 'admin'}">
        <p style="background: #fff;padding: 4px 13px;border-radius: 13px;">${sessionScope.loginUser.name} 님</p>
        <li><a href="<%=ctxPath%>/admin/usersList">관리자 페이지</a></li>
        <li><a href="<%=ctxPath%>/users/logout">로그아웃</a></li>
      </c:if>
      <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.id != 'admin'}">
        <li><a href="<%=ctxPath%>/mypage/info">내정보보기</a></li>
        <li class="moHd"><p style="background: #fff;padding: 4px 13px;border-radius: 13px;">${sessionScope.loginUser.id}</p></li>
		<li class="moHd"><a class="navBookmk" href="<%=ctxPath%>/mypage/bookmarks"" id="bookmarks"></a></li>
		<li><a href="<%=ctxPath%>/users/logout">로그아웃</a></li>     
      </c:if>
      
    </ul>
  </nav>
</header>