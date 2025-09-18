<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	String ctxPath = request.getContextPath();
%>       
    
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

<script> var ctxPath = '<%= request.getContextPath() %>'; </script>

<script type="text/javascript" src="<%= ctxPath%>/js/user/register.js"></script>

<style type="text/css">

	@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap');
    body {
 		background-color: #9da6ae;
 		background-image: url("<%= ctxPath%>/images/background.png");
  		font-family: 'Noto Sans KR', sans-serif;
    	background-size: cover;
    	background-position: center;
    	background-attachment: fixed;
    	background-blend-mode: overlay;
	}
 
    .error {
   		color: #ef4444;
        font-size: 0.875rem;
        margin-top: 0.25rem;
   	}
        
    .backdrop-blur {
        backdrop-filter: blur(8px);
    }
        
    .btn-red {
    	background-color: #7e22ce;
    	transition: all 0.3s;
	}
		
	.btn-red:hover {
    	background-color: #6b21a8;
	    transform: translateY(-2px);
	}
		
	.btn-check {
    	background-color: #4f46e5;  /* indigo-600 */
	    transition: all 0.3s;
	}
		
	.btn-check:hover {
    	background-color: #4f46e5;  /* indigo-600 */
	}
		
	input:focus {
    	outline: none;
    	border-color: #3730A3; /* indigo-800 */
    	box-shadow: 0 0 0 2px rgba(55, 48, 163, 0.2);
	}

    .form-container {
        animation: fadeIn 0.5s ease-out;
    }
        
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }
        
    @media (max-width: 768px) {
        .form-container {
            width: 90% !important;
        }
	}
	
</style>

</head>

