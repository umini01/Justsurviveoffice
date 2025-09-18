<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%
	String ctxPath = request.getContextPath();
%>

 <script src="https://cdn.tailwindcss.com"></script>
 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
 <style>
 body {
 	background-color: #9da6ae;
 	background-image: url("<%= ctxPath%>/images/background.png");
 }
 .kakao-bg {
     background-color: #FEE500;
 }
 .kakao-text {
     color: #3A1D1D;
 }
 .naver-bg {
     background-color: #03C75A;
 }
 .naver-text {
     color: white;
 }
 .divider {
     display: flex;
     align-items: center;
     text-align: center;
     color: #9CA3AF;
 }
 .divider::before,
 .divider::after {
     content: "";
     flex: 1;
     border-bottom: 1px solid #E5E7EB;
 }
 .divider:not(:empty)::before {
     margin-right: 1em;
 }
 .divider:not(:empty)::after {
     margin-left: 1em;
 }
 .input-focus:focus {
     border-color: #6366F1;
     box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
 }
    </style>
</head>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>

	$(function(){
		
		// 로그인 저장 아이디 복원
	    const loginid = localStorage.getItem('saveid');
	    if (loginid != null) {
	        $('input#id').val(loginid);
	        $('#saveid').prop("checked", true);
	    }
	    
	    
		$(document).on("click", "button[name='loginSubmit']", function (){
			func_Login();
		 });
		
		// 카카오 로그인 버튼 클릭시
		document.querySelector('.kakao-bg').addEventListener('click', function(e) {
		    e.preventDefault();

		    const width = 500;
		    const height = 600;
		    const left = (window.screen.width / 2) - (width / 2);
		    const top = (window.screen.height / 2) - (height / 2);

		    window.open(
		        "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=ea6395f090f8882e15d65f5eb26cce78&redirect_uri=http://localhost:9089/auth/users/kakao",
		        "kakaoLoginPopup",
		        `width=${width},height=${height},top=${top},left=${left},resizable=yes,scrollbars=yes,status=yes`
		    );
		});

        // 네이버 로그인 버튼 클릭 시
		document.querySelector('.naver-bg').addEventListener('click', function() {
		    
		    const width = 500;
		    const height = 600;
		    const left = (window.screen.width / 2) - (width / 2);
		    const top = (window.screen.height / 2) - (height / 2);

			
		    window.open(
			    "https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=9F1h5_QLLo9PHMh8EJyP&state=STATE_STRING&redirect_uri=http://localhost:8080/user/users/naver",
			    "NaverLoginPopup",
			    `width=${width},height=${height},top=${top},left=${left},resizable=yes,scrollbars=yes,status=yes`
			);
		});
        
        //휴면 
	});

	 function func_Login() {
		  
		  const Id = $("input#id").val(); 
		  const Pwd = $("input#password").val(); 
		
		  if(Id.trim()=="") {
		 	 alert("아이디를 입력하세요!!");
			 $("input#id").val(""); 
			 $("input#id").focus();
			 return; // 종료 
		  }
		
		  if(Pwd.trim()=="") {
			 alert("비밀번호를 입력하세요!!");
			 $("input#password").val(""); 
			 $("input#password").focus();
			 return; // 종료 
		  }
		  
	   	  if($('input#saveid').prop('checked')) {
			 // 아이디 저장을 체크했다면,
			 localStorage.setItem('saveid', $("input#id").val());
	  	  } 	// 로컬스토리지에 해당 값을 남기겠다는 것.
		  else localStorage.removeItem('saveid'); // 해제 시 삭제.
	  
		  const frm = document.loginFrm;
		  
		  frm.action = "<%= ctxPath%>/users/login";
		  frm.method = "POST";
		  frm.submit();
		  
	  }// end of function func_Login()------------------------
</script>

<body class="bg-gray-50 min-h-screen flex items-center justify-center p-4">
    <div class="bg-white rounded-xl shadow-lg overflow-hidden w-full max-w-md">
        <!--  헤더 섹션 -->
		<div class="bg-indigo-600 py-6 px-8 flex items-center justify-center relative">
		  <!-- 뒤로가기 아이콘 -->
		  <p 
		    style="background-image:url('<%= ctxPath%>/images/backIco.png');"
		    class="absolute left-4 top-1/2 transform -translate-y-1/2 w-8 h-8 bg-cover cursor-pointer"
		    onclick="history.back()"
		  ></p>
		
		  <!-- 로그인 텍스트 그룹 -->
		  <div class="text-center">
		    <h1 class="text-2xl font-bold text-white">로그인</h1>
		    <p class="text-indigo-100 mt-1">계정에 로그인하세요</p>
		  </div>
		</div>
        <!-- 로그인 폼 -->
        <div class="p-8">
            <form class="space-y-6 loginFrm" id="loginFrm" name="loginFrm">
                <div>
                    <label for="id" class="block text-sm font-medium text-gray-700 mb-1">아이디</label>
                    <input type="id" name="id" id="id" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition input-focus" placeholder="example@example.com">
                </div>
                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700 mb-1">비밀번호</label>
                    <input type="password" name="password" id="password" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition input-focus" placeholder="••••••••">
                </div>
                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <input id="saveid" name="saveid" type="checkbox" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded">
                        <label for="saveid" class="ml-2 block text-sm text-gray-700">아이디 저장</label>
                    </div>
                    <div class="text-sm">
                    	<a href="<%=ctxPath %>/users/idFind" class="font-medium text-indigo-600 hover:text-indigo-500">아이디 찾기</a> / 
                        <a href="<%=ctxPath %>/users/pwdFindForm" class="font-medium text-indigo-600 hover:text-indigo-500">비밀번호 찾기</a>
                    </div>
                </div>
                <button type="submit" class="w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition loginSubmit" id="loginSubmit" name="loginSubmit" 
                onclick=""> 
                    로그인
                </button>
            </form>
            
			<!--  소셜 로그인 구분선
            <div class="mt-8">
                <div class="divider text-sm">소셜 계정으로 로그인</div>
            </div>
            
            소셜 로그인 버튼
            <div class="mt-6 grid grid-cols-2 gap-3">
                카카오 로그인 버튼
                <a href="#" class="w-full inline-flex justify-center py-3 px-4 rounded-md shadow-sm text-sm font-medium kakao-bg kakao-text hover:bg-yellow-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500 transition">
                    <i class="fas fa-comment mr-2 text-lg"></i>
                    카카오 로그인
                </a>
                
                네이버 로그인 버튼
                <a href="/oauth2/authorization/naver" class="w-full inline-flex justify-center py-3 px-4 rounded-md shadow-sm text-sm font-medium naver-bg naver-text hover:bg-green-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 transition" id="naver_id_login">
                    <i class="fas fa-n mr-2 text-lg"></i>
                    네이버 로그인
                </a>
            </div> -->

            <!-- 회원가입 링크 -->
            <div class="mt-6 text-center">
                <p class="text-sm text-gray-600">
                    아직 회원이 아니신가요?
                    <a href="<%=ctxPath %>/users/register" class="font-medium text-indigo-600 hover:text-indigo-500">
                    	회원가입</a>
                </p>
            </div>
        </div>
    </div>