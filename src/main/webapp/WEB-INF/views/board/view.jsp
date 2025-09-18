<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String ctxPath = request.getContextPath();
%>
<jsp:include page="../header/header1.jsp" /> 
<html>
<style>

 .board-container {
    width: 80%;
    margin: 20px auto;
    border-bottom: 1px solid #e0e0e0;
    padding-bottom: 20px;
    font-family: 'Noto Sans KR', sans-serif;
}

/* 게시판 헤더 */
.board-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
}
.board-header h2 {
    margin: 0;
    font-size: 22px;
    color: #333;
}

/* 게시글 메타정보 */
.board-meta {
    font-size: 14px;
    color: #777;
    margin-top: 5px;
}

/* 게시글 본문 */
.board-content {
    margin: 20px 0;
    padding: 15px;
    background-color: #fff;
    white-space: pre-wrap;
    word-break: break-word;
    line-height: 1.7;
    border-radius: 8px;
    border: 1px solid #f0f0f0;
}

/* board-content 내부 이미지 크기 자동 조절 너무너무 중요!*/
.board-content img {
    max-width: 100%;  /* div의 너비를 넘지 않음 */
    height: auto;     /* 비율 유지하면서 줄어듦 */
    display: block;   /* inline 속성 해제 (간격 정리용) */
    margin: 10px auto; /* 가운데 정렬 (옵션) */
}

/* 첨부파일 이미지 */
.board-file img {
    max-width: 300px;
    margin-top: 10px;
    border-radius: 6px;
}

/* 좋아요 / 북마크 / 조회수 영역 */
.board-actions {
    margin-top: 10px;
    padding: 8px 0;
    display: flex;
    align-items: center;
    border-top: 1px solid #eee;
}
.board-actions i {
    cursor: pointer;
    font-size: 18px;
    margin-right: 5px;
    transition: color 0.2s ease-in-out, transform 0.1s ease-in-out;
}
.board-actions i:hover {
    transform: scale(1.15);
}

/* 좋아요 색상 */
.fa-thumbs-up {
    color: #3f80ff;
}

/* 싫어요 색상 */
.fa-thumbs-down {
    color: #ff5c5c;
}

/* 북마크 색상 */
.fa-bookmark {
    color: #f1c40f;
}

/* 댓글 섹션 */
.comment-section {
    margin-top: 35px;
    background: #fafafa;
    padding: 15px;
    border-radius: 8px;
    border: 1px solid #f0f0f0;

    /* 스크롤바 추가 */
    max-height: 400px;   /* 원하는 높이 설정 (px, vh 가능) */
    overflow-y: auto;    /* 세로 스크롤 활성화 */
}

/* 댓글 단일 아이템 */
.comment {
    background: #fff;
    border-radius: 8px;
    padding: 12px;
    margin-bottom: 12px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
    transition: box-shadow 0.2s ease-in-out;
    position: relative; /* 버튼을 오른쪽 아래 배치하기 위해 필요 */
}

/* 댓글 버튼 영역 */
.comment .actions {
    display: flex;
    justify-content: flex-end; /* 버튼을 오른쪽 정렬 */
    gap: 8px;
    margin-top: 8px;
}

/* 댓글 작성 폼 */
form[name="commentform"] {
    display: flex;                /* 가로 배치 */
    align-items: center;          /* 세로 중앙 정렬 */
    gap: 10px;                    /* 입력창과 버튼 사이 간격 */
    margin-top: 15px;
}

/* 댓글 입력창 */
form[name="commentform"] textarea {
    flex: 1;                      /* 남은 공간 전부 차지 */
    border-radius: 6px;
    padding: 10px;
    border: 1px solid #ddd;
    resize: none;
    min-height: 45px;
    max-height: 120px;
    font-size: 14px;
}

/* 댓글 등록 버튼 */
form[name="commentform"] #addComment {
    padding: 10px 18px;
    font-size: 14px;
    border: none;
    border-radius: 6px;
    background-color: #6c63ff;
    color: white;
    cursor: pointer;
    transition: background-color 0.2s ease-in-out;
    height: 45px;
}

form[name="commentform"] #addComment:hover {
    background-color: #5848e5;
}

.comment:hover {
    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
}

/* 댓글 메타정보 */
.comment .meta {
    font-size: 12px;
    color: #888;
    margin-bottom: 6px;
}

/* 댓글 내용 */
.comment .content {
    font-size: 15px;
    color: #333;
    line-height: 1.6;
    margin-bottom: 10px;
}

/* 좋아요/싫어요 버튼 */
.comment .like-dislike {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-top: 6px;
}
.comment .like-dislike i {
    cursor: pointer;
    transition: color 0.2s ease-in-out, transform 0.15s ease-in-out;
}
.comment .like-dislike i:hover {
    transform: scale(1.2);
}

/* 댓글 버튼 공통 */
.btn {
    padding: 5px 12px;
    font-size: 13px;
    border: 1px solid #ddd;
    border-radius: 6px;
    background-color: #fff;
    color: #333;
    cursor: pointer;
    transition: all 0.2s ease-in-out;
    margin-right: 5px;
}
.btn:hover {
    background-color: #f2f2f2;
    border-color: #ccc;
}

/* 댓글 작성 textarea */
textarea {
    border-radius: 6px;
    padding: 10px;
    border: 1px solid #ddd;
    width: 100%;
    resize: vertical;
    transition: border-color 0.2s ease-in-out;
}
textarea:focus {
    border-color: #6c63ff;
    outline: none;
}

/* 대댓글 영역 */
.replies {
    margin-top: 10px;
    margin-left: 15px;
    border-left: 2px solid #f0f0f0;
    padding-left: 10px;
}

