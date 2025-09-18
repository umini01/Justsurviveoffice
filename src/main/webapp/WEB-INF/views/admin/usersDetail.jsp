<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>유저리스트 임시 작업 페이지</title>

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">

<%-- Font Awesome 6 Icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>
<script type="text/javascript" src="<%=ctxPath%>/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<script src="https://cdn.tailwindcss.com"></script>


<style type="text/css">
	
	.gradient-bg {
		background: linear-gradient(135deg, #6b73ff 20%, #444eff 100%);        }
	.card-shadow {
		box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
	}
	.animate-pulse {
		animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
	}
	@keyframes pulse {
		0%, 100% {
			opacity: 1;
		}
		50% {
			opacity: 0.5;
		}
	}
	textarea {
		resize: none;
	}
	
</style>

<script type="text/javascript">
	
	$(function(){
		
		$("div#smsResult").hide(); 
		
		$('button#btnSend').click(()=>{
			let reservedate = $('input#reservedate').val();
			reservedate = reservedate.split("-").join("");
			
			let reservetime = $('input#reservetime').val();
			reservetime = reservetime.split(":").join("") + "00";
			
			const datetime = reservedate + reservetime;
			
			let dataObj;
			
			if( reservedate == "" || reservetime == "" ) {
			    dataObj = {"mobile":"${requestScope.usersDto.mobile}",
			               "smsContent":$('textarea#smsContent').val()};
			}
			else {
			    dataObj = {"mobile":"${requestScope.usersDto.mobile}",
			               "smsContent":$('textarea#smsContent').val(),
			               "datetime":datetime};
			}
			/* <문자메시지 관련 순서2> */
			$.ajax({
				url:"<%= ctxPath%>/admin/smsSend",
				type:"post",
				data:dataObj,
				dataType:"json",
				success:function(json){
					if(json.success_count == 1) {
						$("div#smsResult").html('<div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative" role="alert"><strong class="font-bold">Success!</strong><span class="block sm:inline"> SMS sent successfully!</span></div>');
					}
					else if(json.error_count != 0) {
						$("div#smsResult").html('<div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert"><strong class="font-bold">Error!</strong><span class="block sm:inline"> Failed to send SMS.</span></div>');
					}
					
					$("div#smsResult").show().delay(5000).fadeOut();
					$('textarea#smsContent').val("");
				},
				error: function(request, status, error){
					alert("code:" + request.status + "\nmessage:" + request.responseText);
				}
			});
		
		});
		
	});// end of $(function(){})-----------------------------
	
	
	// Function Declaration
	
	
</script>

</head>
<body class="bg-gray-100">
	
	<div class="min-h-screen flex flex-col">
        <!-- Header Placeholder -->
        <header class="gradient-bg text-white p-4">
            <div class="container mx-auto flex justify-between items-center">
                <h1 class="text-2xl font-bold">Admin Dashboard</h1>
            </div>
        </header>

        <main class="flex-grow container mx-auto px-4 py-8">
            <!-- User Details Section -->
            <div class="max-w-4xl mx-auto">
                <!-- Empty User Case -->
                <c:if test="${empty requestScope.usersDto}">
                    <div class="bg-white rounded-lg shadow-lg p-6 text-center">
                        <i class="fas fa-user-slash text-6xl text-gray-400 mb-4"></i>
                        <h2 class="text-2xl font-bold text-gray-700 mb-2">User Not Found</h2>
                        <p class="text-gray-600">The user you are looking for does not exist.</p>
                        <button onclick="javascript:location.href='<%= ctxPath%>/admin/usersList'" class="mt-4 bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition">
                            <i class="fas fa-arrow-left mr-2"></i> Back to User List
                        </button>
                    </div>
                </c:if>

                <!-- User Details -->
                <c:if test="${not empty requestScope.usersDto}">
                    <div class="bg-white rounded-xl card-shadow overflow-hidden mb-8">
                        <!-- User Header -->
                        <div class="gradient-bg text-white p-6">
                            <div class="flex items-center justify-between">
                                <div>
                                    <h1 class="text-2xl md:text-3xl font-bold">
                                        <i class="fas fa-user-circle mr-3"></i>${requestScope.usersDto.name}'s Profile
                                    </h1>
                                    <p class="text-blue-100 mt-1">User since ${fn:substring(requestScope.usersDto.registerday, 0, 10)}</p>
                                </div>
                                <div class="hidden md:block bg-white text-blue-600 px-4 py-2 rounded-full font-bold">
                                    ${requestScope.usersDto.category.categoryName}
                                </div>
                            </div>
                        </div>

                        <!-- User Details Table -->
                        <div class="p-6">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div class="space-y-4">
                                    <div class="flex items-start">
                                        <div class="w-1/3 font-semibold text-gray-600 flex items-center">
                                            <i class="fas fa-id-card mr-2"></i> ID
                                        </div>
                                        <div class="w-2/3 text-gray-800 bg-gray-50 p-2 rounded">${requestScope.usersDto.id}</div>
                                    </div>
                                    <div class="flex items-start">
                                        <div class="w-1/3 font-semibold text-gray-600 flex items-center">
                                            <i class="fas fa-user mr-2"></i> Name
                                        </div>
                                        <div class="w-2/3 text-gray-800 bg-gray-50 p-2 rounded">${requestScope.usersDto.name}</div>
                                    </div>
                                    <div class="flex items-start">
                                        <div class="w-1/3 font-semibold text-gray-600 flex items-center">
                                            <i class="fas fa-envelope mr-2"></i> Email
                                        </div>
                                        <div class="w-2/3 text-gray-800 bg-gray-50 p-2 rounded">${requestScope.usersDto.email}</div>
                                    </div>
                                    <div class="flex items-start">
                                        <div class="w-1/3 font-semibold text-gray-600 flex items-center">
                                            <i class="fas fa-mobile-alt mr-2"></i> Phone
                                        </div>
                                        <c:set var="mobile" value="${requestScope.usersDto.mobile}" />
                                        <div class="w-2/3 text-gray-800 bg-gray-50 p-2 rounded">
                                            ${fn:substring(mobile, 0, 3)}-${fn:substring(mobile, 3, 7)}-${fn:substring(mobile, 7, 11)}
                                        </div>
                                    </div>
                                </div>
                                <div class="space-y-4">
                                    <div class="flex items-start">
                                        <div class="w-1/3 font-semibold text-gray-600 flex items-center">
                                            <i class="fas fa-image mr-2"></i> Category
                                        </div>
                                        <div class="w-2/3 text-gray-800 bg-gray-50 p-2 rounded flex justify-center items-center">
										    <c:if test="${not empty requestScope.usersDto.category.categoryImagePath}">
										        <img src="<%= ctxPath%>/images/${requestScope.usersDto.category.categoryImagePath}" alt="카테고리이미지패스" style="width: 150px; height: 150px;">
										    </c:if>
										    <c:if test="${empty requestScope.usersDto.category.categoryImagePath}">
										        <img src="<%= ctxPath%>/images/unassigned.png" alt="카테고리이미지패스" style="width: 150px; height: 150px;">
										    </c:if>
										</div>
                                    </div>
                                    <div class="flex items-start">
                                        <div class="w-1/3 font-semibold text-gray-600 flex items-center">
                                            <i class="fas fa-coins mr-2"></i> Points
                                        </div>
                                        <div class="w-2/3 text-gray-800 bg-gray-50 p-2 rounded">
                                            <fmt:formatNumber value="${requestScope.usersDto.point}" pattern="###,###" /> POINT
                                        </div>
                                    </div>
                                    <div class="flex items-start">
                                        <div class="w-1/3 font-semibold text-gray-600 flex items-center">
                                            <i class="fas fa-calendar-alt mr-2"></i> Join Date
                                        </div>
                                        <div class="w-2/3 text-gray-800 bg-gray-50 p-2 rounded">${fn:substring(requestScope.usersDto.registerday, 0, 10)}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- SMS Section -->
                    <div class="bg-white rounded-xl card-shadow overflow-hidden mb-8">
                        <div class="gradient-bg text-white p-6">
                            <h2 class="text-xl font-bold flex items-center">
                                <i class="fas fa-comment-alt mr-3"></i> Send SMS Notification
                            </h2>
                        </div>
                        <div class="p-6">
                            <div class="mb-6 bg-blue-50 p-4 rounded-lg">
                                <div class="flex flex-col md:flex-row md:items-center md:justify-between">
                                    <div class="mb-3 md:mb-0">
                                        <span class="bg-red-600 text-white px-3 py-1 rounded-full text-sm font-semibold flex items-center">
                                            <i class="fas fa-clock mr-2"></i> Schedule SMS
                                        </span>
                                    </div>
                                    <div class="flex flex-col md:flex-row md:space-x-4">
                                        <div class="flex items-center mb-2 md:mb-0">
                                            <label class="mr-2 text-gray-700"><i class="fas fa-calendar-day mr-1"></i> Date:</label>
                                            <input type="date" id="reservedate" class="border rounded px-3 py-1">
                                        </div>
                                        <div class="flex items-center">
                                            <label class="mr-2 text-gray-700"><i class="fas fa-clock mr-1"></i> Time:</label>
                                            <input type="time" id="reservetime" class="border rounded px-3 py-1">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="flex flex-col md:flex-row gap-4">
                                <div class="flex-grow">
                                    <textarea rows="4" id="smsContent" class="w-full border rounded-lg p-3 focus:ring-2 focus:ring-blue-500 focus:border-blue-500" placeholder="Enter your message here..."></textarea>
                                </div>
                                <div class="flex items-center justify-center md:justify-start">
                                    <button id="btnSend" class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-3 px-6 rounded-lg transition flex items-center">
                                        <i class="fas fa-paper-plane mr-2"></i> 메세지 발송
                                    </button>
                                </div>
                            </div>

                            <div id="smsResult" class="mt-4 hidden">
                                <!-- Result will be shown here -->
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Navigation Buttons -->
                <div class="flex flex-col sm:flex-row justify-center gap-4 mt-8">
                    <button onclick="javascript:location.href='<%= ctxPath%>/admin/usersList'" class="bg-gray-600 hover:bg-gray-700 text-white font-bold py-2 px-6 rounded-lg transition flex items-center justify-center">
                        <i class="fas fa-list mr-2"></i> User List [Home]
                    </button>
                    <button onclick="javascript:history.back()" class="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-6 rounded-lg transition flex items-center justify-center">
                        <i class="fas fa-arrow-left mr-2"></i> Back [History]
                    </button>
                    <%-- <button onclick="javascript:location.href='${requestScope.referer}'" class="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-6 rounded-lg transition flex items-center justify-center">
                        <i class="fas fa-search mr-2"></i> Back [Search Results]
                    </button> --%>
                </div>
            </div>
        </main>

        <!-- Footer Placeholder -->
        <footer class="bg-gray-800 text-white p-4">
            <div class="container mx-auto text-center">
                <p>&copy; 2023 Admin Dashboard. All rights reserved.</p>
            </div>
        </footer>
    </div>
	
</body>
</html>