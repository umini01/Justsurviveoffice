<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<!-- Font Awesome 6 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">

<!-- Optional JavaScript -->
<script src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<!-- Tailwind -->
<script src="https://cdn.tailwindcss.com"></script>

<style>
    body {
        background-color: #9da6ae;
        background-image: url("<%= ctxPath%>/images/background.png");
        background-size: cover;
        background-position: center;
        background-attachment: fixed;
        background-blend-mode: overlay;
        background-repeat: no-repeat;
    }

   .form-container {
    margin: 0 auto;
    max-width: 768px;
    width: 100%;
    background-color: #ffffff; /* ✅ 완전 흰색 */
    border-radius: 12px;
     box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1),
                0 10px 10px rgba(0, 0, 0, 0.04);
    backdrop-filter: blur(8px); 
    -webkit-backdrop-filter: blur(8px);
    overflow: hidden;
}

    .form-header {
        background: #4F46E5;
        padding: 24px;
        text-align: center;
        font-size: 24px;
        font-weight: bold;
        color: white;
        position: relative;
    }

    .back-icon {
        background-image: url('<%= ctxPath%>/images/backIco.png');
        position: absolute;
        top: 16px;
        left: 10px;
        width: 30px;
        height: 30px;
        background-size: cover;
        cursor: pointer;
    }

    .form-body {
        padding: 32px;
    }

    table {
        width: 100%;
    }

    table tr {
        display: flex;
        flex-direction: column;
        margin-bottom: 18px;
    }

    @media (min-width: 768px) {
        table tr {
            flex-direction: row;
            align-items: center;
        }
    }

    td:first-child {
        width: 100%;
        font-weight: 600;
        color: #333;
        margin-bottom: 8px;
    }

    @media (min-width: 768px) {
        td:first-child {
            width: 25%;
            padding-right: 16px;
            margin-bottom: 0;
            text-align: left;
        }
        td:last-child {
            width: 75%;
        }
    }
</style>

<script>
    $(function(){
        $(".submit-btn").on("click", function(){
            const frm = document.passwordUp;
            const pwd1 = $("#newPassword1").val();
            const pwd2 = $("#newPassword2").val();

            if (pwd1 !== pwd2) {
                alert("비밀번호가 일치하지 않습니다.");
                return;
            }

            $("<input>").attr({
                type: "hidden",
                name: "newPassword2",
                value: pwd2
            }).appendTo(frm);

            frm.action = "<%=ctxPath%>/users/pwdUpdate";
            frm.method = "POST";
            frm.submit();
        });
    });
</script>
</head>

<body class="min-h-screen flex items-center justify-center p-4">
<div class="form-container">
    <!-- 헤더 -->
    <div class="form-header">
        <p class="back-icon" onclick="location.href='http://localhost:9089/justsurviveoffice/'"></p>
        <h1 class="text-2xl font-bold text-white text-center">
            비밀번호 변경할 아이디: ${requestScope.id}
        </h1>
    </div>

    <!-- 입력 폼 -->
    <form name="passwordUp" class="form-body">
        <input type="hidden" name="id" value="${requestScope.id}" />

        <table>
            <!-- 비밀번호 -->
            <tr>
                <td><label for="newPassword1">비밀번호</label></td>
                <td>
                    <input type="password" id="newPassword1" name="newPassword1"
                           autocomplete="new-password"
                           class="w-full px-4 py-2 border rounded-lg focus:border-indigo-500 transition-all"
                           placeholder="새 비밀번호를 입력하세요" />
                </td>
            </tr>

            <!-- 비밀번호 재확인 -->
            <tr>
                <td><label for="newPassword2">비밀번호 재확인</label></td>
                <td>
                    <input type="password" id="newPassword2"
                           autocomplete="new-password"
                           class="w-full px-4 py-2 border rounded-lg focus:border-indigo-500 transition-all"
                           placeholder="비밀번호를 다시 입력하세요" />
                </td>
            </tr>
        </table>

        <!-- 버튼 -->
        <div class="submitBtn mt-8 flex justify-center gap-4">
            <button type="button"
                    class="bg-indigo-600 text-white px-8 py-3 rounded-lg font-bold hover:shadow-lg submit-btn">
                변경하기
            </button>
        </div>
    </form>
</div>
</body>
</html>