/* 대댓글 단일 항목 */
.reply {
    background-color: #fefefe;
    border-radius: 6px;
    padding: 8px 10px;
    margin-top: 8px;
    border: 1px solid #f5f5f5;
}
.reply .meta {
    font-size: 12px;
    color: #999;
}
.reply .content {
    font-size: 14px;
    margin-top: 4px;
}

/* ===== 대댓글 입력 폼 ===== */
.reply-form {
    display: flex;
    flex-direction: column;  /* 세로 정렬 */
    align-items: flex-end;   /* 버튼 오른쪽 정렬 */
    margin-top: 10px;
    margin-left: 10px;
    width: 100%;
}

/* 대댓글 입력창 */
.reply-form textarea {
    width: 95%;
    min-height: 90px;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 14px;
    resize: vertical;
    box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
    transition: border-color 0.2s ease-in-out;
    margin-bottom: 8px; /* 버튼과 입력창 사이 간격 */
}

/* 입력창 포커스 효과 */
.reply-form textarea:focus {
    border-color: #6c63ff;
    outline: none;
    box-shadow: 0 0 5px rgba(108, 99, 255, 0.3);
}

/* 버튼 묶음 */
.reply-form .button-group {
    display: flex;
    gap: 8px; /* 버튼 간격 */
    justify-content: flex-start; 
    margin-top:5px;
    width: 100%;
}

/* 공통 버튼 스타일 */
.reply-form button {
    padding: 6px 14px;
    font-size: 13px;
    border-radius: 6px;
    border: 1px solid #ddd;
    background-color: #fff;
    color: #333;
    cursor: pointer;
    transition: all 0.2s ease-in-out;
}

/* 등록 버튼 */
.reply-form .add-reply {
    background-color: #6c63ff;
    color: white;
    border: none;
}
.reply-form .add-reply:hover {
    background-color: #5848e5;
}

/* 취소 버튼 */
.reply-form .cancel-reply {
    background-color: #f8f8f8;
    color: #555;
    border: 1px solid #ccc;
}
.reply-form .cancel-reply:hover {
    background-color: #f0f0f0;
}

.commentlikedislike i,
.replylikedislike i {
    cursor: pointer;
    font-size: 16px;  /* 아이콘 크기 키움 */
    margin-right: 5px;
    transition: transform 0.15s ease, color 0.2s ease;
}

.commentlikedislike i:hover,
.replylikedislike i:hover {
    transform: scale(1.25);
    color: #3f80ff;  /* hover 시 강조 */
}

/* 신고 아이콘 기본 스타일 */
.report-icon {
    width: 15px;            /* 북마크 아이콘 크기와 동일하게 맞춤 */
    height: 18px;
    cursor: pointer;
    display: inline-block;
    transition: transform 0.2s ease-in-out, filter 0.2s ease-in-out;
}

/* 마우스 올렸을 때만 반짝임 + 흔들림 */
.report-icon:hover {
    animation: blink 0.8s infinite alternate, shake 1.2s infinite ease-in-out;
    transform: scale(1.15);    /* 살짝 확대 */
    filter: drop-shadow(0 0 6px red);  /* 반짝이는 효과 */
}

/* 반짝이는 효과 */
@keyframes blink {
    0%   { filter: brightness(1); }
    50%  { filter: brightness(2); }
    100% { filter: brightness(1); }
}

</style>

