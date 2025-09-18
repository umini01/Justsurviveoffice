<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath(); // e.g. /myspring
%>

<jsp:include page="../header/header2.jsp" />

<style>
  /* ========= 톡방 느낌의 둥글둥글 + 반응형 기본값 ========= */
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
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", sans-serif;
    -webkit-font-smoothing: antialiased;
    text-rendering: optimizeLegibility;
  }

  /* 페이지 레이아웃 살짝 여백 */
  .col > div {
    padding: 12px 0;
  }

  /* 제목 스타일 */
  h2 {
    margin: 28px 0 18px 0 !important;
    font-size: clamp(20px, 2.1vw, 28px);
    font-weight: 800;
    letter-spacing: -0.02em;
    color: #121826;
  }

  /* ========= 카드(버블) 컨테이너 ========= */
  #chart_container,
  #table_container {
    background: var(--card);
    border-radius: var(--radius-xl);
    box-shadow: var(--shadow);
    border: 1px solid var(--line);
    padding: clamp(14px, 2.2vw, 22px);
  }

  /* 차트 높이 */
  #chart_container { min-height: 360px; }

  /* Highcharts 기본 배경 투명 처리로 카드와 어울리게 */
  .highcharts-background { fill: transparent; }
  .highcharts-title { font-weight: 700 !important; fill: #111 !important; }

  /* ========= 폼/셀렉트(알약 모양) ========= */
  form[name="searchFrm"]{
    display: flex;
    align-items: center;
    gap: 12px;
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 9999px;
    padding: 8px 12px;
    width: fit-content;
    box-shadow: var(--shadow);
  }
  #searchType{
    border: none;
    outline: none;
    font-size: 14px;
    padding: 1%;
    border-radius: 9999px;
    box-shadow: inset 0 0 0 1px var(--line);
    cursor: pointer;
    height:30px;
  }
  /* 셀렉트 오른쪽 화살표 */
  #searchType{
    background-image:
      linear-gradient(180deg, #fff, #fff),
      linear-gradient(180deg, var(--brand-weak), var(--brand-weak)),
      url("data:image/svg+xml,%3Csvg width='14' height='14' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M3 5l4 4 4-4' stroke='%236C7FF2' stroke-width='2' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
    background-repeat: no-repeat, no-repeat, no-repeat;
    background-position: left top, left top, right 12px center;
    background-size: auto, auto, 14px 14px;
  }
  
  #searchMonth {
	border: none;
	outline: none;
	font-size: 14px;
	padding: 0 30px 0 0 !important;
	padding: 1%;
	border-radius: 9999px;
	box-shadow: inset 0 0 0 1px var(--line);
	cursor: pointer;
    }
	
  #searchType:focus{
    box-shadow: 0 0 0 3px rgba(108,127,242,.25);
  }

  /* ========= 표(테이블) 톡방 버블 느낌 ========= */
  #table_container { margin-top: 18px; overflow: hidden; }
  #table_container table{
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    min-width: 560px;         
    border: 1px solid var(--line);
    border-radius: var(--radius-lg);
    overflow: hidden;
  }
  #table_container thead th{
    background: var(--brand-weak);
    color: #27314a;
    font-weight: 700;
    text-align: center;
    padding: 12px 10px;
    border-bottom: 1px solid var(--line);
  }
  #table_container td{
    padding: 10px 12px;
    border-bottom: 1px solid var(--line);
    text-align: right;
    white-space: nowrap;
  }
  #table_container td:first-child,
  #table_container th:first-child{
    text-align: center;
  }

  /* 지브라 + 호버 */
  #table_container tbody tr:nth-child(even){ background: #fafafa; }
  #table_container tbody tr:hover{
    background: #f1f5ff;
    transition: background .2s ease;
  }

  /* 테이블이 작은 화면에서 넘치면 스크롤 */
  #table_container{
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
  }

  /* ========= Highcharts 데이터 테이블(접근성)도 동일한 톤 ========= */
  .highcharts-data-table table{
    width: 100%;
    max-width: none;
    border: 1px solid var(--line);
    border-radius: var(--radius-lg);
    overflow: hidden;
    box-shadow: var(--shadow);
  }
  .highcharts-data-table thead tr,
  .highcharts-data-table tr:nth-child(even){ background: #fafafa; }
  .highcharts-data-table tr:hover{ background: #f1f7ff; }

  /* ========= 미세 인터랙션 ========= */
  #chart_container, #table_container, form[name="searchFrm"]{
    transition: transform .12s ease, box-shadow .12s ease;
  }
  #chart_container:hover,
  #table_container:hover,
  form[name="searchFrm"]:hover{
    transform: translateY(-2px);
    box-shadow: 0 14px 28px rgba(0,0,0,.08);
  }
  
  @media screen and (max-width:1300px) {
  	.chartAdm {padding:40px 0 0;}
  }

  /* ========= 반응형 ========= */
  @media (max-width: 900px){
    #chart_container{ min-height: 320px; }
  }
  
  @media screen and (max-width:800px){
  	.chartAdm {margin:0 auto !important;}
  }
  
  @media (max-width: 640px){
    h2{ margin: 18px 0 12px 0 !important; }
    form[name="searchFrm"]{ padding: 6px 10px; }
    #searchType{ padding: 9px 34px 9px 12px; font-size: 13px; height:40px;}
    #table_container table{ min-width: 360px; }
    
  }
</style>


<!-- Highcharts -->
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/highcharts.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/exporting.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/export-data.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/accessibility.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/series-label.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/data.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/drilldown.js"></script>

<div class="col">
	<div style="display:flex;width:100%;">
	  <div class="chartAdm" style="width:90%; min-height:300px; margin: 0 10%;">
	    <h2 style="margin: 50px 0;">대사살 통계정보(차트)</h2>
	
	    <form name="searchFrm" style="margin: 20px 0 50px 0;">
	      <select name="searchType" id="searchType">
	         <option value="">통계선택하세요</option>
	         <option value="register">회원가입 인원통계(월별)</option>
	         <option value="registerDay">회원가입 인원통계(일자별)</option>
	      </select>
	      <select name="searchMonth" id="searchMonth" style="height:30px;">
	       	 <option value="">월을 선택하세요</option>
	       	 <option value="1">1월</option>
	       	 <option value="2">2월</option>
	       	 <option value="3">3월</option>
	       	 <option value="4">4월</option>
	       	 <option value="5">5월</option>
	       	 <option value="6">6월</option>
	       	 <option value="7">7월</option>
	       	 <option value="8">8월</option>
	       	 <option value="9">9월</option>
	       	 <option value="10">10월</option>
	       	 <option value="11">11월</option>
	       	 <option value="12">12월</option>
	       </select>
	    </form>
	
	    <div id="chart_container"></div>
	    <div id="table_container" style="margin-top:40px;"></div>
	  </div>
	</div>
	<!-- end of chart !-->
</div>

<script type="text/javascript">
  $(function(){
    $('#searchType').change(function(e){
      func_choice($(e.target).val());
    });
	
	// 이게 셀렉트박스 옵션 추가임
	$('#searchMonth').change(function(){
	  const type = $('#searchType').val();
	  if(type) func_choice(type);
	});

    // 최초 로딩 시 월별 선택 후 실행
    $('#searchType').val("register").trigger("change");
  });

  function func_choice(searchTypeVal){
    switch(searchTypeVal) {
      case "":
        $('#chart_container, #table_container, #highcharts-data-table').empty();
		$('#searchMonth').hide();  // 일별에서만 셀렉트박스 보이도록 추가--
        break;

		case "register": // 월별 가입자
		$('#searchMonth').hide(); 
		  $.ajax({
		    url: "<%= ctxPath%>/admin/chart/registerChart",
		    dataType: "json",
		    success: function(json){
		      $('#chart_container, #table_container, #highcharts-data-table').empty();

		      // 1) 01~12월 고정 라벨
		      const labelsFixed = Array.from({length:12}, (_,i)=> String(i+1).padStart(2,'0'));
		      var nowyear = (json && json.length && json[0].nowyear) ? parseInt(json[0].nowyear, 10) : new Date().getFullYear();
			  // 이건 json값이 존재하면서, json이 값을 가지고 있고, 현재년도일 시 그걸 10진수로 parseInt로 변환시킨다는 뜻
		      
		      // 2) 응답을 mm->cnt 맵으로 만들고, 고정 라벨 순서대로 값(없으면 0) 채우기
		      const monthMap = {};
		      (json || []).forEach(({mm, cnt}) => {
		        monthMap[String(mm).padStart(2,'0')] = Number(cnt || 0);
		      });
		      const data = labelsFixed.map(mm => monthMap[mm] ?? 0);

		      const total = data.reduce((a,b)=>a+b, 0);

		      // 3) Highcharts: 세로 막대(컬럼). 가로 막대 원하면 type: 'bar' 로 설정 하면됨
		      Highcharts.chart('chart_container', {
		        chart: { type: 'column' }, // 'bar'로 바꾸면 가로 막대임
		        title: { text: nowyear +'년 월별 가입자 수' },
		        xAxis: { categories: labelsFixed, title: { text: '월' } },
		        yAxis: { min: 0, allowDecimals: false, title: { text: '가입자 수(명)' } },
		        tooltip: {
		          formatter: function () {
		            const pct = total === 0 ? 0 : (this.y * 100 / total);
		            return '<b>' + this.x + '월</b><br/>' + this.y + '명 (' + pct.toFixed(2) + '%)';
		          }
		        },
		        plotOptions: {
		          column: {
		            pointPadding: 0.1,
		            borderWidth: 0,
		            dataLabels: { enabled: true, format: '{point.y}' }
		          }
		        },
		        series: [{ name: '가입자 수', data }]
		      });
		      
		      let v_html = `<table class="table table-sm table-bordered">
		          <thead class="thead-light">
		            <tr>
		              <th style="text-align:center;">월</th>
		              <th style="text-align:right;">가입자 수</th>
		              <th style="text-align:right;">퍼센티지</th>
		            </tr>
		          </thead>
		          <tbody>`;

		      labelsFixed.forEach(mm => {
		        const cnt = monthMap[mm] ?? 0;
		        const pct = total === 0 ? 0 : (cnt * 100 / total);
		        v_html += `<tr>
		            <td style="text-align:center;">\${mm}</td>
		            <td style="text-align:right;">\${cnt.toLocaleString()}명</td>
		            <td style="text-align:right;">\${pct.toFixed(2)}%</td>
		          </tr>`;
		      });

		      v_html += `<tr>
		          <th style="text-align:center;">합계</th>
		          <th style="text-align:right;">\${total.toLocaleString()}명</th>
		          <th style="text-align:right;">\${total === 0 ? '0.00%' : '100.00%'}</th>
		        </tr>`;

		      v_html += `</tbody></table>`;
		      
		      $('#table_container').html(v_html);
		    },
		    error: function(request, status, error){
		      alert("code: "+request.status+"\nmessage: "+request.responseText+"\nerror: "+error);
		    }
		  });
		  break;
	
		  case "registerDay": // 일자별 가입자
		  $('#searchMonth').show();
		    $.ajax({
		      url: "<%= ctxPath%>/admin/chart/registerChartday",
		      dataType: "json",
		      data: (function(){
		        const m = $('#searchMonth').val();
		        return m ? { month: parseInt(m, 10) } : {};
		      })(),
		      success: function(json){
		        $('#chart_container, #table_container, #highcharts-data-table').empty();

		        const labelsFixed = Array.from({length:31}, (_,i)=> String(i+1).padStart(2,'0'));

		        let selectedMonth = $('#searchMonth').val();
		        let nowmonth = (selectedMonth && selectedMonth !== "")
		                         ? parseInt(selectedMonth, 10)
		                         : (json && json.length && json[0].nowmonth)
		                            ? parseInt(json[0].nowmonth, 10)
		                            : (new Date().getMonth() + 1);

		        const dayMap = {};
		        (json || []).forEach(({dd, cnt}) => {
		          dayMap[String(dd).padStart(2,'0')] = Number(cnt || 0);
		        });
		        const data = labelsFixed.map(dd => dayMap[dd] ?? 0);
		        const total = data.reduce((a,b)=>a+b, 0);

		        // 제목에서 nowmonth 반영
		        Highcharts.chart('chart_container', {
		          chart: { type: 'column' },
		          title: { text: (new Date().getFullYear()) + '년 ' + nowmonth + '월 가입자 수' },
		          xAxis: { categories: labelsFixed, title: { text: '일' } },
		          yAxis: { min: 0, allowDecimals: false, title: { text: '가입자 수(명)' } },
			        tooltip: {
			          formatter: function () {
			            const pct = total === 0 ? 0 : (this.y * 100 / total);
			            return '<b>' + this.x + '일</b><br/>' + this.y + '명 (' + pct.toFixed(2) + '%)';
			          }
			        },
			        plotOptions: {
			          column: {
			            pointPadding: 0.1,
			            borderWidth: 0,
			            dataLabels: { enabled: true, format: '{point.y}' }
			          }
			        },
			        series: [{ name: '가입자 수', data }]
			      });
			      
			      let v_html = `<table class="table table-sm table-bordered">
			          <thead class="thead-light">
			            <tr>
			              <th style="text-align:center;">일</th>
			              <th style="text-align:right;">가입자 수</th>
			              <th style="text-align:right;">퍼센티지</th>
			            </tr>
			          </thead>
			          <tbody>`;

			      labelsFixed.forEach(dd => {
			        const cnt = dayMap[dd] ?? 0;
			        const pct = total === 0 ? 0 : (cnt * 100 / total);
			        v_html += `<tr>
			            <td style="text-align:center;">\${dd}</td>
			            <td style="text-align:right;">\${cnt.toLocaleString()}명</td>
			            <td style="text-align:right;">\${pct.toFixed(2)}%</td>
			          </tr>`;
			      });

			      v_html += `<tr>
			          <th style="text-align:center;">합계</th>
			          <th style="text-align:right;">\${total.toLocaleString()}명</th>
			          <th style="text-align:right;">\${total === 0 ? '0.00%' : '100.00%'}</th>
			        </tr>`;

			      v_html += `</tbody></table>`;
			      $('#table_container').html(v_html);
			    },
			    error: function(request, status, error){
			      alert("code: "+request.status+"\nmessage: "+request.responseText+"\nerror: "+error);
			    }
			  });
		 break;
       
    }
  }
</script>