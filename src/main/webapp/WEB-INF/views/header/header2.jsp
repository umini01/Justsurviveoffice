<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<%
    String ctxPath = request.getContextPath();
    //     /myspring
%>    
    
<!DOCTYPE html>
<html>
<head>
	<%-- Required meta tags --%>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>대사살 (대충사무실에서살아남기)</title>

    <%-- Bootstrap CSS --%>
    <link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">

    <%-- Font Awesome 6 Icons --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  
    <%-- 직접 만든 CSS 1 --%>
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/style1.css" />
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/common.css" />
    
    <%-- Optional JavaScript --%>
    <script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

	<%-- 스피너 및 datepicker 를 사용하기 위해 jQueryUI CSS 및 JS --%>
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
    <script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>
	
	<style>
		body{overflow-x:hidden;}
		.col-md-2 ul {height:100%;background-color:green;display:flex;}
		.admTab {width:calc(100% / 7);background-color:white; display:block;color:#000;border-bottom:1px solid #D19EFF;padding:1.5% 0; text-align:center;}
		.admTab:hover {background-color:#fff;}
		#clock {font-size:0.8rem;}
		.pc-menu {border-right:1px solid #000;display:flex;flex-wrap:wrap;justify-content:space-between;}
		.mobileTab{position:fixed;display:none;background-color:#fff;width:100%;padding:25px 0;z-index:10;border-bottom:1px solid #ddd;}
		.hamburger {font-size: 2rem;background: none;border: none;position: fixed;top: 11px;right: 20px;z-index: 2001;cursor: pointer;display: none; color:#000 !important;}
		#adminMenu {position: fixed;top: 35px; left: 10px;width: 100%; height: 100%;background: #fff;flex-direction: column;justify-content: center;align-items: center;z-index: 2000;display: none; margin: 0;padding: 0;}
		#adminMenu.show { display: flex; }
		#adminMenu li {list-style: none;margin: 15px 0;font-size: 1.3rem;}
		#adminMenu a, #adminMenu li {color: #000;text-decoration: none;}
		.mobileTab.is-open { display: block !important; }
		.hamburger.is-open { display: block !important; }

		/* 모바일에서만 햄버거 보이고, 기존 가로 메뉴 숨김 */
		@media screen and (max-width:1300px){
		  .pc-menu { display: none; }    /* 모바일에서 PC 메뉴 숨김 */
		  .hamburger, .mobileTab { display: block !important; }
		}
	</style>
</head>
<script type="text/javascript">
$(function(){
	 updateClock();
	  setInterval(updateClock, 1000);

	  $('#menuToggle').on('click', function(){
	    const opened = $('#adminMenu').toggleClass('show').hasClass('show');

	    // 아이콘 전환
	    $(this).toggleClass('is-open', opened)
	           .html(opened ? '&times;' : '&#9776;');

	    // 데스크톱 폭에서도 닫기버튼 보이도록 부모도 강제 노출
	    $('.mobileTab').toggleClass('is-open', opened);
	  });

	  $(window).on('resize', function(){
	    if($(window).width() > 1000){
	      $('#adminMenu').removeClass('show');
	      $('#menuToggle').removeClass('is-open').html('&#9776;');
	      $('.mobileTab').removeClass('is-open');   // 부모도 원복
	    }
	  });
	  
	}); // end of function(){}
	
	function admOut(){
	   if(confirm('로그아웃 하시겠어요?')) {
	     location.href = '<%= ctxPath %>/users/logout';
	   }
	 }
	 
	 function updateClock() {
	   const now = new Date();
	   const daysOfWeek = ["일","월","화","수","목","금","토"];
	   const dayOfWeek = daysOfWeek[now.getDay()];
	   const year = now.getFullYear();
	   const month = String(now.getMonth() + 1).padStart(2, '0');
	   const day = String(now.getDate()).padStart(2, '0');
	   const minutes = String(now.getMinutes()).padStart(2, '0');
	   const seconds = String(now.getSeconds()).padStart(2, '0');

	   const hours24 = now.getHours();
	   const ampm = hours24 >= 12 ? 'PM' : 'AM';
	   const displayHours = (hours24 % 12) || 12;

	   var timeString =
	       year + '-' + month + '-' + day +
	       ' (' + dayOfWeek + ') ' +
	       displayHours + ':' + minutes + ':' + seconds + ' ' + ampm;

	   var el = document.getElementById('clock');
	   if (el) el.textContent = timeString;
	 }
</script>
			<div class="col-md-12 p-0">
			
				<ul id="pcMenu" class="pc-menu">
				  <li class="admTab" style="background-image: url(/justsurviveoffice/images/logo2.png);display: block;background-size: contain;background-repeat: no-repeat;background-position: center;" onclick="location.href='<%= ctxPath%>/'"></li>
				  <%-- <li class="admTab">${sessionScope.loginUser.name}</li> --%>
				  <li class="admTab"><i class="fa-solid fa-chart-simple"></i>&nbsp;<a href="chart">회원 통계보기</a></li>
				  <li class="admTab"><i class="fa-solid fa-user"></i>&nbsp;<a href="usersList">사용자 관리</a></li>
				  <li class="admTab"><i class="fa-solid fa-user"></i>&nbsp;<a href="userExcelList">회원목록 엑셀</a></li>
				  <li class="admTab"><i class="fa-solid fa-rotate-left"></i><a href="javascript:history.back();">&nbsp;뒤로가기</a></li>
				  <li class="admTab admOut" onclick="admOut()"><i class="fa-solid fa-house">&nbsp;</i><a href="#">로그아웃</a></li>
				  <li class="admTab"><div id="clock"></div></li>
				</ul>			
				
				<div class="mobileTab">
					<button id="menuToggle" class="hamburger d-md-none">&#9776;</button>
				</div>
				
				<ul id="adminMenu">
				  <li><a href="chart">회원 통계보기</a></li>
				  <li><a href="usersList">사용자 관리</a></li>
				  <li><a href="userExcelList">회원목록 엑셀</a></li>
				  <li onclick="admOut()">로그아웃</li>
				  <li><div id="clock"></div></li>
				</ul>
			</div>

	<body>
		<div id="mycontainer" style="padding:0;">
			<div class="row justify-content-center">