<script type="text/javascript">
 
   $(function() {
      const nextVals = ${boardDto.nextNo};
      if(nextVals == 0) {
         $('div#nextBtn').hide();
      }
      const preVals = ${boardDto.preNo};
      if(preVals == 0) {
         $('div#prevBtn').hide();
      }
       // 댓글작성
       $('button#addComment').click(function(){
           // === 댓글내용 유효성 검사 === //
           let contentVal = $('textarea[name="content"]').val().trim();
           if(contentVal.length == 0) {
              alert("댓글내용을 입력해주세요.");
              return;
           }
           const form = document.commentform;
           form.method = "post";
           form.action = "<%= ctxPath%>/comment/writeComment";
           form.submit();
       });
       
         //대댓글 입력
       $(document).on("click", ".reply-btn", function() {
            const parentNo = $(this).data("id"); //data-id="${comment.commentNo}"라고 아래에 button 속성 지정해놨음
            console.log("reply-btn 클릭됨, parentNo=", parentNo); 
               const form = $('#reply-form-'+parentNo);
              $(".reply-form").not(form).hide(); 
              form.show().find("textarea").focus(); 
               $(`#reply-content-${parentNo}`).focus();
       });  
        
       // 대댓글 작성
       $(document).on("click", ".add-reply", function() {
           const parentNo = $(this).data("parent"); //data-parent로 "${comment.commentNo}" 지정해놨음
           const content = $('#reply-content-'+parentNo).val().trim();  
           
           console.log("parentNo 뭔데 : "+parentNo);
           if(content.length == 0) {
              alert("댓글내용을 입력해주세요 !");
              return; 
           }
           $.ajax({
               url: "<%= ctxPath%>/comment/writeReply",
               type: "POST",
               dataType:"json",
               data: { 
                  fk_boardNo: "${boardDto.boardNo}",
                   content: content,
                   parentNo: parentNo
            },
               success: function(json) {
                   if (json.success) {
                      // 대댓글 리스트에 새로 추가
                      const reply = json.reply;
                      const html = `
                        <div class="reply" id="reply-${reply.commentNo}">
                            <div class="meta">
                               <span>${reply.fk_id}</span> |
                               <span>${reply.fk_name}</span> |
                               <span>${reply.createdAtComment}</span>
                            </div>
                            <div class="content">${reply.content||''}</div>
                            <button class="btn delete-reply" data-id="${reply.commentNo}">삭제</button>
                        </div>`;
                        location.reload();  //재로드
                       // 입력창 초기화 및 숨김
                       $('#reply-content-'+parentNo).val("");
                       $('#reply-form-'+parentNo).hide();
                   } else {
                       alert(json.message);
                   }
               },
               error: function(request, status, error) {
                   alert("code:" + request.status + "\nmessage:" + request.responseText);
               }
           });
      }); // end of $('button#replybtn').click(function(){});
          
       // 대댓글 작성 취소버튼
       $(document).on("click", ".cancel-reply", function() {
           const parentNo = $(this).data("parent");
          
           $('#reply-content-'+parentNo).val("");
           $('#reply-form-'+parentNo).hide();
           
       });

       // 대댓글 삭제
       $(document).on("click", ".delete-reply", function() {
           if (!confirm("정말 삭제하시겠습니까?")) return;

           const commentNo = $(this).data("id");

           $.ajax({
               url: "<%= ctxPath %>/comment/deleteReply",
               type: "POST",
               dataType:"json",
               data: {commentNo:commentNo,
               },
               success: function(json) {
                   if (json.success) {
                       $('#reply-'+commentNo).remove();
                   } else {
                       alert(json.message);
                   }
               },
               error: function(request, status, error) {
                   alert("code:" + request.status + "\nmessage:" + request.responseText);
               }
           });
       });
       
      
       // 댓글 삭제 
       $(document).on("click", ".delete-comment", function () {
           if (!confirm("정말로 삭제하시겠습니까?")) {
               alert("삭제가 취소되었습니다.");
               return;
           }
           const commentNo = $(this).data("id");
           const fkBoardNo = "${boardDto.boardNo}";
           const fkId = "${sessionScope.loginUser.id}";

           const form = $("<form>", {
               method: "post",
               action: "<%=ctxPath%>/comment/deleteComment"
           });
           form.append($("<input>", { type: "hidden", name: "commentNo", value: commentNo }));
           form.append($("<input>", { type: "hidden", name: "fk_boardNo", value: fkBoardNo }));
           form.append($("<input>", { type: "hidden", name: "fk_id", value: fkId }));

           $(document.body).append(form);
           form.submit();
       });
       

       //댓글 수정
       $(document).on("click", ".update-comment", function () {
           const commentDiv = $(this).closest(".comment");
           const contentDiv = commentDiv.find(".content");
           const textarea = commentDiv.find(".edit-content");

           contentDiv.hide();
           textarea.show().focus();

           commentDiv.find(".update-comment").hide();
           commentDiv.find(".delete-comment").hide();
           commentDiv.find(".save-edit").show();
           commentDiv.find(".cancel-edit").show();
       });

       //  댓글 수정 취소 
       $(document).on("click", ".cancel-edit", function () {
           const commentDiv = $(this).closest(".comment");
           const contentDiv = commentDiv.find(".content");
           const textarea = commentDiv.find(".edit-content");

           // textarea 숨기고 원래 내용 보이기
           textarea.hide();
           contentDiv.show();
           
           commentDiv.find(".update-comment").show();
           commentDiv.find(".delete-comment").show();
           commentDiv.find(".save-edit").hide();
           commentDiv.find(".cancel-edit").hide();
       });

       // 댓글 수정 저장 
       $(document).on("click", ".save-edit", function () {
           const commentDiv = $(this).closest(".comment");
           const commentNo = $(this).data("id");
           const newContent = commentDiv.find(".edit-content").val().trim();

           if (newContent.length === 0) {
               alert("댓글 내용을 입력해주세요!");
               return;
           }
           const form = $("<form>", {
               method: "post",
               action: "<%=ctxPath%>/comment/updateComment"
           });
           form.append($("<input>", { type: "hidden", name: "commentNo", value: commentNo }));
           form.append($("<input>", { type: "hidden", name: "content", value: newContent }));
           form.append($("<input>", { type: "hidden", name: "fk_boardNo", value: "${boardDto.boardNo}" }));
           
           $(document.body).append(form);
           form.submit();
       });
       
       

       $('#download').click(function(){
           const form = document.downloadForm;
           form.method = "post";
           form.action =  "<%= ctxPath%>/board/download";
           form.submit();
       });
       
   }); 
   
   // 글 삭제
   function del() {
      if(!confirm("정말로 삭제하시겠습니까?")) {
         return alert("삭제가 취소되었습니다.");
      }
      const form = document.delnEditForm;
      form.method = "post";
      form.action = "<%=ctxPath%>/board/delete";
      form.submit();
   }
   
   // 글 수정하기 >> restAPI
   function edit() {
      if(!confirm("수정하시겠습니까?")) {
         alert("취소되었습니다.");
         return;
      }
      const form = document.delnEditForm;
      form.method = "get";
      form.action = "<%=ctxPath%>/board/edit";
      form.submit();
   }
   
   // 게시글 좋아요
   function boardLike(boardNo, fk_id) {
       const icon = $('#boardLike-icon-'+boardNo);
       const likeCountSpan = $("#likeCount");
   
       $.ajax({
           url: "<%= ctxPath%>/board/boardlike",
           type: "POST",
           data: { fk_boardNo: boardNo },
           success: function(json) {
               if (!json.success) {
                   alert(json.message);
                   window.location.href = "<%=ctxPath%>/users/loginForm";
                   return;
               }
               // 현재 좋아요 상태 변경
               const isLiked = json.status === "liked";
   
               // 클래스 완전히 초기화 후 상태 적용
               icon.removeClass("fa-solid fa-regular text-warning");
               if (isLiked) {
                   icon.addClass("fa-solid fa-thumbs-up text-warning");
               } else {
                   icon.addClass("fa-regular fa-thumbs-up");
               }
               // data-liked 속성 갱신
               icon.attr("data-liked", isLiked);
               // 좋아요 개수 즉시 갱신
               likeCountSpan.text(json.likeCount);
           },
           error: function(request, status, error) {
               alert("code:" + request.status + "\nmessage:" + request.responseText);
           }
       });
   }
   
   //댓글 좋아요
   function commentLike(commentNo,fk_id) {

      const icon = $('#commentLike-icon-' + commentNo);
       const dislikeIcon = $('#commentDislike-icon-' + commentNo);
       const likeCountSpan = $('#commentLikeCount-' + commentNo);
       const dislikeCountSpan = $('#commentDislikeCount-' + commentNo);
   
       $.ajax({
           url: "<%= ctxPath%>/comment/commentLike",
           type: "POST",
           dataType: "json", 
           data: { commentNo: commentNo },
           success: function(json) {
              
              // 로그인 안 한 경우 처리
             if (json.notLogin) {
                 alert(json.message);
                 window.location.href = "<%=ctxPath%>/users/loginForm";
              }

               // 좋아요 상태 변경
               const iscommentLiked = json.status === "liked";
               icon.removeClass("fa-solid fa-thumbs-up text-warning fa-regular");
               dislikeIcon.removeClass("fa-solid fa-thumbs-down text-warning fa-regular");

               if (iscommentLiked) { //이미 좋아요가 되어있다면 취소
                   icon.addClass("fa-solid fa-thumbs-up text-warning");
               } else {
                   icon.addClass("fa-regular fa-thumbs-up");
               }
   
               // 싫어요는 항상 해제 상태로 갱신
               dislikeIcon.addClass("fa-regular fa-thumbs-down");

               icon.attr("data-liked", iscommentLiked); //좋아요 상태 유지
   
               // 좋아요,싫어요 개수 즉시 갱신
               likeCountSpan.text(json.commentLikeCount);
               dislikeCountSpan.text(json.commentDislikeCount);
              
           },
           error: function(request, status, error) {
               alert("code:" + request.status + "\nmessage:" + request.responseText);
           }
       });
   }
   
   //댓글 싫어요
   function commentDislike(commentNo,fk_id) {
       const icon = $('#commentDislike-icon-' + commentNo);
       const likeIcon = $('#commentLike-icon-' + commentNo);
       const dislikeCountSpan = $('#commentDislikeCount-' + commentNo);
       const likeCountSpan = $('#commentLikeCount-' + commentNo);
   
       $.ajax({
           url: "<%= ctxPath%>/comment/commentDislike",
           type: "POST",
           dataType: "json", 
           data: { commentNo: commentNo },
           success: function(json) {
              if (json.notLogin) { // 로그인이 안되었을시,
                  alert(json.message);
                  window.location.href = "<%=ctxPath%>/users/loginForm";
               }
               //  싫어요 상태 변경
               const iscommentDisliked = json.status === "disliked";
               icon.removeClass("fa-solid fa-thumbs-down text-warning fa-regular");
               likeIcon.removeClass("fa-solid fa-thumbs-up text-warning fa-regular");

               if (iscommentDisliked) {//싫어요가 이미 눌러져있다면
                   icon.addClass("fa-solid fa-thumbs-down text-warning"); 
               } else {
                   icon.addClass("fa-regular fa-thumbs-down"); 
               }
               // 좋아요는 항상 해제 상태로 갱신
               likeIcon.addClass("fa-regular fa-thumbs-up");
               icon.attr("data-liked", iscommentDisliked); //싫어요 유지
               
               // 좋아요,싫어요 개수 갱신
               dislikeCountSpan.text(json.commentDislikeCount);
               likeCountSpan.text(json.commentLikeCount);
           },
           error: function(request, status, error) {
               alert("code:" + request.status + "\nmessage:" + request.responseText);
           }
       });
   }
   
   
   //대댓글 좋아요
   function replyLike(commentNo,fk_id) {
      const icon = $('#replyLike-icon-' + commentNo);
       const dislikeIcon = $('#replyDislike-icon-' + commentNo);
       const likeCountSpan = $('#replyLikeCount-reply-' + commentNo);
       const dislikeCountSpan = $('#replyDislikeCount-reply-' + commentNo);
       $.ajax({
           url: "<%= ctxPath%>/comment/replyLike",
           type: "POST",
           dataType: "json", 
           data: { commentNo: commentNo  },
           success: function(json) {
              // 로그인 안 되어 있으면 바로 이동
               if (json.notLogin) { // 로그인이 안되었을시,
                   alert(json.message);
                   window.location.href = "<%=ctxPath%>/users/loginForm";
                }
              
               //  좋아요 상태 변경
               const isreplyLiked = json.status === "liked";
               icon.removeClass("fa-solid fa-thumbs-up text-warning fa-regular");
               dislikeIcon.removeClass("fa-solid fa-thumbs-down text-warning fa-regular");

               
               if (isreplyLiked) { //이미 좋아요가 눌러져있다면
                   icon.addClass("fa-solid fa-thumbs-up text-warning");
               
               } else {
                   icon.addClass("fa-regular fa-thumbs-up");
               }
   
               // 싫어요는 항상 해제 상태로 갱신
               dislikeIcon.addClass("fa-regular fa-thumbs-down");
               
               icon.attr("data-liked", isreplyLiked); //좋아요 상태 유지
               
               // 좋아요,싫어요 count 갱신
               likeCountSpan.text(json.replyLikeCount);
               dislikeCountSpan.text(json.replyDislikeCount);
           },
           error: function(request, status, error) {
               alert("code:" + request.status + "\nmessage:" + request.responseText);
           }
       });
   }
   
   //대댓글 싫어요
   function replyDislike(commentNo,fk_id) {
       const icon = $('#replyDislike-icon-' + commentNo);
       const likeIcon = $('#replyLike-icon-' + commentNo);
       const likeCountSpan = $('#replyLikeCount-reply-' + commentNo);
       const dislikeCountSpan = $('#replyDislikeCount-reply-' + commentNo);
   
       $.ajax({
           url: "<%= ctxPath%>/comment/replyDislike",
           type: "POST",
           dataType: "json", 
           data: { commentNo: commentNo },
           success: function(json) {
              // 로그인 안 되어 있으면 바로 이동
               if (json.notLogin) { // 로그인이 안되었을시,
                   alert(json.message);
                   window.location.href = "<%=ctxPath%>/users/loginForm";
                }             
               //  싫어요 상태 변경
               const isreplyDisliked = json.status === "disliked";
               icon.removeClass("fa-solid fa-thumbs-down text-warning fa-regular");
               likeIcon.removeClass("fa-solid fa-thumbs-up text-warning fa-regular");


               if (isreplyDisliked) { //이미 싫어요가 눌러져있다면
                   icon.addClass("fa-solid fa-thumbs-down text-warning");
               } else {
                   icon.addClass("fa-regular fa-thumbs-down");
               }

               // 좋아요는 항상 해제 상태로 갱신
               likeIcon.addClass("fa-regular fa-thumbs-up");
               icon.attr("data-liked", isreplyDisliked); //싫어요 유지
               
               // 좋아요,싫어요 count 갱신
               dislikeCountSpan.text(json.replyDislikeCount);
               likeCountSpan.text(json.replyLikeCount);      
           },
           error: function(request, status, error) {
               alert("code:" + request.status + "\nmessage:" + request.responseText);
           }
       });
   }
   
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
               const icon = $('#bookmark-icon-'+boardNo); // 북마크 아이콘 지정
               console.log(json.stringify);
               console.log(json.success);
               console.log(json.notLogin);
               console.log(json.message);
               if (json.success) {
                  icon.removeClass("fa-solid fa-bookmark text-warning fa-regular");
                  if (isBookmarked) {
                      // 해제된 상태로 변경
                      icon.addClass("fa-regular fa-bookmark");
                      icon.attr("onclick", "bookmark(" + boardNo + ", '" + fk_id + "', false)");
                     $('input[name="bookmarked"]').value = false;
                  } else {
                      // 추가된 상태로 변경
                      icon.addClass("fa-solid fa-bookmark text-warning");
                      icon.attr("onclick", "bookmark(" + boardNo + ", '" + fk_id + "', true)");
                     $('input[name="bookmarked"]').value = true;
                  }
               } 
               else if (json.notLogin) { // 로그인이 안되었을시,
                  alert(json.message);
                  window.location.href = "<%=ctxPath%>/users/loginForm";
               }
               else {
                   // json.message == undefined
                   alert("뒤로가기 오류입니다.");
                   window.location.href = "<%=ctxPath%>/index";
               }
           },
           error: function(request, status, error) {
               //alert("뒤로가기 오류!"+"   code:" + request.status + "\nmessage:" + request.responseText);
               alert("뒤로가기 오류입니다.");
               window.location.href = "<%=ctxPath%>/index";
               // 일단 임시로 오류시 main으로 전환시키기
           }
       });
    }// end of function Bookmark(boardNo,fk_id)———————————
   
   function goViewA(){
       const frm = document.goViewFrm;
       frm.boardNo.value = ${boardDto.preNo};
       
       frm.method = "get";
       frm.action = "<%= ctxPath%>/board/view";
       frm.submit();
   }

   function goViewB(){
       const frm = document.goViewFrm;
       frm.boardNo.value = ${boardDto.nextNo};
       
       frm.method = "get";
       frm.action = "<%= ctxPath%>/board/view";
       frm.submit();
   }
   
   
   <!-- 게시글 신고하기-->
   //  신고 모달 열기
   function openReportModal(boardNo) {
      console.log("모달열엇다 boardNo"+boardNo);
       $("#report-boardNo").val(boardNo); // 숨겨진 필드에 boardNo 저장
       $("#reportReason").val("");       // 이전 입력값 초기화
       $("#reportModal").modal("show");  // 모달 열기
   }
   
   // 신고 전송
   $(document).on("click", "#submitReport", function() {
       const boardNo = $("#report-boardNo").val();
       const fk_id = $("#report-userId").val();

       console.log("신고 게시글:", boardNo);
       console.log("신고자 ID:", fk_id);

       // 선택된 체크박스 값 배열로 가져오기
       const selectedReasons = [];
       $("input[name='reportReason']:checked").each(function() {
           selectedReasons.push($(this).val());
       });

       console.log("선택한 신고 사유:", selectedReasons);
       
       $.ajax({
           url: "<%=ctxPath%>/board/reportAdd",
           type: "POST",
           dataType: "json",
           data: {
               fk_boardNo: boardNo,
               fk_id: fk_id,
               reportReason: selectedReasons.join(", ") // 선택된 사유를 문자열로 합침
           },
           success: function(json) {
               if (json.success) {
                   alert("🚨 신고가 접수되었습니다.");
                   $("#reportModal").modal("hide");
               } else {
                   alert(json.message || "신고 접수 중 오류가 발생했습니다.");
               }
           },
           error: function(request, status, error) {
               alert("code:" + request.status + "\nmessage:" + request.responseText);
           }
       });
   });
   
