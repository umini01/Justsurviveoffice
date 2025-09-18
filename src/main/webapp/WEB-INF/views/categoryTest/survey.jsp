<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>

<%
   String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>설문 시작 페이지</title>

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<style>
   html{display:flex;align-items:center;height:100%;justify-content:center;}
   .survey-container {
      max-width: 450px;
      margin: 9% auto;
      padding: 20px;
      background: #f8f9fa;
      border-radius: 20px;
      box-shadow: 0 6px 14px rgba(0,0,0,0.08);
   }
   .survey-image img {
      border-radius: 16px;
   }
   .btn-blue {
      background-color: #4da3ff;
      border: none;
      padding: 14px;
      font-weight: bold;
      border-radius: 30px;
      color: white;
      width: 100%;
   }
   .btn-blue:hover { background-color: #368ce8; }

   /* 로딩 */
   .loader {
      border: 12px solid #f3f3f3;
      border-radius: 50%;
      border-top: 12px solid #007bff;
      width: 80px;
      height: 80px;
      animation: spin 1.5s linear infinite;
   }
   @keyframes spin { 0%{transform:rotate(0deg);} 100%{transform:rotate(360deg);} }
   #loading-screen {
      position: fixed; inset:0;
      background: rgba(255,255,255,0.7);
      display:flex; justify-content:center; align-items:center;
      z-index:9999;
   }

   /* 슬라이드 */
   .slides-wrapper {
      overflow: hidden;
      width: 100%;
   }
   .slides {
      display: flex;
      transition: transform .35s ease;
   }
   .slide {
      min-width: 100%;
      box-sizing: border-box;
   }

   /* 질문/옵션 버블 */
   .question-bubble {
      background: #fff;
      border-radius: 20px;
      padding: 15px 20px;
      margin-bottom: 35px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
      text-align: left;
   }
   .question-bubble .QNo {
      font-size: 1rem;
      font-weight: bold;
      color: #3399FF; /* 진한 파랑 */
      margin-bottom: 10px;
   }
   .question-bubble .QText {
      font-size: 1.1rem;
      font-weight: 600;
      color: #333;
   }
   .option-bubble {
      background: #e9f3ff;
      border-radius: 20px;
      padding: 12px 18px;
      margin: 10px 0;
      cursor: pointer;
      transition: background 0.2s ease;
      text-align: left;
   }
   .option-bubble:hover { background: #cfe7ff; }
   .option-bubble:active { background: #b5d9ff; }

   /* 결과 화면 꾸밈 (축소 버전) */
   .result-bubble {
      background: #fff;
      border-radius: 16px;
      padding: 18px;              /* 여백 줄임 */
      box-shadow: 0 3px 10px rgba(0,0,0,0.08);
      margin-top: 15px;           /* 위 간격 줄임 */
      text-align: center;
   }
   .result-image {
      border-radius: 12px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.08);
      max-height: 200px;          /* 이미지 높이 제한 */
      object-fit: cover;          /* 비율 유지 자르기 */
   }
   /* 결과 제목 반짝반짝 효과 */
   .result-title {
       font-size: 1.2rem;
       font-weight: 600;
       color: #3399ff;
       margin-top: 10px;
       animation: glow 2s ease-in-out infinite alternate;
   }
   
   @keyframes glow {
       from {
           text-shadow: 0 0 5px #99ccff, 0 0 10px #99ccff;
       }
       to {
           text-shadow: 0 0 15px #3399ff, 0 0 30px #66b2ff;
       }
   }
   .result-tags {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 6px;                   /* 태그 간격 줄임 */
      margin: 12px 0;             /* 여백 줄임 */
   }
   /* 태그 버블 반짝임 */
   .tag-bubble {
       background: #e9f3ff;
       color: #3399ff;
       font-weight: 600;
       padding: 5px 12px;
       border-radius: 16px;
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
       background: radial-gradient(circle, rgba(255,255,255,0.6) 20%, transparent 60%);
       animation: sparkle 3s infinite linear;
   }
   @keyframes sparkle {
       from { transform: translate(0,0) rotate(0deg); }
       to { transform: translate(50%,50%) rotate(360deg); }
   }
   /* 떨어지는 별 */
   .falling-star {
       position: absolute;
       color: #ffd700;   /* 금색 별 */
       font-size: 1rem;
       opacity: 0;
       animation: fall 5s linear infinite;
   }
   
   @keyframes fall {
       0% {
           transform: translateY(-20px) scale(0.8);
           opacity: 0;
       }
       20% {
           opacity: 1;
       }
       80% {
           opacity: 1;
       }
       100% {
           transform: translateY(250px) scale(0.5);
           opacity: 0;
       }
   }
</style>
</head>
<body class="bg-light">
   
   <!-- 로딩 -->
   <div id="loading-screen">
      <div class="loader"></div>
   </div>
   
   <!-- 시작 화면 -->
   <div class="survey-container text-center">
      <h4 class="fw-bold text-primary">성향 TEST</h4>
      <p class="text-muted">어떤 유형인지 알아보세요.</p>
      
      <div class="survey-image my-3">
         <img src="<%= ctxPath %>/images/mz.png" class="img-fluid w-100" alt="성향 이미지">
      </div>
      
      <button type="button" class="btn-start btn-blue">설문 시작하기</button>
      <button type="button" class="btn-home btn-blue mt-3 ">게시판으로 돌아가기</button>
   </div>

<script>
   const isLogin = ${not empty sessionScope.loginUser};
   
   $(function(){
      $("#loading-screen").hide();
      $(".btn-start").click(function(){ // 설문을 시작하는 버튼.
         $(".survey-container").empty();
         $("#loading-screen").show();
         surveyStart();
      });
      
      $(".btn-home").click(function(){ // index로 돌아가는 버튼.
    	 location.href = '<%= ctxPath %>/index';
      });
      
   });

   // 설문 시작
   function surveyStart() {
      $.ajax({
         url:"<%= ctxPath%>/categoryTest/surveyStart",
         dataType:"json",
         success:function(json){
            let v_html = `
            <div class="slides-wrapper">
               <div class="slides" id="slides">`;
            
            $.each(json, function(index, item){
               v_html += `
               <div class="slide px-2">
                  <div class="question-bubble">
                     <div class="QNo">Q\${index+1}</div>
                     <div class="QText">\${item.text}</div>
                  </div>`;
               
               $.each(item.options, function(opt_index, opt_item){
                  v_html += `
                     <div class="option-bubble opt-btn" 
                        data-qstno="\${index}" 
                        data-cat="\${opt_item.categoryNo}">
                        \${opt_item.text}
                     </div>`;
               });
               
               v_html += `</div>`;
            });
            
            v_html += `</div></div>`;
            $(".survey-container").html(v_html);
            
            const total = json.length;
            const answer_arr = [];
            
            $(".survey-container").on("click", ".opt-btn", function(){
               const qstno = Number($(this).data("qstno"));
               const optionNo = Number($(this).data("cat"));
               answer_arr[qstno] = optionNo;
               
               if(qstno < total-1){
                  $("#slides").css("transform", `translateX(-\${(qstno+1)*100}%)`);
               } else {
                  submitAnswers(answer_arr);
               }
            });
         },
         complete:function(){
            $("#loading-screen").hide();
         }
      });
   }

   // 결과 제출
   function submitAnswers(answer_arr) {
      $("#loading-screen").show();
      
      $.ajax({
         url:"<%= ctxPath%>/categoryTest/submit",
         method:"POST",
         data:{"answer_arr":answer_arr},
         dataType:"json",
         success:function(json){
            let r_html = `
            <div class="result-bubble">
               
                 <!-- 흩날리는 별들 (떨어지는 효과) -->
                 <i class="fa-solid fa-star falling-star" style="top:-10px; left:20%; animation-delay:0s;"></i>
                 <i class="fa-solid fa-star falling-star" style="top:-10px; left:50%; animation-delay:1s;"></i>
                 <i class="fa-solid fa-star falling-star" style="top:-10px; left:75%; animation-delay:2s;"></i>
            
               <img src="<%= ctxPath %>/images/\${json.categoryImagePath}" class="img-fluid result-image mb-3" alt="\${json.categoryName}">
               
               <h3 class="result-title">\${json.categoryName}</h3>
               
               <div class="result-tags">`;
            
            $.each(json.tags, function(i, tag){
               r_html += `<span class="tag-bubble">#\${tag}</span>`;
            });
            
            r_html += `</div></div>`;
            
            if (!isLogin) {
               r_html += `<button class="btn btn-outline-primary btn-lg w-100 mt-3 fw-bold" onclick="login()">로그인하고 성향 저장하기</button>`;
            } else {
               r_html += `
           	   <button class="btn btn-outline-primary btn-lg w-100 fw-bold" onclick="saveCategory()">성향 GET!</button>
               <form name="surveyForm" class="mt-4">   
                  <input type="hidden" name="categoryNo" value="\${json.categoryNo}"/>   
               </form>`;
            }
            
            r_html += `<button class="btn btn-outline-secondary btn-lg w-100 mt-3 fw-bold" onclick="retryTest()">테스트 다시하기</button>`;
            
            $(".survey-container").html(r_html);
         },
         complete:function(){
            $("#loading-screen").hide();
         }
      });
    }
    function login() {
		location.href = '<%= ctxPath %>/users/loginForm';
	}
	function saveCategory() {
		const form = document.surveyForm;
		if(confirm("한 번 저장한 성향은 변경할 수 없습니다.\n저장하시겠습니까?")){
			form.method = "post";
		    form.action = "<%= ctxPath %>/categoryTest/saveCategoryNo";
		    form.submit();			
		}
	}
	function retryTest() {
		location.href = '<%= ctxPath %>/categoryTest/survey';
	}
</script>
</body>
</html>