<body class="min-h-screen flex items-center justify-center p-4">
	
	<div class="form-container w-full max-w-3xl bg-white rounded-xl shadow-xl overflow-hidden backdrop-blur">
        <div class="bg-indigo-600 py-4 px-6">
            <h1 class="text-2xl font-bold text-white" style="text-align: center;font-family: italic">
            Justsurvieoffice 에 오신 걸 환영합니다 </h1>
        </div>
        
        <form name="registerForm" class="p-6 md:p-8">
            <table id="tblUserRegister" class="w-full">
                <!-- 이름 -->
                <tr class="mb-4 flex flex-col md:flex-row">
                    <td class="w-full md:w-1/4 font-medium text-gray-700 mb-1 md:mb-0 md:pr-4">
                        <label for="name">이름<span class="text-red-600">*</span></label>
                    </td>
                    <td class="w-full md:w-3/4">
                        <div class="relative">
                            <input type="text" id="name" name="name" class="requiredInfo w-full px-4 py-2 border rounded-lg focus:border-red-500 transition-all" placeholder="이름을 입력하세요">
                            <span class="error">이름을 입력해주세요</span>
                        </div>
                    </td>
                </tr>

                <!-- 아이디 -->
                <tr class="mb-4 flex flex-col md:flex-row">
                    <td class="w-full md:w-1/4 font-medium text-gray-700 mb-1 md:mb-0 md:pr-4">
                        <label for="id">아이디<span class="text-red-600">*</span></label>
                    </td>
                    <td class="w-full md:w-3/4">
                        <div class="flex gap-2 mb-2">
                            <input type="text" id="id" name="id" class="requiredInfo flex-grow px-4 py-2 border rounded-lg focus:border-red-500 transition-all" placeholder="아이디를 입력하세요">
                            <span id="idCheck" class="btn-check cursor-pointer text-white px-4 py-2 rounded-lg text-center whitespace-nowrap">아이디 중복확인</span>
                        </div>
                        <span class="error">아이디를 입력해주세요</span>
                        <span id="idCheckResult" class="block mt-1 text-sm"></span>
                    </td>
                </tr>

                <!-- 비밀번호 -->
                <tr class="mb-4 flex flex-col md:flex-row">
                    <td class="w-full md:w-1/4 font-medium text-gray-700 mb-1 md:mb-0 md:pr-4">
                        <label for="password">비밀번호<span class="text-red-600">*</span></label>
                    </td>
                    <td class="w-full md:w-3/4">
                        <div class="mb-2">
                            <input type="password" id="password" name="password" class="requiredInfo w-full px-4 py-2 border rounded-lg focus:border-red-500 transition-all" placeholder="영문, 숫자, 특수문자 조합 8~15자">
                            <span class="error">영문, 숫자, 특수문자 조합 8~15자를 입력해주세요</span>
                        </div>
                    </td>
                </tr>

                <!-- 비밀번호 확인 -->
                <tr class="mb-4 flex flex-col md:flex-row">
                    <td class="w-full md:w-1/4 font-medium text-gray-700 mb-1 md:mb-0 md:pr-4">
                        <label for="passwordCheck">비밀번호 확인<span class="text-red-600">*</span></label>
                    </td>
                    <td class="w-full md:w-3/4">
                        <div class="mb-2">
                            <input type="password" id="passwordCheck" class="requiredInfo w-full px-4 py-2 border rounded-lg focus:border-red-500 transition-all" placeholder="비밀번호를 다시 입력하세요">
                            <span class="error">비밀번호가 일치하지 않습니다</span>
                        </div>
                    </td>
                </tr>

                <!-- 이메일 -->
                <tr class="mb-4 flex flex-col md:flex-row">
                    <td class="w-full md:w-1/4 font-medium text-gray-700 mb-1 md:mb-0 md:pr-4">
                        <label for="email">이메일<span class="text-red-600">*</span></label>
                    </td>
                    <td class="w-full md:w-3/4">
                        <div class="flex gap-2 mb-2">
                            <input type="text" id="email" name="email" class="requiredInfo flex-grow px-4 py-2 border rounded-lg focus:border-red-500 transition-all" placeholder="예: example@example.com">
                            <span id="emailCheck" class="btn-check cursor-pointer text-white px-4 py-2 rounded-lg text-center whitespace-nowrap">이메일 중복확인</span>
                        </div>
                        <span class="error">올바른 이메일 형식이 아닙니다</span>
                        <span id="emailCheckResult" class="emailCheckResult block mt-1 text-sm"></span>
                    </td>
                </tr>

                <!-- 연락처 -->
                <tr class="mb-4 flex flex-col md:flex-row">
                    <td class="w-full md:w-1/4 font-medium text-gray-700 mb-1 md:mb-0 md:pr-4">
                        <label for="hp1">연락처<span class="text-red-600">*</span></label>
                    </td>
                    <td class="w-full md:w-3/4">
                        <div class="flex items-center gap-2 mb-2">
                            <select id="hp1" name="hp1" class="px-4 py-2 border rounded-lg focus:border-red-500 transition-all flex-shrink-0">
                                <option value="010">010</option>
                                <option value="011">011</option>
                                <option value="016">016</option>
                            </select>
                            <span class="text-gray-400">-</span>
                            <input type="text" id="hp2" name="hp2" class="requiredInfo w-24 px-4 py-2 border rounded-lg focus:border-red-500 transition-all text-center" maxlength="4">
                            <span class="text-gray-400">-</span>
                            <input type="text" id="hp3" name="hp3" class="requiredInfo w-24 px-4 py-2 border rounded-lg focus:border-red-500 transition-all text-center" maxlength="4">
                            <span class="error ml-2">- 제외하고 숫자만 입력해주세요</span>
                        </div> 
                    </td>
                </tr>
                
                <tr>
                    <td colspan="2">
                       <label for="agree">이용약관에 동의합니다</label>&nbsp;&nbsp;<input type="checkbox" id="agree" />
                    </td>
                </tr>
                
                <tr>
                    <td colspan="2">
                       <iframe src="<%= ctxPath%>/users/agree" width="100%" height="150px" style="border: solid 1px navy;"></iframe>
                    </td>
                </tr>
			
            </table>

            <div class="mt-8 flex justify-center gap-4">
                <button type="button" onclick="register()" class="bg-indigo-600 text-white px-8 py-3 rounded-lg font-bold hover:shadow-lg">가입하기</button>
                <!-- <button type="reset" class="bg-gray-300 text-gray-700 px-8 py-3 rounded-lg font-bold hover:bg-gray-400">취소</button> -->
				<button type="button" id="btnCancel" class="bg-gray-300 text-gray-700 px-8 py-3 rounded-lg font-bold hover:bg-gray-400">
				    뒤로가기
				</button>
            </div>
        </form>
    </div>
	
</body>
</html>