</script>
<div class="col-md-9 ListHeight" style="flex-grow: 1; padding: 20px; background: white; border-radius: 10px; ">
    <div name="categoryDiv" style="font-size: 20px; font-weight: bold; color: gray;">
         <input name="fk_categoryNo" style="display: none;"
                   value="${boardDto.fk_categoryNo}"/>
         <c:if test="${boardDto.fk_categoryNo eq 1}">
            <span>MZ들의&nbsp;</span></c:if>
         <c:if test="${boardDto.fk_categoryNo eq 2}">
            <span>꼰대들의&nbsp;</span></c:if>
         <c:if test="${boardDto.fk_categoryNo eq 3}">
            <span>노예들의&nbsp;</span></c:if>      
         <c:if test="${boardDto.fk_categoryNo eq 4}">
            <span>MyWay들의&nbsp;</span></c:if>
         <c:if test="${boardDto.fk_categoryNo eq 5}">
            <span>금쪽이들의&nbsp;</span></c:if>
         <span>생존 게시판</span>
         <br><br><br>
      </div>
      
       <!-- 글 제목  -->
       <div class="title" style="display: flex; font-size: 30px; font-weight: bold;">
             ${boardDto.boardName} 
       </div><br>
       <!-- 작성자 -->
       <div class="board-meta" style="font-weight: bold;">
           작성자: <span>${boardDto.fk_id}</span></div><br>
        <!-- 날짜 / 조회수 -->
       <div class="board-meta">
           <span>${boardDto.formattedDate}</span> |
           <span>조회수: ${boardDto.readCount}</span>
       </div>
        <!-- 첨부파일 다운 -->
        <c:if test="${boardDto.boardFileOriginName ne null}">
         <div class="d-flex justify-content-end">
           <div class="file-box border rounded d-flex align-items-center" style="font-size: 9pt;">
             <form name="downloadForm">
               <div id="download" class="text-dark" style="cursor:pointer;">${boardDto.boardFileOriginName} 다운로드</div>
                <input type="hidden" name="boardFileName" value="${boardDto.boardFileName}"/>
                <input type="hidden" name="boardFileOriginName" value="${boardDto.boardFileOriginName}"/>
             </form>
           </div>
         </div>
   <%--  <div style="min-height: 20%; max-width: 100%; overflow: hidden;">
           <img src="<%=ctxPath %>/resources/files/${boardDto.boardFileName}" 
                   class="thumbnail" 
                   style="max-width: 100%; height: auto; display: block; margin: 0 auto;" />
        </div> --%>
       </c:if>
       
       
       <!-- 본문 내용 -->
       <div class="board-content" style="white-space: pre-wrap;"
          >${boardDto.boardContent}</div>
   
       <!-- 좋아요 , 공유/신고/북마크 --> 
      <div class="board-actions d-flex justify-content-between align-items-center">
          <!-- 좋아요 -->
          <div class="d-flex">
              
             <!-- 좋아요 아이콘 + 개수 표시 -->
            <form id="boardLikeForm-${boardDto.boardNo}">
                <input type="hidden" name="fk_boardNo" value="${boardDto.boardNo}">
                <input type="hidden" name="fk_id" value="${sessionScope.loginUser.id}">
            
                <i id="boardLike-icon-${boardDto.boardNo}"
                  class="fa-thumbs-up ${boardDto.boardLiked ? 'fa-solid text-warning' : 'fa-regular'}"
                  style="cursor: pointer; font-size: 20px;"
                  data-liked="${boardDto.boardLiked}"
                  onclick="boardLike(${boardDto.boardNo}, '${sessionScope.loginUser.id}')">
               </i>
               <span id="likeCount">${likeCount}</span>
            </form>
          </div>
          
          <!-- 오른쪽 공유/신고/북마크 + 글 삭제 -->
         <div class="d-flex ml-auto" style="align-items:center; gap:12px;">
              <span class="fa-regular fa-eye" style="font-size: 8pt">&nbsp;${boardDto.readCount}</span>
              
             <form id="bookmarkForm-${boardDto.boardNo}">
                <i id="bookmark-icon-${boardDto.boardNo}"
                   class="fa-bookmark ${boardDto.bookmarked ? 'fa-solid text-warning' : 'fa-regular'}"
                   style="cursor: pointer;"
                   onclick="bookmark(${boardDto.boardNo}, '${sessionScope.loginUser.id}', ${boardDto.bookmarked ? true : false})">
                </i>
            </form> 
            
             <!-- 신고하기 아이콘 (본인 글 제외) -->
         <c:if test="${not empty sessionScope.loginUser and sessionScope.loginUser.id ne boardDto.fk_id}">
             <img src="<%=ctxPath%>/images/reporticon.png"
                  alt="신고하기"
                  class="report-icon"
                  title="신고하기"
                  onclick="openReportModal(${boardDto.boardNo})">
         </c:if> 
            
              <form name="delnEditForm" style="display:inline;margin: auto; ">
                 <c:if test="${loginUser.id eq boardDto.fk_id}">
                    <input name="fk_categoryNo" style="display: none;" value="${boardDto.fk_categoryNo}"/>
                    <input type="hidden" name="boardNo" value="${boardDto.boardNo}">
                       <input type="hidden" name="fk_id" value="${boardDto.fk_id}">
                       <input type="hidden" name="bookmarked" value="${boardDto.bookmarked}"/>
                     <button class="btn" onclick="del()" style="background-color: white;"
                       >글 삭제</button>
                     <button class="btn" onclick="edit()" style="background-color: white;"
                       >수정하기</button>
                 </c:if>
               </form>
          </div>
      </div>
      
      <!-- ======== 댓글 목록 ======== -->
      <div class="comment-section">
   
          <h3 style="font-weight: bold;">댓글 <span>${fn:length(commentList)}</span></h3>
          
          <c:choose>
             <%-- 댓글이 없는 경우 --%>
           <c:when test="${empty commentList}">
               <p style="color: gray; text-align: center; padding: 20px;">
                   🚫 댓글이 없습니다.
               </p>
           </c:when>
          
          <c:otherwise>
          <c:forEach var="comment" items="${commentList}">
              <div class="comment" id="comment-${comment.commentNo}">
                  <div class="meta">
                      <span>${comment.fk_id}</span> |
                      <span>${fn:replace(comment.createdAtComment, "T", " ")}</span>
                  </div>
                  <div class="content">${comment.content}</div>
         
               <!-- 댓글 좋아요/싫어요 -->
               <div class="commentlikedislike">
                   <i id="commentLike-icon-${comment.commentNo}" 
                     class="fa-thumbs-up ${comment.commentLiked ? 'fa-solid text-warning' : 'fa-regular'}"
                     data-liked="${comment.commentLiked}"
                     onclick="commentLike(${comment.commentNo})"></i>
                  <span id="commentLikeCount-${comment.commentNo}">
                      ${comment.commentLikeCount}
                  </span>
               
                   <i id="commentDislike-icon-${comment.commentNo}" 
                     class="fa-thumbs-down ${comment.commentDisliked ? 'fa-solid text-warning' : 'fa-regular'}"
                     data-liked="${comment.commentDisliked}"
                     onclick="commentDislike(${comment.commentNo})"></i>
                  <span id="commentDislikeCount-${comment.commentNo}">
                      ${comment.commentDislikeCount}
                  </span>
               </div>
      
      
                  <!-- 버튼 영역 -->
                  <div class="actions">
                      <c:if test="${not empty loginUser}">
                          <button class="btn reply-btn" data-id="${comment.commentNo}">답글</button>
                      </c:if>
                      <c:if test="${loginUser.id == comment.fk_id}">
                          <button type="button" class="btn update-comment" data-id="${comment.commentNo}">수정</button>
                          <button type="button" class="btn delete-comment" data-id="${comment.commentNo}">삭제</button>
                          <button type="button" class="btn btn-sm save-edit" data-id="${comment.commentNo}" style="display:none;">저장</button>
                          <button type="button" class="btn btn-sm cancel-edit" data-id="${comment.commentNo}" style="display:none;">취소</button>
                      </c:if>
                  </div>
      
                  <!-- 수정 textarea -->
                  <textarea class="form-control edit-content" style="display:none;">${comment.content}</textarea>
      
                  <!-- 대댓글 입력폼 + 리스트 -->
                  <div class="reply-form" id="reply-form-${comment.commentNo}" style="display:none; margin-top:5px;">
                      <textarea id="reply-content-${comment.commentNo}" rows="3" placeholder="대댓글을 입력하세요"></textarea>
                      <div class="button-group">
                         <button type="button" class="btn add-reply" data-parent="${comment.commentNo}">등록</button>
                         <button type="button" class="btn cancel-reply" data-parent="${comment.commentNo}">취소</button>
                       </div>
                  </div>
                  <div class="replies meta" id="replies-${comment.commentNo}" style="margin-left:20px; margin-top:10px;">
                      <c:forEach var="reply" items="${comment.replyList}">
                         <div class="reply" id="reply-${reply.commentNo}">
                            <span>${reply.fk_id}</span>&nbsp;|&nbsp; 
                            <span>${fn:replace(reply.createdAtComment, "T", " ")}</span>
                           <div class="content">${reply.content}</div>
                       <!-- 대댓글 좋아요/싫어요 -->
                       <div class="replylikedislike">
                           <i id="replyLike-icon-${reply.commentNo}" 
                             class="fa-thumbs-up ${reply.replyLiked ? 'fa-solid text-warning' : 'fa-regular'}"
                             data-liked="${reply.replyLiked}"
                             onclick="replyLike(${reply.commentNo})"></i>
                          <span id="replyLikeCount-reply-${reply.commentNo}">
                              ${reply.replyLikeCount}
                          </span>
                       
                           <i id="replyDislike-icon-${reply.commentNo}" 
                             class="fa-thumbs-down ${reply.replyDisliked ? 'fa-solid text-warning' : 'fa-regular'}"
                             data-liked="${reply.replyDisliked}"
                             onclick="replyDislike(${reply.commentNo})"></i>
                          <span id="replyDislikeCount-reply-${reply.commentNo}">
                              ${reply.replyDislikeCount}
                          </span>
                       </div>
                             <c:if test="${loginUser.id == reply.fk_id}">
                                <span><button class="btn delete-reply" data-id="${reply.commentNo}" data-parent="${comment.commentNo}">삭제</button>
                                  </span>
                             </c:if>
                         </div>
                              
                      </c:forEach>
                  </div>
              </div>
          </c:forEach>
          </c:otherwise>
          </c:choose>
      </div>
      
      <!-- 댓글 작성 -->
       <form name="commentform" action="${ctxPath}/comment/writeComment" method="post" style="margin-top: 15px;">
           <input type="hidden" name="fk_boardNo" value="${boardDto.boardNo}">
           <input type="hidden" name="fk_id" value="${sessionScope.loginUser.id}">
           <textarea name="content" rows="2" style="width:100%;" placeholder="댓글을 입력하세요"></textarea>
           <button type="button" class="btn" id="addComment">댓글 등록</button>
       </form>
    
          
       <!-- 목록 버튼, 이전글 다음글 -->
       <div style="display:flex; margin-top:3px;"> 
       <div class="mr-3">
           <a href="<%=ctxPath %>/board/list/${boardDto.fk_categoryNo}" class="btn">목록</a>
       </div>
       <div class="Boardpagination mt-1">
         <div id="nextBtn" class="" onclick="goViewB('${boardDto.nextNo}')" style="cursor:pointer;">
            다음글: ${fn:substring(boardDto.nextName, 0, 20)}</div>
         <div id="prevBtn" class="" onclick="goViewA('${boardDto.preNo}')" style="cursor:pointer;">
           이전글: ${fn:substring(boardDto.preName, 0, 20)}</div>
      </div>
      <form name="goViewFrm">
             <input type="hidden" name="boardNo" />
         <input type="hidden" name="boardWritt" />
      </form>
      <input type="hidden" id="preNo" name="preNo"  value="${boardDto.preNo}" />
      <input type="hidden" id="NextNo" name="nextNo" value="${boardDto.nextNo}" />
      </div>
   </div>
