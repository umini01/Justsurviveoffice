<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% 
  String ctxPath = request.getContextPath(); 
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>

<!-- Required meta tags -->
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
 
<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" > 

<!-- Font Awesome 6 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script> 

<%-- jQueryUI CSS 및 JS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

<script src="https://cdn.tailwindcss.com"></script>

<style type="text/css">
	
	body {
    background-color: #9da6ae;
    background-image: url("<%= ctxPath%>/images/background.png");
    background-size: cover;
    background-position: center;
    background-attachment: fixed;
    background-blend-mode: overlay;
    background-repeat:no-repeat;
}


</style>

<script type="text/javascript">

	$(function(){
		
		const method = "${requestScope.method}";
		
		if(method != "POST") {
			$('div#div_findResult').prop('hidden', true);
		} 
		else {
			$('div#div_findResult').prop('hidden', false);
			$('input:text[name="id"]').val("${requestScope.id}");
			$('input:text[name="email"]').val("${requestScope.email}");
			<%-- idfind class파일에서 setAttribute에서 name과 email을 넘겨줘서 여기서 쓸 수 있었다.--%>
		} 
	   	$('button.btn-success').click(function(){
	      	goFind();
	   	});
   		$('input:text[name="email"]').bind('keyup',function(e){
      		if(e.keyCode == 13){
         		goFind();
      		}
   		});
	}); 
	
	
 	function goFind() {
 		
   		const name = $('input:text[name="name"]').val().trim();
   		if (name == ""){
      		alert('성명을 입력하십시오.');
      		return; 
   		}
   
   		const email = $('input:text[name="email"]').val();
   
   		const regExp_email = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
   
   		if ( !regExp_email.test(email) ){
      		// 이메일이 정규표현식에 위배된 경우
      		alert('이메일을 올바르게 입력하십시오.');
      		return; // goFind() 함수종료
   		}
   
   		// 다 올바른 경우
   		const frm = document.idFindFrm;
   		frm.action = "<%= ctxPath%>/users/idFind";
   		frm.method = "POST";
   		frm.submit();
	}

 	function form_reset_empty(){
       	document.querySelector('form[name="idFindFrm"]').reset();
       	$('div#div_findResult').empty(); 
       	<%-- 해당 태그내에 값들을 싹 비우는것.--%>
	}

</script>
</head>

<body class="min-h-screen flex items-center justify-center p-4">
	
	<div class="form-container w-full max-w-3xl bg-white rounded-xl shadow-xl overflow-hidden backdrop-blur">
        <!-- 상단 헤더 -->
        <div class="bg-indigo-600 py-4 px-6 relative">
            <!-- 뒤로가기 아이콘 -->
            <p style="background-image:url('<%= ctxPath%>/images/backIco.png');
                     position:absolute;top:24px;left:10px;width:30px;height:30px;
                     background-size:cover;cursor:pointer;"
               onclick="location.href='javascript:history.back()'"></p>

            <h1 class="text-2xl font-bold text-white text-center">아이디 찾기</h1>
        </div>
        
        <!-- 입력 폼 -->
        <form id="idFindFrm" name="idFindFrm" class="p-6 md:p-8">
        	<table class="w-full">
        		 <!-- 성명 -->
        		 <tr class="mb-4 flex flex-col md:flex-row">
        		 	<td class="w-full md:w-1/4 font-medium text-gray-700 mb-1 md:mb-0 md:pr-4">
        		 		<label for="name">성명</label>
        		 	</td>
        		 	<td class="w-full md:w-3/4">
                        <input type="text" id="name" name="name"
                               class="w-full px-4 py-2 border rounded-lg focus:border-indigo-500 transition-all"
                               placeholder="이름을 입력하세요">
                    </td>
        		 </tr>
        		 
        		 <!-- 이메일 -->
        		 <tr class="mb-4 flex flex-col md:flex-row">
        		 	<td class="w-full md:w-1/4 font-medium text-gray-700 mb-1 md:mb-0 md:pr-4">
        		 		<label for="email">이메일</label>
        		 	</td>
        		 	<td class="w-full md:w-3/4">
                        <input type="text" id="email" name="email"
                               class="w-full px-4 py-2 border rounded-lg focus:border-indigo-500 transition-all"
                               placeholder="이메일을 입력하세요">
                    </td>
        		 </tr>
        	</table>
        	
        	<!-- 버튼 -->
        	<div class="submitBtn mt-8 flex justify-center gap-4">
                <button type="button" onclick="goFind()"
                        class="bg-indigo-600 text-white px-8 py-3 rounded-lg font-bold hover:shadow-lg">
                    찾기
                </button>
            </div>
            
			<!-- 결과 -->
			<div id="div_findResult" class="text-center mt-4">
				<c:if test="${not empty requestScope.usersDTO}">
					<p class="text-lg">아이디는
						<strong class="text-black text-xl">${requestScope.usersDTO}</strong> 입니다.
					</p>
				</c:if>
				<c:if test="${empty requestScope.usersDTO}">
					<p class="text-gray-600">입력하신 정보와 일치하는 아이디가 없습니다.</p>
				</c:if>
			</div>
	   </form>
	</div>
</body>

<%-- <jsp:include page="../footer.jsp" /> --%>





