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
    .boardNameStyle {font-weight: bold;
                   color: navy;
                   cursor: pointer;}
    a {text-decoration: none !important;} /* 페이지바의 a 태그에 밑줄 없애기 */
.board-list {
  display: flex;
  flex-direction: column;
  gap: 1px;
  overflow-y: scroll;
  max-height: 850px;
}

.board-card {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 12px;
  margin-right: 10%;
  background: #fff;
  cursor: pointer;
  transition: box-shadow 0.2s;
}

.board-card:hover {
  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
}

.board-card .title {
  font-size: 1.1rem;
  font-weight: bold;
  margin-bottom: 8px;
}

.board-card .preview {
  font-size: 0.9rem;
  color: #555;
  margin-bottom: 8px;
}

.board-card .thumbnail {
  width: 80px;
  height: 80px;
  object-fit: cover;
  margin-bottom: 8px;
}

.board-card .meta {
  font-size: 0.8rem;
  color: #888;
  display: flex;
  gap: 10px;
  align-items: center;
}

.title,content { /* 제목과 내용의 라인을 한줄로 제한하고, 이상이되면 안보이게! */
    white-space: nowrap;
    overflow: hidden;
}


/* 입력창-자동완성 래퍼 */
.autocomplete { position: relative; display: inline-block; }

/* 자동검색 박스 */
#displayList{
  position: absolute;        /* 입력창 바로 아래 붙이기 */
  top: 100%;
  left: 0; right: 0;
  background: #fff;
  border: 1px solid #ccc;
  border-top: none;
  box-shadow: 0 4px 12px rgba(0,0,0,.12);
  z-index: 1000;
  display: none;
  max-height: 180px;         /* 대략 6줄 */
  overflow-y: auto;          /* 넘치면 스크롤 */
  overflow-x: hidden;
  border-radius: 0 0 6px 6px;
}

/* 항목 스타일 */
#displayList .result{
  display: block;            /* 줄바꿈 대신 블록으로 */
  padding: 6px 8px;
  line-height: 24px;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  cursor: pointer;
}
#displayList .result:hover{ background:#f5f7fa; }
#displayList .result span{ color:#d00; font-weight:600; } /* 강조색 */


/* ------------------------------------------------  */
.categoryDiv {
border: 1px solid #C7C7C7;
border-radius: 8px;
padding: 7px;
background: #B9C4EB;
transition: 0.3s;
font-size: 20px; 
font-weight: bold; 
color: white;
margin: 25% 0 5% 0;
}
.plus-btn {
justify-content: center;
align-items: center;
margin-left: 5pt;
background: white;
padding: 1pt 3pt;
border-radius: 25%;  
font-size: 5%;
font-weight: bold;   
color: black;              
cursor: pointer;
}
</style> 

<script type="text/javascript">
  function view(boardNo, fk_id){
      const form = document.getElementById('viewForm-' + boardNo);
      form.boardNo.value = boardNo;
      form.fk_id.value = fk_id;
      // 검색조건
      form.searchType.value = "${requestScope.searchType}";
      form.searchWord.value = "${requestScope.searchWord}";
      form.method = "get";
      form.action = "<%= ctxPath%>/board/view";
      form.submit();
  }
//<!-- 북마크기능 -->
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
   
</script>