</div>
<!-- 게시글 신고 모달 -->
   <div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="reportModalLabel" aria-hidden="true">
       <div class="modal-dialog modal-dialog-centered" role="document">
           <div class="modal-content">
   
               <!-- 모달 헤더 -->
               <div class="modal-header bg-danger text-white">
                   <h5 class="modal-title" id="reportModalLabel">
                       🚨 게시글 신고하기
                   </h5>
                   <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                       <span aria-hidden="true">&times;</span>
                   </button>
               </div>
   
               <!-- 모달 본문 -->
               <div class="modal-body">
                   <form id="reportForm">
                       <input type="hidden" id="report-boardNo" name="fk_boardNo" value="">
                       <input type="hidden" id="report-userId" name="fk_id" value="${sessionScope.loginUser.id}">
   
                       <p class="mb-2"><strong>신고 사유를 선택하세요</strong></p>
   
                       <div class="form-check">
                           <input class="form-check-input" type="checkbox" name="reportReason" value="욕설/비방" id="reason1">
                           <label class="form-check-label" for="reason1">욕설/비방</label>
                       </div>
   
                       <div class="form-check">
                           <input class="form-check-input" type="checkbox" name="reportReason" value="광고/도배" id="reason2">
                           <label class="form-check-label" for="reason2">광고/도배</label>
                       </div>
   
                       <div class="form-check">
                           <input class="form-check-input" type="checkbox" name="reportReason" value="허위정보" id="reason3">
                           <label class="form-check-label" for="reason3">허위정보</label>
                       </div>
   
                       <div class="form-check">
                           <input class="form-check-input" type="checkbox" name="reportReason" value="음란물/불법컨텐츠" id="reason4">
                           <label class="form-check-label" for="reason4">음란물/불법컨텐츠</label>
                       </div>
   
                       <div class="form-check">
                           <input class="form-check-input" type="checkbox" name="reportReason" value="기타" id="reason5">
                           <label class="form-check-label" for="reason5">기타</label>
                       </div>
                   </form>
               </div>
   
               <!-- 모달 하단 버튼 -->
               <div class="modal-footer">
                   <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                   <button type="button" class="btn btn-danger" id="submitReport">신고하기</button>
               </div>
           </div>
       </div>
   </div>
