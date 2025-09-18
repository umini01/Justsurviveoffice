<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 2차 비밀번호 인증</title>

<script type="text/javascript">
	
	$(function(){
		
		const pwd = $('input[name="code"]').val();
		
		$('button[name="btn_pwd"]').onclick(function(){
		//	alert(pwd);
		});
		
	});// end of $(function(){})---------------------
	
</script>

</head>
<body>
	
	<form name="aPwdform" method="post" action="<%= ctxPath%>/admin/filter/adminPwd" >
		<input type="text" name="code" />
		<button type="submit" name="btn_pwd" >확인</button>
	</form>
	<c:if test="${not empty error}">
		<div style="color:red">코드가 일치하지 않습니다.</div><!-- 추후에 수정할 때 스프링 시큐리티 관련 추가 -->
	</c:if>
</body>
</html>