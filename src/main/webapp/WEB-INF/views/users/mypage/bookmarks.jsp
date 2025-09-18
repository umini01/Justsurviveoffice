<%@ page contentType="text/html; charset=UTF-8" 
   pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    

<%
   String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지 - 내 북마크</title>

<link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<style type="text/css">
   body { background: #f7f7fb; font-family: 'Noto Sans KR', sans-serif; }
   .sidebar { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 8px 24px rgba(0,0,0,.06); }
   .sidebar img { max-width: 100%; border-radius: 10px; }
   .sidebar-menu a { display: block; padding: 8px 0; color: #333; text-decoration: none;font-weight:500;}
   .sidebar-menu a:hover { color: #6c63ff; } 
   .content { background: #fff; border-radius: 12px; padding: 24px; box-shadow: 0 8px 24px rgba(0,0,0,.06); }
   /* 북마크 테이블 */
   .table thead { background-color: #f1f3f6; border-radius: 8px; }
   .table th { text-align: center; font-weight: 600; color: #444; }
   .table td { text-align: center; vertical-align: middle; background-color: #fff; box-shadow: 0 2px 6px rgba(0, 0, 0, .05); border-radius: 6px; }
   /* 링크 스타일 */
   .table td a { display: inline-block; max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; color: #333; font-weight: 500; }
   .table td a:hover { color: #6c63ff; text-decoration: underline; }
   /* 삭제 버튼 */
   .btnDelete { background-color: #ff6b6b; border: none; color: white; padding: 4px 12px; border-radius: 6px; font-size: 13px; transition: all 0.2s ease-in-out; }
   .btnDelete:hover { background-color: #ff4b4b; transform: scale(1.05); }
   
   /* =======================  */
   /* 스크롤은 래퍼 div에만 적용 */
   .table-scroll {
     max-height: 60vh;          /* 화면 높이의 60% (원하면 조절) */
     overflow: auto;            /* 세로/가로 자동 */
     border: 1px solid #e9ecef;
     border-radius: 8px;
   
     /* 스크롤바 공간을 미리 확보해서 헤더/본문 폭 어긋남 방지 (지원 브라우저에서) */
     /*scrollbar-gutter: stable both-edges;*/
   }
   
   /* 테이블 아래 여백 제거(스크롤 영역 계산 깔끔) */
   .table-scroll .table {
      width: 100%;
      table-layout: fixed;          /* 열 너비 고정 */
      margin-bottom: 0;             /* 계산 깔끔하게 */
   }
   
   /* 헤더 고정 */
   .table-scroll thead th,
   .table-scroll .table td {
     white-space: nowrap;          /* 한 줄로 */
     overflow: hidden;             /* 넘치면 숨김 */
     text-overflow: ellipsis;      /* … 처리 */
     box-sizing: border-box;
   }
   
</style>

<script type="text/javascript">

   $(function () {
   
      let start = 0;         // 데이터 로딩 시작 위치
       let len = 10;           // 첫 로딩은 10개
       let isLoading = false;   // 중복 호출 방지를 위한 로딩 여부 
       let endOfData = false;   // 데이터 끝에 도달했는지 여부

       // 날짜 포맷 함수
       function formatDate(dateTimeStr) {
           if (!dateTimeStr) return '-';
           return dateTimeStr.split("T")[0];
       }

       // 번호 다시 매기기 함수
       function renumberRows() {
           $("#bookmarkList tr").each(function(index) {
               $(this).find("td:first").text(index + 1);
           });
       }

       // ✅데이터 불러오기
       function loadMore() {
          // 이미 로딩 중이거나 데이터가 끝난 경우 실행 X
           if (isLoading || endOfData) return;
           isLoading = true;
           $(".loading").show();

           $.ajax({
               url: "<%=ctxPath%>/bookmark/bookmarksMore",
               type: "GET",
               data: {
                  id: "${sessionScope.loginUser.id}",
                   start: start,
                   len: len
               },
               success: function(data) {
                  // 데이터가 존재하는 경우
                   if (data.length > 0) { 
                       // 현재 테이블에 있는 행 개수 + 1부터 시작
                       let rowNumber = $("#bookmarkList tr").length + 1;
                       
                       data.forEach(function(bookmark) {
                           $("#bookmarkList").append(
                               "<tr>"
                             + "<td>" + (rowNumber++) + "</td>"
                             + "<td>"
                             +   "<a href='<%=ctxPath%>/board/view?boardNo=" + bookmark.fk_boardNo 
                             +   "&category=" + bookmark.fk_categoryNo + "' style='color:#000;'>"
                             +   (bookmark.boardName || '-') 
                             +   "</a>"
                             + "</td>"
                             + "<td>" + (bookmark.createdAtMark ? formatDate(bookmark.createdAtMark) : '-') + "</td>"
                             + "<td>"
                             +   "<button type='button' class='btn btn-sm btnDelete' data-fk_boardno='" + bookmark.fk_boardNo + "'>삭제</button>"
                             + "</td>"
                             + "</tr>"
                           );
                       });
                       
                       start += len;   // 시작 위치 갱신
                       len = 5;       // 이후부터는 5개씩
                       
                   } else {
                      // 데이터가 더 이상 없는 경우 메시지 출력
                       $("#bookmarkList").append(
                           "<tr><td colspan='4' class='text-center text-muted'>더 이상 북마크가 없습니다. "
                         + "<button type='button' class='btn btn-sm btn-outline-secondary ml-2 btn-scroll-top'>"
                         + "맨 위로</button></td></tr>"
                       );
                       endOfData = true; // 데이터 끝 설정
                   }
                   $(".loading").hide();
                   isLoading = false;
               },
               error: function(request, status, error) {
                   $(".loading").hide();
                   isLoading = false;
                   alert("code:" + request.status + "\nmessage:" + request.responseText + "\nerror:" + error);
               }
           });
       }

       // 첫 로딩
       loadMore();

       // ✅ 회원탈퇴
       $("#btnQuit").on("click", function (e) {
           e.preventDefault();
           if (!confirm("정말로 탈퇴하시겠습니까?")) return;
   
           $.ajax({
             url: "<%= ctxPath %>/mypage/quit",
             type: "post",
             data: { id: "${sessionScope.loginUser.id}" },
             dataType: "json",
             success: function (json) {
               if (json.n == 1) {
                 alert("탈퇴되었습니다.");
                 location.href = "<%= ctxPath %>/index";
               } else {
                 alert("탈퇴 실패");
               }
             },
             error: function (request, status, error) {
               alert("code: " + request.status + "\nmessage: " + request.responseText + "\nerror: " + error);
             }
           });
       });

       // 북마크 삭제
       $(document).on("click", ".btnDelete", function(e) {
          e.preventDefault();
   
          const fk_boardNo = $(this).data("fk_boardno"); 
          if (!fk_boardNo) {
              alert("게시글 번호를 가져올 수 없습니다.");
              return;
          }
          if (!confirm("해당 북마크를 삭제하시겠습니까?")) return;
   
          const $row = $(this).closest("tr");
   
          $.ajax({
              url: "<%=ctxPath%>/bookmark/remove",
              type: "post",
              data: { fk_boardNo: fk_boardNo },
              dataType: "json",
              success: function(json) {
                  if (json.success) {
                      alert("북마크가 삭제되었습니다.");
                      $row.remove();
                      renumberRows();  // 삭제 후 번호 재정렬
                  } else {
                      alert("삭제 실패: " + json.message);
                  }
              },
              error: function(request, status, error) {
                  alert("code: " + request.status + "\nmessage: " + request.responseText);
              }
          });
      });
   
       
       // 테이블 스크롤시 데이터 나옴
       $('#tableScroll').on('scroll', function() {
         const elmt = this;
         if (elmt.scrollTop + elmt.clientHeight >= elmt.scrollHeight - 50) {
            loadMore();
         }
      });
       
       // 스크롤 마지막까지 내려오면 버튼 생김
       $('#bookmarkList').on('click', '.btn-scroll-top', function (e) {
         e.preventDefault();
         $('#tableScroll').animate({ scrollTop: 0 }, 300);
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
                <ul class="nav nav-tabs mb-3">
                    <li class="nav-item"><a class="nav-link" href="<%= ctxPath%>/mypage/info">내 정보</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%= ctxPath%>/mypage/forms">내가 쓴 글</a></li>
                    <li class="nav-item"><a class="nav-link active" href="<%= ctxPath%>/mypage/bookmarks">내 북마크</a></li>
                   <li class="nav-item"><a class="nav-link" href="<%= ctxPath%>/mypage/chart">통계</a></li>
                </ul>

                <h5>내 북마크 목록</h5>
                <hr>
            
            <div id="tableScroll" class="table-scroll">   <!-- 추가 -->
                   <table class="table table-hover">
                       <thead class="thead" style="background-color: #EEF1FF">
                      <tr>
                          <th style="width: 10%; text-align:center;">번호</th>
                          <th style="width: 50%; text-align:center;">제목</th>
                          <th style="width: 25%; text-align:center;">추가일</th>
                          <th style="width: 15%; text-align:center;"></th>
                      </tr>
                  </thead>
                       <tbody id="bookmarkList">
                      <!-- Ajax로 채워짐 -->
                  </tbody>
                   </table>
                   <div class="loading text-center my-3" style="display:none;">불러오는 중...</div>
                </div>
                
                
            </div>
        </div>
    </div>
</div>

<!-- 숨은 폼: 로그아웃  -->
<form id="logoutForm" action="<%=ctxPath%>/logout" method="post" style="display:none;"></form>

</body>
</html>
