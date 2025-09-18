<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctxPath = request.getContextPath();
	// /justsurviveoffice
%>
  
 <!-- 사이드바 -->
        <div class="col-lg-3 mb-4">
            <div class="sidebar text-center" style="height:585px">
            	<c:if test="${sessionScope.loginUser.getCategory().getCategoryImagePath() ne null}">
                	<img src="${pageContext.request.contextPath}/images/${sessionScope.loginUser.category.categoryImagePath}" alt="프로필" class="mb-3">
                </c:if>
				<c:if test="${sessionScope.loginUser.getCategory().getCategoryImagePath() eq null}">
               		<img src="<%=ctxPath%>/images/unassigned.png" alt="프로필"  class="category-img mb-3">
               </c:if>
                <div class="text-muted small mb-3">${sessionScope.loginUser.email}</div>
                <div class="mb-3">
               		<span style="size:20pt; color:blue;">${sessionScope.loginUser.name} 님 </span>
                    포인트 : <b><fmt:formatNumber value="${sessionScope.loginUser.point}" pattern="#,###"/>p</b>
                </div>
                <hr>
                <div class="sidebar-menu text-left">
               	    <a href="<%=ctxPath%>/users/logout">로그아웃</a>
                    <a href="#" id="btnQuit">탈퇴하기</a>
                    <a href="javascript:history.back()">이전 페이지</a>
                    <a href="<%=ctxPath%>/">메인 페이지</a>
                </div>
                </div>
        </div> 