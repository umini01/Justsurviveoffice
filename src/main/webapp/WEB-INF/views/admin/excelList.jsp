<%@ page language="java" contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"%> 
	
<% String ctxPath = request.getContextPath(); %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<jsp:include page="../header/header2.jsp" /> 

<style>
	:root{
  --bg:#f6f7fb;
  --card:#ffffff;
  --text:#222;
  --muted:#6b7280;
  --line:#e5e7eb;
  --brand:#6C7FF2;
  --brand-weak:#EEF1FF;
  --shadow: 0 10px 25px rgba(0,0,0,.06);
  --radius-xl: 20px;
  --radius-lg: 16px;
  --radius-sm: 10px;
}

html, body {
  background: var(--bg);
  color: var(--text);
  font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",sans-serif;
  -webkit-font-smoothing: antialiased;
}

h2 {
  margin: 28px 0 18px 0 !important;
  font-size: clamp(20px, 2.1vw, 28px);
  font-weight: 800;
  color: #121826;
}

/* flex 컨테이너 */
.search-download-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  margin-top: 20px;
}

/* 검색폼(왼쪽) */
#searchForm,
.action-box { /* ✅ 둘 다 같은 카드 톤 */
  display: flex;
  align-items: center;
  gap: 12px;
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: 9999px;
  box-shadow: var(--shadow);
  padding: 8px 16px;
}

/* select & button 공통 크기 */
#searchForm select,
#btnExcel {
  height: 38px;
  line-height: 38px;
  padding: 0 16px;
  font-size: 14px;
  border-radius: 9999px;
  min-width: 180px;
}

/* select */
#searchForm select {
  border: 1px solid var(--line);
  background-color: #fff;
  cursor: pointer;
}

/* 버튼 */
#btnExcel {
  border: 1px solid var(--brand);
  background: var(--brand);
  color: #fff;
  font-weight: 600;
  cursor: pointer;
  transition: background .2s ease, transform .1s ease;
}
#btnExcel:hover {
  background: #5364d8;
  transform: translateY(-1px);
}

/* ✅ 테이블 카드 */
.table-container {
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow);
  padding: clamp(14px, 2.2vw, 22px);
  margin-top: 20px;
  transition: transform .12s ease, box-shadow .12s ease;
}
.table-container:hover {
  transform: translateY(-2px);
  box-shadow: 0 14px 28px rgba(0,0,0,.08);
}

/* ✅ 테이블 */
.table-container table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  min-width: 560px;
  border: 1px solid var(--line);
  border-radius: var(--radius-lg);
  overflow: hidden;
}
.table-container thead th {
  background: var(--brand-weak);
  color: #27314a;
  font-weight: 700;
  text-align: center;
  padding: 12px 10px;
  border-bottom: 1px solid var(--line);
}
.table-container td, .table-container th {
  padding: 10px 12px;
  border-bottom: 1px solid var(--line);
  text-align: right;
  white-space: nowrap;
}
.table-container td:first-child, 
.table-container th:first-child { text-align: center; }

/* zebra + hover */
.table-container tbody tr:nth-child(even){ background: #fafafa; }
.table-container tbody tr:hover{
  background: #f1f5ff;
  transition: background .2s ease;
}



@media screen and (max-width:1300px){
  h2{ margin: 11% 0 12px 0 !important; }
}

/* 반응형 */
@media(max-width:640px){
  #searchForm{ padding: 6px 10px; }
  .table-container table{ min-width: 480px; }
}
	
</style>

<div class="col-md-10"> 
	<div style="width:100%; min-height:700px; margin:auto;"> 
		<h2>가입자 통계</h2> 
		
		<div class="search-download-wrapper">
		  <!-- 왼쪽: 검색 폼 -->
		  <form id="searchForm" method="get" action="<%= ctxPath%>/admin/userExcelList">
		    <select id="chartSelect" name="chart" onchange="this.form.submit()">
		      <option value="register" ${chart eq 'register' ? 'selected' : ''}>월별 가입자 통계</option>
		      <option value="registerDay" ${chart eq 'registerDay' ? 'selected' : ''}>일자별 가입자 통계</option>
		    </select>
		
		    <c:if test="${chart eq 'registerDay'}">
		      <label for="monthSelect">월: </label>
		      <select id="monthSelect" name="month" onchange="this.form.submit()">
		        <c:forEach var="m" begin="1" end="12">
		          <option value="${m < 10 ? '0' + m : m}" ${m eq month ? 'selected' : ''}>${m}월</option>
		        </c:forEach>
		      </select>
		    </c:if>
		  </form>
		
		  <!-- 오른쪽: 엑셀 다운로드도 흰색 카드로 -->
		  <div class="action-box">
		    <form id="downloadForm" method="post">
		      <input type="hidden" name="chart" value="${chart}" />
		      <input type="hidden" name="month" value="${month}" />
		      <button type="button" id="btnExcel">엑셀 다운로드</button>
		    </form>
		  </div>
		</div>

		<!-- ✅ 데이터 테이블 --> 
		<div class="table-container"> 
			<table id="statTable"> 
				<thead> 
					<tr> 
						<c:choose> 
							<c:when test="${chart eq 'register'}"><th>월</th></c:when> 
							<c:when test="${chart eq 'registerDay'}"><th>일</th></c:when> 
						</c:choose> 
						<th>가입자 수</th> 
						<th>퍼센티지</th> 
					</tr> 
				</thead> 
				<tbody> 
					<c:forEach var="row" items="${list}"> 
						<tr> 
							<c:choose> 
								<c:when test="${chart eq 'register'}"><td>${row.mm}</td></c:when> 
								<c:when test="${chart eq 'registerDay'}"><td>${row.dd}</td></c:when> 
							</c:choose> 
							<td class="cnt">${row.cnt}</td> 
							<td class="pct">${row.pct}</td> 
						</tr> 
					</c:forEach> 
				</tbody> 
				<tfoot>
				  <tr>
				    <th>합계</th>
				    <th id="totalCnt">
				      <c:choose>
				        <c:when test="${not empty total}">
				          <fmt:formatNumber value="${total}" type="number"/>명
				        </c:when>
				        <c:otherwise></c:otherwise>
				      </c:choose>
				    </th>
				    <th id="totalPct">
				      <c:choose>
				        <c:when test="${not empty total and total ne 0}">100.00%</c:when>
				        <c:otherwise>0.00%</c:otherwise>
				      </c:choose>
				    </th>
				  </tr>
				</tfoot>
			</table> 
		</div> 
	</div> 
</div> 

<script>
$(function() {
    let total = 0;

    $('#statTable tbody tr').each(function() {
        const cnt = parseInt($(this).find('.cnt').text()) || 0;
        total += cnt;
    });

    $('#statTable tbody tr').each(function() {
        const cnt = parseInt($(this).find('.cnt').text()) || 0;
        const pct = total === 0 ? 0 : (cnt * 100 / total);
        $(this).find('.pct').text(pct.toFixed(2) + '%');
    });

    $('#totalCnt').text(total.toLocaleString() + "명");
    $('#totalPct').text(total === 0 ? '0.00%' : '100.00%');
    
    $('#btnExcel').click(function(){
        const frm = document.getElementById("downloadForm");
        frm.action = "<%= ctxPath%>/admin/downloadExcelFile";
        frm.submit();
     });
});
</script>
