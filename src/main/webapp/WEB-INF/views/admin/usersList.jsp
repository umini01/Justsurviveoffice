<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script type="text/javascript" src="<%=ctxPath%>/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<style type="text/css">
	
	:root {
	  --bg:#f6f7fb;
	  --card:#ffffff;
	  --text:#222;
	  --muted:#6b7280;
	  --line:#e5e7eb;
	  --brand:#5f5fff;
	  --brand-weak:#EEF1FF;
	  --shadow: 0 10px 25px rgba(0,0,0,.06);
	  --radius-xl: 20px;
	  --radius-lg: 14px;
	  --radius-sm: 10px;
	}
	
	html, body {
	  background: var(--bg);
	  color: var(--text);
	  font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",sans-serif;
	  -webkit-font-smoothing: antialiased;
	}
	
	h2, h3 {
	  font-weight: 700;
	  color: #121826;
	}
	
	/* 검색 박스 */
	#userListBox .search-box {
	  background: var(--card);
	  border: 1px solid var(--line);
	  border-radius: var(--radius-xl);
	  box-shadow: var(--shadow);
	  padding: 18px;
	  margin-bottom: 20px;
	  transition: transform .12s ease, box-shadow .12s ease;
	}
	#userListBox .search-box:hover {
	  transform: translateY(-2px);
	  box-shadow: 0 14px 28px rgba(0,0,0,.08);
	}
	
	/* 검색 입력 & 버튼 */
	.search-input {
	  border-radius: var(--radius-sm);
	  border: 1px solid var(--line);
	}
	
	/* ✅ 검색 버튼 - 통계 페이지 톤 */
	.btn-search {
	  display: inline-flex;
	  align-items: center;
	  gap: 6px;
	  height: 38px;
	  line-height: 38px;
	  padding: 0 18px;
	  font-size: 14px;
	  font-weight: 600;
	  border-radius: 9999px; /* pill 스타일 */
	  background: #;   /* ✅ 통계 페이지와 동일 */
	  border: 1px solid #6C7FF2;
	  color: #fff !important;
	  cursor: pointer;
	  transition: background .2s ease, transform .1s ease;
	}
	.btn-search:hover {
	  background: #5364d8;   /* hover 시 조금 더 진하게 */
	  border-color: #5364d8;
	  transform: translateY(-1px);
	}
	
	/* 테이블 카드 */
	.card-box {
	  background: var(--card);
	  border: 1px solid var(--line);
	  border-radius: var(--radius-xl);
	  box-shadow: var(--shadow);
	  padding: 12px;
	  margin-bottom: 20px;
	  transition: transform .12s ease, box-shadow .12s ease;
	}
	.card-box:hover {
	  transform: translateY(-2px);
	  box-shadow: 0 14px 28px rgba(0,0,0,.08);
	}
	
	#userTbl {
	  border-radius: var(--radius-lg);
	  border: 1px solid var(--line);
	  overflow: hidden;
	}
	#userTbl thead th {
	  background: var(--brand-weak);
	  color: #27314a;
	  font-weight: 600;
	  border-bottom: 1px solid var(--line);
	  text-align: center;
	}
	#userTbl tbody td {
	  vertical-align: middle;
	  border-bottom: 1px solid var(--line);
	}
	#userTbl tbody tr:nth-child(even) {
	  background: #fafafa;
	}
	#userTbl tbody tr:hover {
	  background: #f1f5ff;
	  transition: background .2s ease;
	}
	
	/* 페이지네이션 */
	.pagination .page-item.active .page-link {
	  background-color: #6C7FF2;   /* ✅ 통계 페이지와 동일 */
	  border-color: #6C7FF2;
	  color: #fff;
	}
	
	/* 일반 버튼 */
	.pagination .page-link {
	  color: #6C7FF2;             /* 텍스트/아이콘 파란색 */
	  border-radius: 9999px;      /* pill 모양 */
	  border: 1px solid #e5e7eb;  /* 은은한 라인 */
	  margin: 0 2px;
	  transition: background .2s ease, color .2s ease, transform .1s ease;
	}
	
	/* hover 시 */
	.pagination .page-link:hover {
	  background-color: #EEF1FF;  /* 연한 파란 배경 */
	  color: #6C7FF2;
	  border-color: #6C7FF2;
	  transform: translateY(-1px);
	}
	
</style>

