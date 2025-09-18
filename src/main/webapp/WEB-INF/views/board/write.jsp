<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<%
    String ctxPath = request.getContextPath();
    //    /justsurviveoffice
%>   

<!DOCTYPE html>
<html>
<head>

 <%-- Bootstrap CSS --%>
 <link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">

 <%-- Optional JavaScript --%>
 <script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
 <script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

<%-- 스피너 및 datepicker 를 사용하기 위해 jQueryUI CSS 및 JS --%>
 <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
 <script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>
   
<script type="text/javascript" src="<%=ctxPath%>/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<script type="text/javascript">
   $(function(){
		// === 스마트 에디터 구현 시작 ===
	   var oEditors = [];

	   nhn.husky.EZCreator.createInIFrame({
	       oAppRef: oEditors,
	       elPlaceHolder: "boardContent",  // textarea id와 동일하게
	       sSkinURI: "<%=ctxPath%>/smarteditor/SmartEditor2Skin.html",
	       htParams : {
	           bUseToolbar : true,
	           bUseVerticalResizer : true,
	           bUseModeChanger : true
	       }
	   });
	   // === 스마트 에디터 구현 끝 ===
	   
	    // 글쓰기 버튼
	    $('button#btnWrite').click(function(){
	        // === 글제목 유효성 검사 === //
	        const boardName = $('input[name="boardName"]').val().trim();
	        if(boardName == "") {
	        	alert("제목을 입력하세요!!");
	        	$('input[name="boardName"]').val("");
	        	return; // 종료
	        }
	        if(boardName.length > 30) {
	        	alert("제목은 30자를 초과할 수 없습니다.");
	        	return; // 종료
	        }
	        
		    // 스마트에디터의 내용을 textarea로 업데이트
	        oEditors.getById["boardContent"].exec("UPDATE_CONTENTS_FIELD", []);
			
	        // === 글내용 유효성 검사 === //
	        // 스마트에디터는 <p>&nbsp;/</p> 태그가 기본으로 있기에 유효성 검사에 유의!
	        let contentVal = $('textarea[name="boardContent"]').val()
										   .replace(/(&nbsp;|<p>|<\/p>|\r?\n|\r)/gi, "")
										   .trim(); // 기본태그, 띄어쓰기, 엔터 정규식 처리! 
	        if(contentVal != "") {
	        	contentVal = $('textarea[name="boardContent"]').val().trim();
	        	// alert(">>"+ contentVal+ "<<");
	        }
	        if(contentVal.length == 0) {
	        	alert("글내용을 입력해주세요");
	        	return; // 종료
	        }
	        
	        // 폼(form)을 전송(submit)
	        const form = document.writeForm;
	        form.method = "post";
	        form.action = "<%= ctxPath%>/board/write";
	        form.submit();
	    });


   });// end of $(function(){})-----------------
   
   function previewImage(event) {
       const file = event.target.files[0];
       const preview = document.getElementById('preview');

       if (file) {
           const reader = new FileReader();
           reader.onload = function(e) {
               preview.src = e.target.result;
               preview.style.display = "block";
           }
           reader.readAsDataURL(file);
       } else {
           preview.style.display = "none";
           preview.src = "";
       }
   }
  
</script>
 <style type="text/css">
.post-card { 
  min-width: 750px;  
  margin: 50px auto;  
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  padding: 20px;
}

.post-header {
  display: flex;
  align-items: center;
  margin-bottom: 16px;
  font-weight: bold;
  font-size: 25px;
}

.post-body textarea {
  width: 100%;
  border: none;
  resize: none;
  min-height: 300px;
  outline: none;
}

.post-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
}

.post-footer button {
  background: #5f5fff;
  border: none;
  color: white;
  border-radius: 8px;
  padding: 8px 16px;
  cursor: pointer;
}
.post-footer button.cancel {
  background: #ccc;
  margin-right: 8px;
}
.container {
    padding-left: 20px;
    padding-right: 20px;
}
.boardContent {
    min-width: 1200px;
    margin: 0 auto;  /* 가운데 정렬 */
}
.grid-layout {
    display: grid;
    grid-template-columns: 1fr 3fr 1fr;
    gap: 20px;
}
.preview {
            margin-top: 10px;
            max-width: 300px;
            max-height: 300px;
            border: 1px solid #ccc;
            border-radius: 10px;
            object-fit: contain;
       }
.file-upload {
    display: none; /* 진짜 input은 숨김 */
  }
.file-label {
  display: inline-block;
  padding: 5pt; 
  border-radius: 10px; /* 라운드 */
  background-color: #FFEDFB; /* 배경색 */
  color: #333;
  cursor: pointer;
  transition: 0.3s;
}
.file-label:hover {
  background-color: #f0dff0; /* hover 시 약간 진하게 */
}
 </style>
</head>
<div style="display: flex; background-image: url('<%= ctxPath %>/images/background.png');">
   <div style="margin: auto; padding-left: 3%;">
      
      <%-- !!! 파일을 첨부하기 위해서는 먼저 form 태그의 enctype 을 enctype="multipart/form-data" 으로 해주어야 한다. 
               또한 파일을 첨부하기 위해서는 전송방식은 post 이어야 한다. !!! --%>
      <form name="writeForm" enctype="multipart/form-data">
        <div class="post-card">
  
		  <div class="post-header">
		    <div class="">새 게시글</div>
		    <input class="fk_id" style="display: none"
		    	 name="fk_id" value="${sessionScope.loginUser.id}"/>
   		    <input class="fk_categoryNo" style="display: none"
		    	 name="fk_categoryNo" value="${requestScope.category}"/>
		  </div>
		  <!-- 업로드한 이미지 미리보기 --> 
		  <img id="preview" class="preview" style="display:none;"> 
		  <!-- 파일 업로드 -->
		  <input type="file" name="attach" id="fileUpload" class="file-upload" 
		       accept="image/*" onchange="previewImage(event)" />
	       <!-- 라벨을 버튼처럼 --><br>
		  <label for="fileUpload" class="file-label">첨부 파일</label>
		  <br><br>
  		  
		  <!-- 제목 -->
		  <input type="text" name="boardName" placeholder="제목을 입력하세요" 
     			  class="form-control mb-2" maxlength="100">	  
		  <!-- 내용 (스마트에디터 들어가는 textarea) -->
		  <div class="post-body">
		    <textarea name="boardContent" id="boardContent" 
		    		  placeholder="   무슨 생각을 하고 계신가요?"></textarea>
		  </div>
		  
		  <!-- 버튼 -->
		  <div class="post-footer">
		    <button type="button" class="cancel" onclick="history.back()">취소</button>
		    <button type="button" id="btnWrite">게시하기</button>
		  </div>
		</div>
      </form>
   
   </div>
</div>







    