
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<%
    String ctxPath = request.getContextPath();
%>    
    
<!DOCTYPE html>
<html>

<head>
   <%-- Required meta tags --%>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <title>대사살 (대충사무실에서살아남기)</title>

    <%-- Bootstrap CSS --%>
    <link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">

    <%-- Font Awesome 6 Icons --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  
    <%-- 직접 만든 CSS 1 --%>
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/style1.css" />
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/common.css" />
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/footer1.css" />
    
    <%-- Optional JavaScript --%>
    <script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

   <%-- 스피너 및 datepicker 를 사용하기 위해 jQueryUI CSS 및 JS --%>
   
<style type="text/css">

/* 프로필 카테고리 이미지 */
.category-img {
    width: 100%;
    max-width: 20rem;   /* 약 320px */
    height: auto;
    border-radius: 10px;
    object-fit: cover;
    display: block;
    margin: 5% 0 0 0;      /* 가운데 정렬 */
    margin-top: 25%;
    max-width:330px;
    margin: 0 auto 1rem auto; /* 중앙정렬 + 하단 여백 */
}

/* 랭킹 보드 */
.LBoardRank {
    width: 100%;
    max-width: 20rem;   /* category-img와 동일 */
    box-sizing: border-box;
    border: 2px solid #ddd;
    border-radius: 15px;
    padding: 0.75rem;
    background: #FFFCFF; /* 완전 white 아님 */
    transition: all 0.3s ease-in-out;
    font-weight: bold;
    color: #6E6B6B;
    margin: 1rem auto;  /* 반응형 간격 */
}

/* 타이틀 */
.hotTitle {
    font-size: 1rem;   /* 반응형 단위 */
}

/* 모바일 화면 대응 */
@media (max-width: 768px) {
    .category-img,
    .LBoardRank {
        max-width: 15rem; /* 240px 정도 */
    }

    .hotTitle {
        font-size: 0.9rem;
    }

    .LBoardRank {
        padding: 0.5rem;
    }
}

/* 아주 작은 화면 (예: 400px 이하) */
@media (max-width: 400px) {
    .category-img,
    .LBoardRank {
        max-width: 100%;  /* 화면 가득 */
    }

    .hotTitle {
        font-size: 0.85rem;
    }

    table tbody {
        font-size: 0.75rem; /* 가독성 위해 글씨 더 작게 */
    }
}

</style>
</head>

   <div id="mycontainer"  style="background-image: url('<%= ctxPath %>/images/background.png');">
      <div id="myheader">
         <jsp:include page="../menu/menu1.jsp" />
      </div>
      
      <div id="mycontent" class="mt-5">
         <div class="row" style="margin:0 auto;"> 
            <div class="col-md-3 d-flex flex-column align-items-center justify-content-start" id="leftSess">
            <c:if test="${not empty sessionScope.loginUser}">   
               <div style="text-align: center;">
               <c:if test="${sessionScope.loginUser.getCategory().getCategoryImagePath() eq null}">
                     <img src="<%=ctxPath%>/images/unassigned.png" alt="프로필"  class="category-img mb-3">
               </c:if>
                  <c:if test="${sessionScope.loginUser.getCategory().getCategoryImagePath() ne null}">
                     <img src="<%=ctxPath%>/images/${sessionScope.loginUser.getCategory().getCategoryImagePath()}" alt="프로필" 
                         class="category-img mb-3">
                  </c:if>
                   <div class="text-muted small mb-3">${sessionScope.loginUser.email}</div>
                   <div class="mb-3">
                      <div style="size:20pt; color:blue; font-weight: bold;">${sessionScope.loginUser.name} 님 </div>
                      <div>포인트 : <b style="color: #5CFF5C; font-weight: bold;">
                                  <fmt:formatNumber value="${sessionScope.loginUser.point}" pattern="#,###"/> 
                                  point</b></div>
                   </div>
               </div>
            </c:if>   
              <div class="LBoardRank">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 class="hotTitle" style="font-weight: bolder; margin: 0;">대사살 <span style="color: red;">Hot!</span> 게시글</h6>
                </div>
                <table class="table table-sm table-borderless">
                    <tbody style="font-size: 10pt;">
                        <c:forEach var="hotRead" items="${hotReadList}">
                            <form id="viewForm${hotRead.boardNo}" 
                                 action="<%= ctxPath %>/board/view" 
                                 method="get" 
                                 style="display:none;">
                         <input type="hidden" name="category" value="${hotRead.fk_categoryNo}">
                         <input type="hidden" name="boardNo" value="${hotRead.boardNo}">
                     </form>
                     <tr>
                         <td style="width: 5%; font-weight: bold;">
                             ${hotRead.rank}.
                         </td>
                         <td style="width: 95%;">
                             <a href="javascript:void(0);" 
                                onclick="document.getElementById('viewForm${hotRead.boardNo}').submit();" 
                                style="color: #000;">
                                 ${hotRead.boardName}
                             </a>
                             <span class="fa-regular fa-eye text-muted" style="font-size: 8pt; color:black !important">
                                 (${hotRead.readCount})
                             </span>
                         </td>
                     </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="LBoardRank">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 class="hotTitle" style="font-weight: bolder; margin: 0;"> 대사살 <span style="color:blue;">시끌벅적!</span> 게시글</h6>
                </div>
                <table class="table table-sm table-borderless">
                    <tbody style="font-size: 10pt;">
                        <c:forEach var="hotComment" items="${hotCommentList}">
                           <form id="viewForm${hotComment.boardNo}" 
                                 action="<%= ctxPath %>/board/view" 
                                 method="get" 
                                 style="display:none;">
                         <input type="hidden" name="category" value="${hotComment.fk_categoryNo}">
                         <input type="hidden" name="boardNo" value="${hotComment.boardNo}">
                     </form>
                     
                     <tr>
                         <td style="width: 5%; font-weight: bold;">
                             ${hotComment.rank}.
                         </td>
                         <td style="width: 95%;">
                             <a href="javascript:void(0);" 
                                onclick="document.getElementById('viewForm${hotComment.boardNo}').submit();" 
                                style="color: #000;">
                                 ${hotComment.boardName}
                             </a>
                             <span class="fa-regular fa-comment text-muted" style="font-size: 8pt; color:black !important">
                                 (${hotComment.commentCount})
                             </span>
                         </td>
                     </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            </div>
         
         