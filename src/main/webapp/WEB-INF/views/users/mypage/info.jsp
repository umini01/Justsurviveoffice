<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String ctxPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지</title>

<link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<style>
   	body { background: #f7f7fb; font-family: 'Noto Sans KR', sans-serif; }

    .sidebar { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 8px 24px rgba(0,0,0,.06); }
	.sidebar img { max-width: 100%; border-radius: 10px; }
	.sidebar-menu a { display: block; padding: 8px 0; color: #333; text-decoration: none;font-weight:500;}
	.sidebar-menu a:hover { color: #6c63ff; } 
	.content { background: #fff; border-radius: 12px; padding: 24px; box-shadow: 0 8px 24px rgba(0,0,0,.06); }
   	
   	
</style>

<script>
$(function () {
	 let emailChecked = false;      //  중복확인을 눌렀는지 여부
    let emailDuplicated = false;   //  입력한 이메일이 중복인지 여부

    // 회원탈퇴
    $("#btnQuit").on("click", function(e) {
        e.preventDefault();
        if(confirm("정말로 탈퇴하시겠습니까?")) {
            $.ajax({
                url: "<%= ctxPath%>/mypage/quit",
                type: "post",
                data: { "id": "${sessionScope.loginUser.id}" },
                dataType: "json",
                success: function(json) {
                    if(json.success) {
                        alert("탈퇴되었습니다.");
                        location.href = "<%= ctxPath%>/index";
                    } else {
                        alert(json.message);
                    }
                },
                error: function(request, status, error) {
                    alert("code: "+request.status+"\nmessage: "+request.responseText+"\nerror: "+error);
                }
            });
        }
    });

    // 회원정보 수정
    $("#btnUpdate").on("click", function(e) {
        e.preventDefault();

        // 비밀번호 체크
        if($("#password").val() != $("#passwordCheck").val()) {
            alert("비밀번호가 일치하지 않습니다.");
            return;
        }
		if(emailChecked == false) {
			alert("이메일 중복체크는 필수입니다.");
			return;
		}
        
        if(confirm("회원정보를 수정하시겠습니까?")) {
            $("#editForm").submit();
        }
    });

    // 비밀번호 일치 여부 체크
    $("#password, #passwordCheck").on("keyup", function(){
        let pw = $("#password").val();
        let pwCheck = $("#passwordCheck").val();
        if(pw && pwCheck) {
            if(pw === pwCheck) {
                $("#pwMatchMsg").text("비밀번호가 일치합니다.").css("color", "green");
            } else {
                $("#pwMatchMsg").text("비밀번호가 일치하지 않습니다.").css("color", "red");
            }
        } else {
            $("#pwMatchMsg").text("");
        }
    });
    
    //이메일 입력값 변경시 다시 중복확인 필요
    $('input#email').on("change", function() {
    	emailChecked = false;
        emailDuplicated = false;
    });
    
    $("#btnEmailDup").on("click", function () {
    	  const email = $("#email").val().trim();
    	  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    	  
    	  if (!re.test(email)) {
    	    alert("올바른 이메일 형식이 아닙니다.");
    	    $("#email").focus();
    	    return;
    	  }

    	  $.get("<%=ctxPath%>/mypage/emailDuplicate", { email: email }, function (res) {
             emailChecked = true; //  중복확인을 눌렀으므로 true
             
    	    if (res.duplicated) {
   	    	  emailDuplicated = true;
    	      alert("이미 사용 중인 이메일입니다.");
    	    } else {
    	      emailDuplicated = false;
    	      alert("사용 가능한 이메일입니다.");
    	    }
    	  }).fail(function () {
    	    alert("중복확인 실패");
    	  });
    	});
    
});
</script>
</head>
<body>
<div class="container mt-4">
    <div class="row">

        <!-- 사이드바 -->

        <jsp:include page="../../menu/sidemenu.jsp"></jsp:include>

        <!-- 메인 내용 -->
        <div class="col-lg-9">
            <div class="content">

                <!-- 탭 메뉴 -->
                <ul class="nav nav-tabs mb-3">
                    <li class="nav-item">
                        <a class="nav-link active" href="<%= ctxPath%>/mypage/info">내 정보</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= ctxPath%>/mypage/forms">내가 쓴 글</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= ctxPath%>/mypage/bookmarks">내 북마크</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= ctxPath%>/mypage/chart">통계</a>
                    </li>
                </ul>

                <!-- 내정보 수정 폼 -->
                <form action="<%= ctxPath%>/mypage/update" method="post" id="editForm">
                    <input type="hidden" name="id" value="${sessionScope.loginUser.id}">

                    <div class="form-group">
                        <label>성명 <span class="text-danger">*</span></label>
                        <input type="text" name="name" class="form-control"
                               value="${sessionScope.loginUser.name}" required>
                    </div>

                    <div class="form-group">
                        <label>이메일 <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <input type="email" name="email" id="email" class="form-control"
                                   value="${sessionScope.loginUser.email}" required>
                            <div class="input-group-append">
                                <button class="btn btn-outline-primary" type="button" id="btnEmailDup">중복확인</button>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>연락처 <span class="text-danger">*</span></label>
                        <input type="text" name="mobile" class="form-control"
                               value="${sessionScope.loginUser.mobile}" placeholder="010-1234-5678" required>
                    </div>

                    <div class="form-group">
                        <label>비밀번호</label>
                        <input type="password" name="password" id="password" class="form-control"
                               minlength="8" maxlength="15">
                    </div>

                    <div class="form-group">
                        <label>비밀번호 확인</label>
                        <input type="password" id="passwordCheck" class="form-control"
                               minlength="8" maxlength="15">
                        <small id="pwMatchMsg" class="form-text"></small>
                    </div>

                    <div class="text-center mt-4">
                        <button type="submit" class="btn btn-primary px-4" id="btnUpdate">수정하기</button>
                    </div>
                </form>

                <!-- 숨은 폼: 로그아웃 & 탈퇴 POST 요청 -->
				<form id="logoutForm" action="<%=ctxPath%>/logout" method="post" style="display:none;"></form>
                <form id="quitForm"  onclick="goDelte()"  method="post" style="display:none;"></form>

            </div>
        </div>
    </div>
</div>
</body>
</html>