</head>
<jsp:include page="../header/header2.jsp" />	

	<!-- 사용자 검색 및 목록 박스 -->
	<div class="container mt-4 mb-5 p-5" id="userListBox">
		
		<!-- 🔍 검색 영역 -->
		<div class="bg-white rounded-xl shadow-sm p-4 mb-4">
			<form name="user_search_frm" class="form-inline d-flex flex-wrap align-items-center gap-2">
				<select name="searchType" class="form-control mr-2" style="max-width: initial;">
					<option value="name">회원명</option>
					<option value="id">아이디</option>
					<option value="email">이메일</option>
					<option value="categoryName">카테고리명</option>
				</select>
				
				<input type="text" name="searchWord" placeholder="검색어를 입력하세요" class="form-control mr-2 search-input" style="max-width: initial;">
				<input type="text" style="display: none;">
				
				<button type="button" onclick="goSearch()" class="btn mr-auto" style="background-color: #5f5fff; color: white;">
					<i class="fas fa-search mr-1"></i> 검색
				</button>
				
				<%-- 관리자 전용 신고 관리 게시판 추가 --%>
				<button type="button" onclick="location.href='<%= ctxPath%>/admin/reportList'" class="btn mr-auto" style="background-color: #5f5fff; color: white;">
					신고 관리
				</button>
				
				<div class="d-flex align-items-center ml-auto">
					<span class="mr-2 font-weight-bold">페이지당 회원수:</span>
					<select name="sizePerPage" class="form-control">
						<option value="10" <c:if test="${requestScope.sizePerPage == 10}">selected</c:if>>10명</option>
						<option value="5" <c:if test="${requestScope.sizePerPage == 5}">selected</c:if>>5명</option>
						<option value="3" <c:if test="${requestScope.sizePerPage == 3}">selected</c:if>>3명</option>
					</select>
				</div>
			</form>
		</div>
		
		<!-- 👥 사용자 테이블 -->
		<div class="bg-white rounded-xl shadow-sm mb-4">
			<div class="table-responsive">
				<table class="table table-hover table-bordered text-center" id="userTbl">
					<thead class="thead-light">
						<tr>
							<th>번호</th>
							<th>아이디</th>
							<th>이름</th>
							<th>이메일</th>
							<th>카테고리명</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${not empty requestScope.UsersDtoList}">
							<c:forEach var="users" items="${requestScope.UsersDtoList}" varStatus="status">
								<tr class="user-row userInfo">
									<fmt:parseNumber var="currentShowPageNo" value="${requestScope.currentShowPageNo}" />
									<fmt:parseNumber var="sizePerPage" value="${requestScope.sizePerPage}" />
									<td>${(requestScope.totalDataCount) - (currentShowPageNo - 1) * sizePerPage - (status.index)}</td>
									<td class="id">${users.id}</td>
									<td>${users.name}</td>
									<td>${users.email}</td>
									<td>${users.category.categoryName}</td>
								</tr>
							</c:forEach>
						</c:if>
						<c:if test="${empty requestScope.UsersDtoList}">
							<tr>
								<td colspan="5" class="text-center text-muted">데이터가 존재하지 않습니다.</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div>
		</div>
		
		<!-- 페이지네이션 -->
		<div class="bg-white rounded shadow-sm p-3" >
			<div class="d-flex justify-content-center align-items-center flex-wrap">
				<ul class="pagination justify-content-center justify-content-sm-end mb-0">
					${requestScope.pageBar}
				</ul>
			</div>
		</div>
		
	</div>
	
<!-- 숨겨진 form -->
<form name="userDetail_frm">
	<input type="hidden" name="id" />
</form>

<script type="text/javascript">
	
	$(function(){
		
		// 검색시 검색조건 및 검색어 값 유지시키기
		if( "${requestScope.searchType}" !== "" && "${requestScope.searchWord}" !== "" ) {
			$('select[name="searchType"]').val("${requestScope.searchType}");
			$('input[name="searchWord"]').val("${requestScope.searchWord}");
			$('select[name="sizePerPage"]').val("${requestScope.sizePerPage}");
		}
		
		$("input#searchWord").keyup(function(e){
			if(e.keyCode == 13) {
				// 검색어에 엔터를 했을 경우
				goSearch();
			}
		});
		
		
		// === 멤버 클릭시 상세 페이지 이동 === //
		$('table > tbody > tr').on('click', function(){
			
			const id = $(this).find('td.id').text().trim();
		//	alert(id);
			
			const frm = document.userDetail_frm
			frm.id.value = id;
			frm.action = "<%= ctxPath%>/admin/usersDetail";
			frm.submit();
		});
		
	});// end of $(function(){})-----------------------------
	
	
	// Function Declaration
	function goSearch() {
		const frm = document.user_search_frm;
		frm.method = "GET";
		frm.action = "<%= ctxPath%>/admin/usersList";
		frm.submit();
	}// end of function goSearch()--------------------
	
</script>