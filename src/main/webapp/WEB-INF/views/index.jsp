<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
    //     /justsurviveoffice
%>

<jsp:include page="header/header1.jsp" />

<c:if test="${param.error eq '1'}">
   <script>
      alert("관리자 중복로그인은 불가능 합니다!");
      
      (function(){
         try {
            var url = new URL(window.location.href);
            url.searchParams.delete('error');
            var qs = url.searchParams.toString();
            var newUrl = url.pathname + (qs ? '?' + qs : '') + url.hash;
            window.history.replaceState({}, document.title, newUrl);
         } catch (e) {}
      })();   /* IIFE (() => { ... })(); 는 "즉시 실행"이라 DOM 준비를 기다리지 않음. */
   </script>
</c:if>

<style>
.col-md-9 {
    border-radius: 10pt;
    background-size: cover;       /* 화면 전체에 꽉 차게 */
    background-position: center;  /* 중앙 기준으로 배치 */
    background-repeat: no-repeat; /* 이미지 반복 안 함 */
    background-attachment: fixed;       /* 스크롤 시 고정 */
    background-blend-mode: overlay;     /* 색상 오버레이 효과 동일 */
}
/* 카드 기본 스타일 */
.card {
    background-color: #3C396B;
    border-radius: 15px;
    transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
    overflow: hidden;
}

.card-body {max-height:168px;}

/* 이미지 반응형 */
.card img {
    width: 80%;
	min-height: 200px;
	max-height: 250px;
	
    object-fit: cover;
    border-radius: 10px;
}

/* 카드 hover 효과 */
.card:hover {
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
    animation: shake 0.4s ease-in-out;
}

/* 흔들림 애니메이션 */
@keyframes shake {
    0% { transform: translateX(0); }
    25% { transform: translateX(-5px) rotate(-1deg); }
    50% { transform: translateX(5px) rotate(1deg); }
    75% { transform: translateX(-3px) rotate(-1deg); }
    100% { transform: translateX(0); }
}

/* 카드 제목 */
.card-title {
    font-weight: bold;
    color: #39FF14;
}

/* 카드 설명 텍스트 */
.card-text {
    color: white;
    margin-bottom: 0.5rem;
}

/* 반응형 대응 */
@media (max-width: 992px) { /* 태블릿 이하 */
    .card img {
        max-height: 180px;
    }
}

@media (max-width: 768px) { /* 모바일 */

    .card img {
        max-height: 150px;
    }
    .card-title {
        font-size: 1.1rem;
    }
    .card-text {
        font-size: 0.9rem;
    }
}

@media (max-width: 480px) { /* 초소형 모바일 */
    .card {
        border-radius: 10px;
    }
    .card img {
        max-height: 120px;
    }
    .card-title {
        font-size: 1rem;
    }
    .card-text {
        font-size: 0.8rem;
    }
}
   /* 태그 버블 반짝임 */
   .tag-bubble {
       color: #3399ff;
       font-weight: 600;
       padding: 5px 10px;
       font-size: 0.85rem;
       position: relative;
       overflow: hidden;
   }
   .tag-bubble::after {
       content: "";
       position: absolute;
       top: -50%;
       left: -50%;
       width: 200%;
       height: 200%;
       background: radial-gradient(circle, rgba(255,255,255,0.6) 10%, transparent 60%);
       animation: sparkle 3s infinite linear;
   }
   .card-body {max-height:168px;}
</style>
	

<div class="col-md-9" style="background-image: url('<%= ctxPath %>/images/background.png');display:flex;justify-content:center; border-radius: 10px;background-position:center;background-size:cover;">
				
				<div class="row" style="width: 90%; margin: 5%; max-width:1000px;">
				<!-- 테스트 카드 (고정) --> 
				    <div class="col-sm-6 col-md-6 col-lg-4 mb-4">
						<a href="<%= ctxPath%>/categoryTest/survey" class="card text-decoration-none h-100" style="background-color: #3C396B; border-radius: 15px">
							<div style="margin: 5% 5%; height:60%;">
								<img src="<%= ctxPath%>/images/unassigned.png" class="card-img-top" alt="테스트" style="width:100%; height:100%; object-fit:cover;">
							</div>
							<div class="card-body">
								<h4 class="card-title" style="font-weight: bold; color: #39FF14;">테스트</h4>
								<p class="card-text" style="color: white;">당신의 성향을 알아보세요!</p>
							</div>
						</a>
					</div>
					<%-- begin과 end로 1번부터 5번 카테고리 1 증감식으로 수정함 0825 --%>
					<c:forEach var="indexList" items="${IndexList}" begin="0" end="4" step="1">
					  <div class="col-sm-6 col-md-6 col-lg-4 mb-4">
						<a href="<%= ctxPath%>/board/list/${indexList.categoryNo}" class="card text-decoration-none h-100" style="background-color: #3C396B; border-radius: 15px">
						  	<div style= "margin: 5% 5%;height: 60%;">
						  		<img src="${pageContext.request.contextPath}/images/${indexList.categoryImagePath}" alt="${indexList.categoryName}" 
						  					style="width:100%; height:100%; object-fit:cover; border-radius: 10px">
						  	</div>
						  	<div class="card-body">
						      <h4 class="card-title" style="font-weight: bold; color: #39FF14;">${indexList.categoryName}</h4>
						      <p class="card-text tag-bubble" style="color: white;">${indexList.tags}</p>
						      <p class="card-text" style="color: white;margin-bottom:10px;">${indexList.categoryDescribe}</p>
						    </div>
						 </a>
					  </div>
				</c:forEach>
			</div>
		</div>
	</div>
<jsp:include page="footer/footer1.jsp"></jsp:include>