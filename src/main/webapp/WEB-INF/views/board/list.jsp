<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
   String ctxPath = request.getContextPath();
    //     /myspring
%>
<jsp:include page="../header/header1.jsp" /> 

<style type="text/css">
th {background-color: #ddd}
.boardNameStyle {font-weight: bold;color: navy;cursor: pointer;}
a {text-decoration: none !important;}
.board-list {display: flex;flex-direction: column;gap: 16px;}
.board-card {border: 1px solid #ddd;border-radius: 8px;padding: 12px;margin-right: 10%;background: #fff;cursor: pointer;transition: box-shadow 0.2s;}
.board-card:hover {box-shadow: 0 2px 8px rgba(0,0,0,0.15);}
.board-card .title {font-size: 1.1rem;font-weight: bold;margin-bottom: 8px;}
.board-card .preview {font-size: 0.9rem;color: #555;margin-bottom: 8px;}
.board-card .thumbnail {width: 80px;height: 80px;object-fit: cover;margin-bottom: 8px;}
.board-card .meta {font-size: 0.8rem;color: #888;display: flex;gap: 10px;align-items:center;}
.title,content {white-space: nowrap;overflow: hidden;}

.autocomplete { position: relative; display: inline-block; }

#displayList{position: absolute;top: 100%;left: 0; right: 0;background: #fff;border: 1px solid #ccc;border-top: none;box-shadow: 0 4px 12px rgba(0,0,0,.12);z-index: 1000;display: none;max-height: 180px;overflow-y: auto;overflow-x: hidden;border-radius: 0 0 6px 6px;}
#displayList .result{display: block;padding: 6px 8px;line-height: 24px;white-space: nowrap;text-overflow: ellipsis;overflow: hidden;cursor: pointer;}
#displayList .result:hover{ background:#f5f7fa; }
#displayList .result span{ color:#d00; font-weight:600; } 

/* 검색 폼 스타일 */
form[name="searchForm"] {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 6px;
  margin-top: 15px;
}

/* 드롭다운 */
form[name="searchForm"] select {
  border-radius: 5px;
  padding: 4px 8px;
  border: 1px solid #ccc;
  font-size: 14px;
}

/* 검색창 */
form[name="searchForm"] .autocomplete {
  min-width: 160px;
}

form[name="searchForm"] input[name="searchWord"] {
  border: 1px solid #ccc;
  border-radius: 5px;
  padding: 6px 8px;
  font-size: 14px;
}

/* 자동완성 드롭다운 */
#displayList {
  border-radius: 0 0 5px 5px;
  font-size: 14px;
}

/* 버튼 */
form[name="searchForm"] button,
form[name="searchForm"] a.btn {
  border-radius: 5px;
  font-size: 14px;
  padding: 6px 12px;
  white-space: nowrap;
}

/* navy 글쓰기 버튼 */
form[name="searchForm"] #writeBtn {
  background-color: navy !important;
  border: none;
}

/* 반응형 */
@media (max-width: 640px) {
  form[name="searchForm"] {
    flex-direction: column;
    align-items: stretch;
  }
  form[name="searchForm"] select,
  form[name="searchForm"] button,
  form[name="searchForm"] a.btn {
    width: 100%;
  }
}


.col-md-9 {border-radius: 10pt;background-size: cover;  background-position: center;background-repeat: no-repeat;background-attachment: fixed;background-blend-mode: overlay;}
.keyword-panel {position: absolute;top:6px; right:16px;width: 180px;background: rgba(255,255,255,0.35); border: 1px solid rgba(0,0,0,0.08);border-radius: 10px;box-shadow: 0 6px 18px rgba(0,0,0,0.08);backdrop-filter: blur(4px); -webkit-backdrop-filter: blur(4px);overflow: hidden;z-index: 5;                    }
.keyword-header {padding: 10px 12px;font-weight: 700;font-size: 0.95rem;color: #333;background: rgba(255,255,255,0.25);border-bottom: 1px solid rgba(0,0,0,0.06);}
.keyword-table-wrap {max-height: 260px;overflow: auto;}
.keyword-table {width: 100%;border-collapse: collapse;table-layout: fixed;font-size: 0.92rem;color: #222;}
.keyword-table th, .keyword-table td {padding: 8px 10px;border-bottom: 1px solid rgba(0,0,0,0.06);background: transparent;}
.keyword-table th {text-align: left;color: #444;font-weight: 600;position: sticky;top: 0;background: rgba(255,255,255,0.28); backdrop-filter: blur(4px);}
.keyword-table td:nth-child(2) {text-align: right;width: 64px;color: #555;}
.keyword-table tbody tr:hover {background: rgba(0,0,0,0.035);}
.keyword-word {white-space: nowrap;text-overflow: ellipsis;overflow: hidden;max-width: 160px;display: inline-block;}
.listTitle {line-height:2.5rem;margin:30px 0;}
#searchWord {width:70%;}

@media screen and (max-width:1300px){
	.keyword-panel {position:relative;top:initial;right:initial;}
}

/* ------------------------------------------------------------------------------- */
/* ====== 반응형 개선 ====== */
/* 가로폭이 줄면 패널 폭 조금 늘리고 글자 약간 작게 */
@media (max-width: 1200px) {
  .keyword-panel { width: 220px; right:12px; }
}
@media (max-width: 992px) {
  .keyword-panel { width: min(28vw, 300px); }
  .keyword-table { font-size: 0.9rem; }
  .keyword-word { max-width: calc(100% - 74px); }
}

/* 모바일: 패널은 숨겨두고, 플로팅 버튼으로 열기 */
.keyword-fab { display:none; } /* 기본은 숨김(데스크탑 X) */

@media (max-width: 640px) {
  /* 패널을 화면 하단으로 고정 + 기본은 닫힘 상태 */
  .keyword-panel {
    position: fixed;
    right: 12px;
    left: auto;
    bottom: 60px;
    top: auto;
    width: min(92vw, 360px);
    max-height: 70vh;
    transform: translateY(110%);
    opacity: 0;
    pointer-events: none;
    transition: transform .25s ease, opacity .2s ease;
  }
  .keyword-panel.open {
    transform: translateY(0);
    opacity: 1;
    pointer-events: auto;
  }

  /* 플로팅 버튼 노출 */
  .keyword-fab {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    position: fixed;
    right: 12px;
    bottom: 12px;
    width: 52px;
    height: 52px;
    border-radius: 50%;
    border: 1px solid rgba(0,0,0,.08);
    background: rgba(255,255,255,.9);
    backdrop-filter: blur(4px);
    -webkit-backdrop-filter: blur(4px);
    box-shadow: 0 6px 18px rgba(0,0,0,0.12);
    font-weight: 700;
    font-size: 12px;
    color: #333;
    z-index: 6;
  }

  /* 모바일에서 표 가독성 조정 */
  .keyword-table { font-size: 0.88rem; }
  .keyword-table-wrap { max-height: 56vh; }
  .keyword-word { max-width: calc(100% - 80px); }
}


</style> 

<script type="text/javascript">
 $(function(){

   $('span.boardName').hover(function(e){
	   $(e.target).addClass("boardNameStyle");
	   },function(e){
	   $(e.target).removeClass("boardNameStyle");
   });
	   
   // 글검색시 글검색어 입력후 엔터를 했을 경우 이벤트 작성하기
   $('input:text[name="searchWord"]').bind("keyup", function(e){
	   if(e.keyCode == 13) { // 엔터를 했을 경우
		   searchBoard();
	   }
   });
	   
   // 글목록 검색시 검색조건 및 검색어 값 유지시키기
   if(${not empty requestScope.searchType}) {
	   $('select[name="searchType"]').val("${requestScope.searchType}");
   }
   if(${not empty requestScope.searchWord}) {
	   $('input[name="searchWord"]').val("${requestScope.searchWord}");
   }
	   
   <%-- === 검색어 입력시 자동글 완성하기 === --%>
   // 입력이 없던 초기 div 숨기기.
   $('div#displayList').hide();
   $('input[name="searchWord"]').keyup(function(){
	   const wordLength = $(this).val().trim().length;
	   // 검색어에서 공백을 제거한 길이를 알아온다.
	   if(wordLength == 0) {
		   $('div#displayList').hide();
		   // 검색어가 공백이거나 검색어 입력후 백스페이스키를 눌러서 검색어를 모두 지우면 검색된 내용이 안 나오도록 해야 한다. 
	   }
	   else {
		   if( $('select[name="searchType"]').val() == "boardName" || 
			   $('select[name="searchType"]').val() == "boardContent" || 
			   $('select[name="searchType"]').val() == "boardName_boardContent" ||
			   $('select[name="searchType"]').val() == "fk_id") {
			   
			   $.ajax({
				   url:"<%= ctxPath%>/board/wordSearchShow",
				   type:"get",
				   data:{"searchType":$('select[name="searchType"]').val()
					    ,"searchWord":$('input[name="searchWord"]').val()
					    ,"category":${category}},
				   dataType:"json",
				   success:function(json){
					   if(json.length > 0) {
						   // 검색된 데이터가 있는 경우임.
						   let v_html = ``;
						   $.each(json, function(index, item){
							   const word = item.word;
							   const idx = word.toLowerCase().indexOf($('input[name="searchWord"]').val().toLowerCase());
							   const len = $('input[name="searchWord"]').val().length;
						       const result = word.substring(0, idx) + "<span style='color:red;'>"+word.substring(idx, idx+len)+"</span>" + word.substring(idx+len);
						       v_html += `<span class='result'>\${result}</span>`;
						   });// end of $.each(json, function(index, item){})-------------------
						   
						   const input_width = $('input[name="searchWord"]').css("width"); // 검색어 input 태그 width 값 알아오기 
						   $('div#displayList').css({"width":input_width}); // 검색결과 div 의 width 크기를 검색어 입력 input 태그의 width 와 일치시키기 
						   $('div#displayList').html(v_html).show();
					   }
				   },
				   error: function(request, status, error){
					   console.log("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				   } 
			   });
		   }
	   }
   });// end of $('input[name="searchWord"]').keyup(function(){})-----------------
   
   <%-- === 검색어 입력시 자동글 완성하기  === --%>
   $(document).on('click', 'span.result', function(e){
	    const word = $(this).text()
	    $('input[name="searchWord"]').val(word); // 텍스트박스에 검색된 결과의 문자열을 입력해준다.
	    $('div#displayList').hide();
	    searchBoard(); // 글목록 검색하기 요청
   });
	   
   
   /* ------------------------------------------------------ */
   const panel = document.getElementById('keywordPanel');
   const fab   = document.getElementById('kwFab');
   if (!panel || !fab) return;

   fab.addEventListener('click', function() {
     panel.classList.toggle('open');
     const open = panel.classList.contains('open');
     fab.setAttribute('aria-expanded', open);
     fab.title = open ? 'TOP 키워드 닫기' : 'TOP 키워드 열기';
   });
   
   
   
 }); // end of $(function(){})--------------------------
   
   
   // Function Declaration
   function view(boardNo, fk_id){

    // 글 1개만 보기( POST 방식 )
    const form = document.viewForm;
    form.boardNo.value = boardNo;
    form.fk_id,value = fk_id   
    if(${not empty requestScope.searchType
       || not empty requestScope.searchWord}) {
      // 글목록보기시 검색조건이 있을 때 글 1개 보기를 하면, 
      // 글 1개를 보여주면서 이전글보기 다음글보기를 하면 검색조건내에서 이전 과 다음글이 나와야 하므로 
      // 글목록보기시 검색조건을 /board/view 을 담당하는 메소드로 넘겨주어야 한다.
      form.searchType.value = "${requestScope.searchType}"; 
      form.searchWord.value = "${requestScope.searchWord}"; 
    }
    form.method = "";
    form.action = "<%= ctxPath%>/board/view";
    form.submit();
   
   }// end of function view(boardNo,fk_id)----------------------

   <!-- 북마크기능 -->
   function bookmark(boardNo, fk_id, isBookmarked) {
	    const url = isBookmarked
			        ? "<%= ctxPath%>/bookmark/remove"
			        : "<%= ctxPath%>/bookmark/add";
	    $.ajax({
	        url: url,
	        type: "POST",
	        data: { fk_boardNo: boardNo },
	        success: function(json) {
	            const icon = $('#bookmark-icon-'+boardNo);
	            
	            if (json.success) {
	            	icon.removeClass("fa-solid fa-bookmark text-warning fa-regular");
	            	if (isBookmarked) {
	            	    // 해제된 상태로 변경
	            	    icon.addClass("fa-regular fa-bookmark");
	            	    icon.attr("onclick", "bookmark(" + boardNo + ", '" + fk_id + "', false)");
	            	} else {
	            	    // 추가된 상태로 변경
	            	    icon.addClass("fa-solid fa-bookmark text-warning");
	            	    icon.attr("onclick", "bookmark(" + boardNo + ", '" + fk_id + "', true)");
	            	}
	            } else {
	                alert(json.message);
	                window.location.href = "<%=ctxPath%>/users/loginForm";
	            }
	        },
	        error: function(request, status, error) {
	            alert("code:" + request.status + "\nmessage:" + request.responseText);
	        }
	    });
	 }// end of function Bookmark(boardNo,fk_id)———————————
	
   // === 글목록 검색하기 요청 === //
   function searchBoard() {
      const form = document.searchForm;
     
      form.method = "get";
      form.action = "<%= ctxPath%>/board/list/${category}";
        
      form.submit();
    }
   
</script>


<div class="col-md-9 ListHeight" style="border-radius: 10pt; 
		background-image: url('<%= ctxPath %>/images/background.png');">
    <div name="categoryDiv" style="font-size: 20px; font-weight: bold; color: gray; margin: 2% 0">
		<c:if test="${requestScope.category eq 1}">
			<span>MZ들의&nbsp;</span></c:if>
		<c:if test="${requestScope.category eq 2}">
			<span>꼰대들의&nbsp;</span></c:if>
		<c:if test="${requestScope.category eq 3}">
			<span>노예들의&nbsp;</span></c:if>		
		<c:if test="${requestScope.category eq 4}">
			<span>MyWay들의&nbsp;</span></c:if>
		<c:if test="${requestScope.category eq 5}">
			<span>금쪽이들의&nbsp;</span></c:if>
		<span>생존 게시판</span>
	</div>
	
	<!-- 모바일 전용: 플로팅 버튼 -->
	<button class="keyword-fab" id="kwFab" aria-expanded="false" aria-controls="keywordPanel" title="TOP 키워드 열기">키워드</button>
	
	
	<!-- === 키워드 패널 (우측 상단) === -->
	<div class="keyword-panel" id="keywordPanel">
	  <div class="keyword-header text-center">TOP 키워드</div>
	  <div class="keyword-table-wrap">
	    <table class="keyword-table" >
	      <tbody>
	        <!-- 컨트롤러에서 List<Map.Entry<String,Integer>> keywordTop 로 전달했다고 가정 -->
	        <c:if test="${not empty keyword_top}">
	          <c:forEach var="map" items="${keyword_top}">
	            <tr>
	              <td><span class="keyword-word">${map.keyword}</span></td>
	              <td>${map.score}</td>
	            </tr>
	          </c:forEach>
	        </c:if>
	
	        <!-- 데이터 없을 때 기본 틀(placeholder) -->
	        <c:if test="${empty keyword_top}">
	          <tr><td><span class="keyword-word">데이터 없음</span></td><td>0</td></tr>
	          <tr><td><span class="keyword-word">—</span></td><td>0</td></tr>
	          <tr><td><span class="keyword-word">—</span></td><td>0</td></tr>
	        </c:if>
	      </tbody>
	    </table>
	  </div>
	</div>
	
   <h2 class="listTitle" style="font-size: 25pt; font-weight: bold;">글목록</h2>
   <%-- === 글검색 폼 추가하기 : 글제목, 글내용, 글제목+글내용, 글쓴이로 검색을 하도록 한다. === --%>
   <form name="searchForm" style="margin-top: 20px;">
      <select name="searchType" style="height: 32px;">
         <option value="boardName">글제목</option>
         <option value="boardContent">글내용</option>
         <option value="boardName_boardContent">글제목+글내용</option>
         <option value="fk_id">글쓴이</option>
      </select>
      
       <!-- 입력창 + 자동완성 드롭다운을 한 박스로 묶기 -->
      <span class="autocomplete">
      	<input id="searchWord" type="text" name="searchWord" size="60" autocomplete="off" />
      	<div id="displayList"></div>
      </span>
       
      <input type="text" style="display: none;"/> <%-- form 태그내에 input 태그가 오로지 1개 뿐일경우에는 엔터를 했을 경우 검색이 되어지므로 이것을 방지하고자 만든것이다. --%>  
      <button type="button" class="btn btn-secondary btn-sm" onclick="searchBoard()">검색</button> 
      
      <span><a href="<%=ctxPath %>/board/write/${category}" class="btn btn-secondary btn-sm" 
            id="writeBtn" style="background-color: navy;">글쓰기</a></span>
      <!-- <span><input type="hidden" name="category"/></span> 1-->
   </form> 
   
   
   <%--  특정 글제목을 클릭했을때, 특정 글1개를 보여줄때 POST 방식으로 넘기기 위해 form 태그를 만들겠다. --%>
   <form name="viewForm">
      <input type="hidden" name="boardNo"/>
      <input type="hidden" name="fk_id" /> 
      <input type="hidden" name="searchType" />
      <input type="hidden" name="searchWord" />
      <input type="hidden" name="category" value="${category}" />
   </form>
   
   <br><br>
    <c:if test="${not empty requestScope.boardList}">
		<div class="board-list">
		  <c:forEach var="boardDto" items="${boardList}" varStatus="status">
		    <div class="board-card">
		      <div style="display: flex;" onclick="view('${boardDto.boardNo}', '${boardDto.fk_id}')">
		        <div>
		       		 <!-- 제목 -->
		        	<h3 class="title" style="margin-right:0">${boardDto.boardName}</h3>
					<!-- 내용 -->
		    	 	<div class="content" style="color: grey">${boardDto.textForBoardList}</div>
		        </div>
		        <!-- 첨부 이미지 썸네일 -->
		        <c:if test="${boardDto.imgForBoardList ne null}">
		          <img src="${boardDto.imgForBoardList}" class="thumbnail" style="margin-left: auto;"/>
		        </c:if>
		        <c:if test="${boardDto.imgForBoardList eq null}"><br><br><br></c:if>
		      </div>
		       
		      <!-- 작성자/날짜/조회수 -->
		      <div class="meta" >
		        <span>${boardDto.fk_id}</span>
		        <span>${boardDto.formattedDate}</span>
		        <span class="fa-regular fa-eye" style="font-size: 8pt">&nbsp;${boardDto.readCount}</span>
				
				<form id="bookmarkForm-${boardDto.boardNo}">
				    <input type="hidden" name="fk_boardNo" value="${boardDto.boardNo}">
				    <input type="hidden" name="fk_id" value="${sessionScope.loginUser.id}">
				    <i id="bookmark-icon-${boardDto.boardNo}"
				       class="fa-bookmark ${boardDto.bookmarked ? 'fa-solid text-warning' : 'fa-regular'}"
				       style="cursor: pointer;"
				       onclick="bookmark( ${boardDto.boardNo}, '${sessionScope.loginUser.id}', ${boardDto.bookmarked ? true : false})">
				    </i>
				</form>
				
		      </div>
		    </div>
		  </c:forEach>
		</div>
	</c:if>

    <c:if test="${empty requestScope.boardList}">
      <tr>
        <td colspan="6">첫 번째 게시물을 올려보세요!</td> 
      </tr>
    </c:if>
   
   
   <%-- === 페이지바 보여주기 === --%>
   <div align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
        <!-- 페이지 바 시작 -->
		<c:set var="cur"  value="${requestScope.currentShowPageNo}" />
		<c:set var="last" value="${requestScope.totalPage}" />
		
		<div class="pagination1">
			
			<!-- 맨처음 -->
			<c:choose>
				<c:when test="${cur > 1}">
					<c:url var="firstUrl" value="/board/list/${requestScope.category}">	<!-- JSP에서 URL을 안전하게 만들어주는 JSTL 태그 -->
						<c:param name="currentShowPageNo" value="1"/>	<!-- URL 뒤에 붙을 쿼리 파라미터를 추가하는 태그 -->
						<c:param name="searchType" value="${requestScope.searchType}"/>
						<c:param name="searchWord" value="${requestScope.searchWord}"/>
					</c:url>
					<a class="page-btn" href="${firstUrl}">&laquo;</a>
				</c:when>
				<c:otherwise>
					<span class="page-btn disabled">&laquo;</span>
				</c:otherwise>
			</c:choose>
			
			<!-- 이전 -->
			<c:choose>
				<c:when test="${cur > 1}">
					<c:url var="prevUrl" value="/board/list/${requestScope.category}">
						<c:param name="currentShowPageNo" value="${cur - 1}"/>
						<c:param name="searchType" value="${requestScope.searchType}"/>
						<c:param name="searchWord" value="${requestScope.searchWord}"/>
					</c:url>
					<a class="page-btn" href="${prevUrl}">⬅️</a>
				</c:when>
				<c:otherwise>
					<span class="page-btn disabled">⬅️</span>
				</c:otherwise>
			</c:choose>
			
			<!-- 페이지 번호 -->
			<c:forEach var="i" begin="1" end="${last}">
				<c:choose>
					<c:when test="${i == cur}">
						<a class="page-btn active" href="#">${i}</a>
					</c:when>
					<c:otherwise>
						<c:url var="pageUrl" value="/board/list/${requestScope.category}">
							<c:param name="currentShowPageNo" value="${i}"/>
							<c:param name="searchType" value="${requestScope.searchType}"/>
							<c:param name="searchWord" value="${requestScope.searchWord}"/>
						</c:url>
						<a class="page-btn" href="${pageUrl}">${i}</a>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			
			<!-- 다음 -->
			<c:choose>
				<c:when test="${cur < last}">
					<c:url var="nextUrl" value="/board/list/${requestScope.category}">
						<c:param name="currentShowPageNo" value="${cur + 1}"/>
						<c:param name="searchType" value="${requestScope.searchType}"/>
						<c:param name="searchWord" value="${requestScope.searchWord}"/>
					</c:url>
					<a class="page-btn" href="${nextUrl}">➡️</a>
				</c:when>
				<c:otherwise>
					<span class="page-btn disabled">➡️</span>
				</c:otherwise>
			</c:choose>
			
			<!-- 마지막 -->
			<c:choose>
				<c:when test="${cur < last}">
					<c:url var="lastUrl" value="/board/list/${requestScope.category}">
						<c:param name="currentShowPageNo" value="${last}"/>
						<c:param name="searchType" value="${requestScope.searchType}"/>
						<c:param name="searchWord" value="${requestScope.searchWord}"/>
					</c:url>
					<a class="page-btn" href="${lastUrl}">&raquo;</a>
				</c:when>
				<c:otherwise>
					<span class="page-btn disabled">&raquo;</span>
				</c:otherwise>
			</c:choose>
			
		</div>
		<!-- 페이지 바 종료 -->
   </div>
   
  </div>   
 </div>
</div>
</div>
 <jsp:include page="../footer/footer1.jsp"></jsp:include>