<div class="col-md-9 ListHeight" style="border-radius: 10pt; 
      background-image: url('<%= ctxPath %>/images/background.png');">
   
   
   <h2 style="margin: 30px 0; font-size: 25pt; font-weight: bold;">전체 글목록</h2>
      <c:if test="${loginUser.getCategory().getCategoryNo() ne 6 
                  and loginUser.getCategory().getCategoryNo() ne null}">
         <span><a href="<%=ctxPath %>/board/write/${loginUser.getCategory().getCategoryNo()}" class="btn btn-secondary btn-sm" 
            id="writeBtn" style="background-color: #FEB5FF; font-weight: bold;">내 유형으로 글쓰러 가기</a></span>
      </c:if>
      <c:if test="${loginUser.getCategory().getCategoryNo() eq 6}">
       <span><a href="<%=ctxPath %>/board/write/1" class="btn btn-secondary btn-sm mb-1" 
            id="writeBtn" style="background-color: #FEB5FF; font-weight: bold;">MZ유형으로 글쓰러 가기</a></span>
        <span><a href="<%=ctxPath %>/board/write/2" class="btn btn-secondary btn-sm mb-1" 
            id="writeBtn" style="background-color: #FEB5FF; font-weight: bold;">꼰대유형으로 글쓰러 가기</a></span>
        <span><a href="<%=ctxPath %>/board/write/3" class="btn btn-secondary btn-sm mb-1" 
            id="writeBtn" style="background-color: #FEB5FF; font-weight: bold;">노예유형으로 글쓰러 가기</a></span>
        <div><span><a href="<%=ctxPath %>/board/write/4" class="btn btn-secondary btn-sm mb-1" 
            id="writeBtn" style="background-color: #FEB5FF; font-weight: bold;">마이웨이유형으로 글쓰러 가기</a></span>
        <span><a href="<%=ctxPath %>/board/write/5" class="btn btn-secondary btn-sm mb-1" 
            id="writeBtn" style="background-color: #FEB5FF; font-weight: bold;">금쪽이유형으로 글쓰러 가기</a></span></div>
      </c:if>      
   
   <br><br>
    <c:if test="${not empty requestScope.boardList}">
      <div class="board-list">
        <c:set var="changeCategory" value="" />
        <c:forEach var="boardDto" items="${boardList}">
          <!-- 카테고리 이름이 바뀌었을 때만 출력 -->
          <c:if test="${changeCategory ne boardDto.categoryName}">
            <div class="category-block mt-4 mb-2">
              <span class="categoryDiv">${boardDto.categoryName.replace('형','')}들의 생존 게시판</span>
               <!-- + 버튼 추가! -->
             <span class="plus-btn"
                   onclick="window.location.href='<%=ctxPath%>/board/list/${boardDto.fk_categoryNo}'">
                  더보기<i class="fa fa-plus"></i>
             </span>
            </div>
            <c:set var="changeCategory" value="${boardDto.categoryName}" />
          </c:if>
      
          <!-- 게시글 카드 -->
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
              <c:if test="${boardDto.imgForBoardList eq null}">
                <div style="width:100px; height:80px;"></div>
              </c:if>
            </div>
      
            <!-- 작성자/날짜/조회수 -->
            <div class="meta">
              <span>${boardDto.fk_id}</span>
              <span>${boardDto.formattedDate}</span>
              <span class="fa-regular fa-eye" style="font-size: 8pt">&nbsp;${boardDto.readCount}</span>
              <!-- 북마크 -->
              <form id="bookmarkForm-${boardDto.boardNo}">
                <input type="hidden" name="fk_boardNo" value="${boardDto.boardNo}">
                <input type="hidden" name="fk_id" value="${sessionScope.loginUser.id}">
                <i id="bookmark-icon-${boardDto.boardNo}"
                   class="fa-bookmark ${boardDto.bookmarked ? 'fa-solid text-warning' : 'fa-regular'}"
                   style="cursor: pointer;"
                   onclick="bookmark(${boardDto.boardNo}, '${sessionScope.loginUser.id}', ${boardDto.bookmarked ? true : false})">
                </i>
              </form>
            </div>
          </div>
             <form id="viewForm-${boardDto.boardNo}">
            <input type="hidden" name="boardNo"/>
            <input type="hidden" name="fk_id" /> 
            <input type="hidden" name="searchType" />
            <input type="hidden" name="searchWord" />
            <input type="hidden" name="category" value="${boardDto.fk_categoryNo}" />
          </form>
        </c:forEach>
      </div>
   </c:if>

    <c:if test="${empty requestScope.boardList}">
      <tr>
        <td colspan="6">첫 번째 게시물을 올려보세요!</td> 
      </tr>
    </c:if>
   </div>
   
</div>
</div>

<jsp:include page="../footer/footer1.jsp"></jsp:include>   