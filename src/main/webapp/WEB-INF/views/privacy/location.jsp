<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
   String ctxPath = request.getContextPath();
    //     /MyMVC     
%>      
           
<jsp:include page="../header/header1.jsp" />


<style type="text/css">
   
   div#title {
      font-size: 20pt;
    /* border: solid 1px red; */
      padding: 12px 0;
   }
   
   div.mycontent {
        width: 300px;
        padding: 5px 3px;
     }
     
     div.mycontent>.title {
        font-size: 12pt;
        font-weight: bold;
        background-color: #d95050;
        color: #fff;
     }
     
     div.mycontent>.title>a {
        text-decoration: none;
        color: #fff;
     }
          
     div.mycontent>.desc {
      /* border: solid 1px red; */
        padding: 10px 0 0 0;
        color: #000;
        font-weight: normal;
        font-size: 9pt;
     }
     
     div.mycontent>.desc>img {
        width: 50px;
        height: 50px;
     }
     
     div.mapContent {overflow:hidden;background-color:#ddd;}
     div.mapContent #daumRoughmapContainer1757040743786 {width:100% !important;}
     
</style>
<div class="col-md-9 mapContent">
 	<h2 class="p-3" style="text-align:center;font-weight:600;">오시는 길</h2>
<!--
	* 카카오맵 - 약도서비스
	* 한 페이지 내에 약도를 2개 이상 넣을 경우에는
	* 약도의 수 만큼 소스를 새로 생성, 삽입해야 합니다.
-->
<!-- 1. 약도 노드 -->
<div id="daumRoughmapContainer1757040743786" class="root_daum_roughmap root_daum_roughmap_landing"></div>

<!-- 2. 설치 스크립트 -->
<script charset="UTF-8" class="daum_roughmap_loader_script" src="https://ssl.daumcdn.net/dmaps/map_js_init/roughmapLoader.js"></script>

<!-- 3. 실행 스크립트 -->
<script charset="UTF-8">
	new daum.roughmap.Lander({
		"timestamp" : "1757040743786",
		"key" : "vrihgvfxxo3",
		"mapWidth" : "1368",
		"mapHeight" : "600"
	}).render();
</script>


 </div>
</div>
<jsp:include page="../footer/footer1.jsp" />