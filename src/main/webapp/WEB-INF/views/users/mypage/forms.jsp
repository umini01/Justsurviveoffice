<%@ page contentType="text/html; charset=UTF-8" 
   pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
   String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지 - 내가 쓴 게시글</title>

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
   .table th, .table td { vertical-align: middle; }
   a { color: black; }
   .loading { text-align:center; margin:20px 0; display:none; }
   
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

   $(function(){
   
       // 회원탈퇴
       $("#btnQuit").on("click", function(e) {
           e.preventDefault();
           if(confirm("정말로 탈퇴하시겠습니까?")) {
               $.ajax({
                   url:"<%= ctxPath%>/mypage/quit",
                   type:"post",
                   data:{id:"${sessionScope.loginUser.id}"},
                   dataType:"json",
                   success:function(json){
                       if(json.n == 1) {
                           alert("탈퇴되었습니다.");
                           location.href="<%= ctxPath%>/index";
                       } else {
                           alert("탈퇴 실패");
                       }
                   },
                   error: function(request, status, error){
                       alert("code: "+request.status+"\nmessage: "+request.responseText+"\nerror: "+error);
                   }
               });
           }
       });
   
       // 스크롤 페이징 변수
       let start = 0;         // 데이터 로딩 시작 위치
       let len = 12;           // 첫 로딩은 12개
       let isLoading = false;   // 중복 호출 방지를 위한 로딩 여부 
       let endOfData = false;  // 데이터 끝에 도달했는지 여부
   
       // 날짜 포맷
       function formatDate(dateTimeStr) {
           if (!dateTimeStr) return '-';
           return dateTimeStr.split("T")[0]; // yyyy-MM-dd
       }
   
       // 데이터 불러오기
       function loadMore() {
          // 이미 로딩 중이거나 데이터가 끝난 경우 실행 X
           if (isLoading || endOfData) return;
           isLoading = true;
           $(".loading").show();
   
           $.ajax({
               url: "<%=ctxPath%>/mypage/myBoardsMore",
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
                       let rowNumber = start + 1;
                       data.forEach(function(board) {
                           $("#boardList").append(
                               "<tr>"
                             + "<td>" + (rowNumber++) + "</td>"
                             + "<td><a href='<%=ctxPath%>/board/view?boardNo=" + board.boardNo + "'>"
                             + (board.boardName || '-') + "</a></td>"
                             + "<td>" + (board.createdAtBoard ? formatDate(board.createdAtBoard) : '-') + "</td>"
                             + "<td>" + (board.readCount || 0) + "</td>"
                             + "<td>"
                             + (board.boardDeleted == 1
                                   ? "<button type='button' class='btn btn-sm btn-outline-danger' data-fk_boardno='" + board.boardNo + "'>복구하기</button>"
                                   : "")
                             + "</td>"
                             + "</tr>"
                           );
                       });
                       
                       start += len;   // 시작 위치 갱신
                       len = 5;       // 이후부터는 5개씩
                       
                   } else {
                      // 데이터가 더 이상 없는 경우 메시지 출력
                       $("#boardList").append(
                           "<tr><td colspan='5' class='text-center text-muted'>더 이상 글이 없습니다. "
                           + "<button type='button' class='btn btn-sm btn-outline-secondary ml-2 btn-scroll-top'>"
                           + "맨 위로</button></td></tr>"
                       );
                       endOfData = true;   // 데이터 끝 설정
                   }
                   $(".loading").hide();
                   isLoading = false;
               },
               error: function() {
                   $(".loading").hide();
                   isLoading = false;
                   alert("데이터 로딩 실패");
               }
           });
       }
       
       // 테이블 스크롤시 데이터 나옴
       $('#tableScroll').on('scroll', function() {
         const elmt = this;
         if (elmt.scrollTop + elmt.clientHeight >= elmt.scrollHeight - 50) {
            loadMore();
         }
      });
       
       // 스크롤 마지막까지 내려오면 버튼 생김
       $('#boardList').on('click', '.btn-scroll-top', function (e) {
         e.preventDefault();
         $('#tableScroll').animate({ scrollTop: 0 }, 300);
      });
       
       // 첫 화면 로딩 시 데이터 불러오기
       loadMore();
      
       
       $('#boardList').on('click', "button[data-fk_boardno]", function(){
          const boardNo = $(this).data('fk_boardno');
          if (!boardNo) return;
          
          if (!confirm('복구 시 첨부파일은 사라진 상태로 복구됩니다.\n이 게시글을 복구하시겠습니까?')) return;
          
          $.ajax({
             url:"<%=ctxPath%>/mypage/myBoardRecovery",
             type: "GET",
             data:{"boardNo":boardNo},
             success:function(data){
                if(data.length = 1) {
                   alert("복구 완료");
                   location.reload();
                }
                else {
                   alert("복구 실패");
                }
             },
             error: function() {
                   $(".loading").hide();
                   isLoading = false;
                   alert("데이터 로딩 실패");
               }
          });
          
       })
       
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
                       <li class="nav-item"><a class="nav-link active" href="<%= ctxPath%>/mypage/forms">내가 쓴 글</a></li>
                       <li class="nav-item"><a class="nav-link" href="<%= ctxPath%>/mypage/bookmarks">내 북마크</a></li>
                       <li class="nav-item"><a class="nav-link" href="<%= ctxPath%>/mypage/chart">통계</a></li>
                   </ul>
   
                   <h5>내가 쓴 글 목록</h5>
                   <hr>
                   
               <div id="tableScroll" class="table-scroll">   <!-- 추가 -->
                      <table class="table table-hover">
                          <thead class="thead" style="background-color: #EEF1FF">
                              <tr>
                                  <th>번호</th>
                                  <th>제목</th>
                                  <th>작성일</th>
                                  <th>조회수</th>
                                  <th>비고</th>
                              </tr>
                          </thead>
                          <tbody id="boardList">
                              <!-- AJAX로 데이터 추가 -->
                          </tbody>
                      </table>
                      <div class="loading">불러오는 중...</div>
                   </div>
                   
               </div>
           </div>
       </div>
   </div>
</body>
</html>
 