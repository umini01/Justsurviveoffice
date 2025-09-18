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
<meta charset="utf-8">
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
	
    .backdrop-blur {
        backdrop-filter: blur(8px);
    } 
	
</style>


<script type="text/javascript">

	$(function(){
	
		$(function() {
			const loginid = localStorage.getItem('saveid');
			if (loginid != null && loginid !== "") {
				$('.loginBox input:text[name="id"]').val(loginid);
				$('input#saveid').prop("checked", true); 
			}
		});
		
		const method = "${requestScope.method}";
	
		if(method == "GET") {
			$('div#div_findResult').prop('hidden', true);
			
		} 
		else {
			$('div#div_findResult').prop('hidden', false);
			$('input:text[name="id"]').val("${requestScope.id}");
			$('input:text[name="email"]').val("${requestScope.email}");
			<%-- idfind class파일에서 setAttribute에서 name과 email을 넘겨줘서 여기서 쓸 수 있었다.--%>
		} 
	
		$('button.btn-success').click(function(){
			    pwFind();
		});
		
		$('input:text[name="email"]').bind('keyup',function(e){
			if(e.keyCode == 13){
				pwFind();
			}
		});
		
	}); 

 	function pwFind() {
	
	 	const id = $('form[name="pwFindFrm"] input[name="id"]').val().trim();
		console.log("아이디 값:", id); // 콘솔 디버깅
	
		if (id == ""){
			alert('아이디를 입력하십시오.');
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
		const frm = document.pwFindFrm;
		frm.action = "<%=ctxPath%>/users/passwordFind";
		frm.method = "POST";
		frm.submit();
	  }

		function form_reset_empty() {
			document.querySelector('form[name="pwFindFrm"]').reset();
			$('div#div_findResult').empty();
		<%-- 해당 태그내에 값들을 싹 비우는것.--%>
		}
	
		// === 인증하기 버튼 클릭 시 이벤트 첳리해주기 시작 == //
		$(document).on('click', 'button.finder', function() {
	    const input_confirmCode = $('input:text[name="input_confirmCode"]').val().trim();
	
	    if (input_confirmCode == "") {
	        alert("인증코드를 입력하세요");
	        return;
	    }

	    const frm = document.verifyCertificationFrm;
	    frm.userCertificationCode.value = input_confirmCode;
	    frm.id.value = $('form[name="pwFindFrm"] input[name="id"]').val();
	
	    frm.action = "<%= ctxPath%>/users/verifyCertification";
	    frm.method = "post";
	    frm.submit();
	});

</script>


</head>

<body class="min-h-screen flex items-center justify-center p-4">
	
	<div class="form-container w-full max-w-3xl bg-white rounded-xl shadow-xl overflow-hidden backdrop-blur">
        <div class="bg-indigo-600 py-4 px-6">
        	 <!-- 뒤로가기 아이콘 -->
            <p style="background-image:url('<%= ctxPath%>/images/backIco.png');
                     position:absolute;top:24px;left:10px;width:30px;height:30px;
                     background-size:cover;cursor:pointer;"
               onclick="location.href='javascript:history.back()'"></p>
            <h1 class="text-2xl font-bold text-white" style="text-align: center;font-family: italic">
            비밀번호 찾기</h1>
        </div>
        
        <form id="pwFindFrm" name="pwFindFrm" class="p-6 md:p-8">
        	<table name="pwFindTbl" class="w-full">
        		 
        		 <!-- 아이디 -->
        		 <tr class="mb-4 flex flex-col md:flex-row">
        		 	<td class="w-full md:w-1/4 font-medium text-gray-700 mb-1 md:mb-0 md:pr-4">
        		 		<label for="name">아이디</label>
        		 	</td>
        		 	<td class="w-full md:w-3/4">
                        <div class="pwBox">
                            <input type="text" id="id" name="id" class="requiredInfo w-full px-4 py-2 border rounded-lg focus:border-red-500 transition-all" placeholder="아이디를 입력하세요">
                        </div>
                    </td>
        		 </tr>
        		 <!-- 이메일 -->
        		 <tr class="mb-4 flex flex-col md:flex-row">
        		 	<td class="w-full md:w-1/4 font-medium text-gray-700 mb-1 md:mb-0 md:pr-4">
        		 		<label for="name">이메일</label>
        		 	</td>
        		 	<td class="w-full md:w-3/4">
                        <div class="pwBox">
                            <input type="text" id="email" name="email" class="requiredInfo w-full px-4 py-2 border rounded-lg focus:border-red-500 transition-all" placeholder="이메일을 입력하세요">
                        </div>
                    </td>
        		 </tr>
        	</table>
        	
        	<div class="submitBtn mt-8 flex justify-center gap-4">
                <button type="button" onclick="pwFind()" class="bg-indigo-600 text-white  px-8 py-3 rounded-lg font-bold hover:shadow-lg">찾기</button>
            </div>
            
			<%-- <div id="div_findResult">${requestScope.n}</div> --%>
			<c:if test="${requestScope.n == 1}">
				<div style="text-align:center;">
					<p style="text-align:center;line-height:22px;margin-top:15px;">인증코드가 ${requestScope.email} 로 발송되었습니다.<br> 인증코드를 입력해주세요</p>
					<input type="text" name="input_confirmCode" style="margin-top:15px;" class="border" />
					<br><br>
					<button type="button" class="finder bg-indigo-600 text-white  px-8 py-3 rounded-lg font-bold hover:shadow-lg">인증하기</button>
				</div>
			</c:if>
			<c:if test="${requestScope.n == 0}">
				<p style="text-align:center;line-height:22px;margin:10px 0 25px;font-size:16pt;">없습니다.</p>
			</c:if>
	   </form> 
	</div>

	<%-- 인증하기 form --%>
	<form name="verifyCertificationFrm">
		<input type="hidden" name ="userCertificationCode" />
		<input type="hidden" name ="id" />
	</form>
	

</div>
	
	
</body>
</html>