<%-- <jsp:include page="../footer/footer1.jsp"></jsp:include> --%>
   <!-- 게시글 신고 모달 -->
   <div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="reportModalLabel" aria-hidden="true">
       <div class="modal-dialog modal-dialog-centered" role="document">
           <div class="modal-content">
   
               <!-- 모달 헤더 -->
               <div class="modal-header bg-danger text-white">
                   <h5 class="modal-title" id="reportModalLabel">
                       🚨 게시글 신고하기
                   </h5>
                   <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                       <span aria-hidden="true">&times;</span>
                   </button>
               </div>
   
               <!-- 모달 본문 -->
               <div class="modal-body">
                   <form id="reportForm">
                       <input type="hidden" id="report-boardNo" name="fk_boardNo" value="">
                       <input type="hidden" id="report-userId" name="fk_id" value="${sessionScope.loginUser.id}">
   
                       <p class="mb-2"><strong>신고 사유를 선택하세요</strong></p>
   
                       <div class="form-check">
                           <input class="form-check-input" type="checkbox" name="reportReason" value="욕설/비방" id="reason1">
                           <label class="form-check-label" for="reason1">욕설/비방</label>
                       </div>
   
                       <div class="form-check">
                           <input class="form-check-input" type="checkbox" name="reportReason" value="광고/도배" id="reason2">
                           <label class="form-check-label" for="reason2">광고/도배</label>
                       </div>
   
                       <div class="form-check">
                           <input class="form-check-input" type="checkbox" name="reportReason" value="허위정보" id="reason3">
                           <label class="form-check-label" for="reason3">허위정보</label>
                       </div>
   
                       <div class="form-check">
                           <input class="form-check-input" type="checkbox" name="reportReason" value="음란물/불법컨텐츠" id="reason4">
                           <label class="form-check-label" for="reason4">음란물/불법컨텐츠</label>
                       </div>
   
                       <div class="form-check">
                           <input class="form-check-input" type="checkbox" name="reportReason" value="기타" id="reason5">
                           <label class="form-check-label" for="reason5">기타</label>
                       </div>
                   </form>
               </div>
   
               <!-- 모달 하단 버튼 -->
               <div class="modal-footer">
                   <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                   <button type="button" class="btn btn-danger" id="submitReport">신고하기</button>
               </div>
           </div>
       </div>
   </div>
</div>
<jsp:include page="../footer/footer1.jsp"></jsp:include>