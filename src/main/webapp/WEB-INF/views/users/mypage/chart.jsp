<%@ page contentType="text/html; charset=UTF-8" 
		 pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지</title>

<link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<!-- Highcharts -->
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/highcharts.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/exporting.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/export-data.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/accessibility.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/series-label.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/data.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/drilldown.js"></script>


<style type="text/css">
	
	/* 사이드바 */
	body { background: #f7f7fb; font-family: 'Noto Sans KR', sans-serif; }
	.sidebar { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 8px 24px rgba(0,0,0,.06); }
	.sidebar img { max-width: 100%; border-radius: 10px; }
	.sidebar-menu a { display: block; padding: 8px 0; color: #333; text-decoration: none;font-weight:500;}
	.sidebar-menu a:hover { color: #6c63ff; } 
	.content { background: #fff; border-radius: 12px; padding: 24px; box-shadow: 0 8px 24px rgba(0,0,0,.06); }   	
   	/* 차트 */
   	.highcharts-figure, .highcharts-data-table table { min-width:320px; max-width:800px; margin:1em auto; }
   	div#chart_container { height: 400px; }
   	.highcharts-data-table table {
       	font-family: Verdana, sans-serif; border-collapse: collapse; border: 1px solid #ebebeb;
       	margin: 10px auto; text-align: center; width: 100%; max-width: 500px;
   	}
   	.highcharts-data-table caption { padding: 1em 0; font-size: 1.2em; color: #555; }
   	.highcharts-data-table th { font-weight: 600; padding: 0.5em; }
   	.highcharts-data-table td, .highcharts-data-table th, .highcharts-data-table caption { padding: 0.5em; }
   	.highcharts-data-table thead tr, .highcharts-data-table tr:nth-child(even) { background: #f8f8f8; }
   	.highcharts-data-table tr:hover { background: #f1f7ff; }
   	input[type="number"] { min-width: 50px; }

	/* 테이블 */
   	#table_container table { width:100%; border-collapse:separate; border-spacing:0; border:1px solid #e5e7eb; border-radius:16px; box-shadow:0 8px 20px rgba(0,0,0,.05); overflow:hidden; background:#fff; } 
   	#table_container thead th { background:#EEF1FF; color:#27314a; font-weight:700; text-align:center; padding:12px 10px; border-bottom:1px solid #e5e7eb; } 
   	#table_container td, #table_container th { padding:10px 12px; border-bottom:1px solid #e5e7eb; text-align:center; vertical-align:middle; }
	#table_container tbody tr:nth-child(even) { background: #fafafa; }
	#table_container tbody tr:hover { background: #f1f5ff; }

   	img {border-radius: 50px;}
   	
</style>

<script type="text/javascript">
	
	$(function(){
		
		$('#searchType').change(function(e){
      		func_choice($(e.target).val());
	    });

	    // 최초 로딩 시 월별 선택 후 실행
	    $('#searchType').val("categoryByUsers").trigger("change");
		
	});
	
	
	function func_choice(searchTypeVal){
		
		switch (searchTypeVal) {
			
			case "":
				$('div#chart_container').empty();
				$('div#table_container').empty();
				$('div.highcharts-data-table').empty();
				break;
			
			case "categoryByBoard": // 카테고리별 게시글 통계
				$.ajax({
               		url: "<%= ctxPath%>/mypage/chart/categoryByBoard",
	                type: "post",
	                dataType: "json",
	                success: function (json) {
	                    $("div#chart_container").empty();
	                    $("div#table_container").empty();
	                    
	              		let resultArr = [];
	              
	              		for(let i=0; i<json.length; i++) {
	                 
		                 	let obj;
		                 
		                 	if(i==0) {
		                    	obj = {name: json[i].categoryName,
		                               y: Number(json[i].percentage),
		                               sliced: true,
		                               selected: true,
		                               image: "<%= ctxPath%>/images/" + json[i].categoryImagePath
		                              };
	                    	//	console.log("이미지 경로:", obj.image);
	              			}
		                 	else {
		                    	obj = {name: json[i].categoryName,
		                               y: Number(json[i].percentage),
		                               image: "<%= ctxPath%>/images/" + json[i].categoryImagePath};
	                 		}
		                 
		                 	resultArr.push(obj);
	                 	                 
	              		} // end of for
	              
	              		// ====================================================== //
	              		Highcharts.chart('chart_container', {
	                  		chart: {
	                      		plotBackgroundColor: null,
	                      		plotBorderWidth: null,
	                      		plotShadow: false,
	                      		type: 'pie'
	                  		},
	                  		title: {
	                      		text: '카테고리별 게시글 통계'
	                  		},
	                  		tooltip: {
	                	  		useHTML: true,
	                      		formatter: function () {
	                          		return `
	                              			<div style="text-align:center;">
	                                  			<img src="\${this.point.image}" width="50" height="50"
	                                       		 	 style="display:block; margin:0 auto 5px;" />
	                                  			 <b>\${this.point.name}</b>: \${this.percentage.toFixed(2)}%
	                              			</div>
	                          			   `;
	                      		}
	                  		},
	                  		accessibility: {
	                      		point: {
	                          		valueSuffix: '%'
	                      		}
	                  		},
	                  		plotOptions: {
	                      		pie: {
	                          		allowPointSelect: true,
	                          		cursor: 'pointer',
	                          		dataLabels: {
	                              		useHTML: true,
	                              		enabled: true,
	                              		distance: 20,
	                              		formatter: function () {
	                                  		return `
	                                      			<img src="\${this.point.image}" width="50" height="50"
	                                           			 style="vertical-align:middle; margin-right:5px;" />
	                                      			<b>\${this.point.name}</b> \${this.percentage.toFixed(2)}%
	                                  			   `;
	                              		}
	                          	}
	                      	}
	                  	},
	                  	series: [{
	                      	name: '게시글 수',
	                      	colorByPoint: true,
	                      	data: resultArr
	                  	}]
	              	});                  
	              	// ====================================================== //
	              
	              	let v_html = `<table>
	              					<thead>
	                           			<tr>
	                              			<th>카테고리</th>
	                              			<th>게시글 수</th>
	                              			<th>퍼센티지</th>
	                           	  		</tr>
	                           	  	</thead>
	                           	  	<tbody>`;
	                           
	              	$.each(json, function(index, item){
	                 	v_html += `<tr>
	                            		<td>\${item.categoryName}</td>
	                            		<td>\${item.cnt}</td>
	                            		<td>\${item.percentage}%</td>
	                          	   </tr>
	                          	   </tbody>`;
	              	});             
	                           
	              	v_html += `</table>`;
	              
	              	$('div#table_container').html(v_html);         
	              
	           	},
	           	error: function(request, status, error){
                	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
               	}
        	});
			break;
			
			case "categoryByUsers": // 카테고리별 인원수 통계
				$.ajax({
               		url: "<%= ctxPath%>/mypage/chart/categoryByUsers",
	                type: "post",
	                dataType: "json",
	                success: function (json) {
	                    $("div#chart_container").empty();
	                    $("div#table_container").empty();
	                    
	              		let resultArr = [];
	              
	              		for(let i=0; i<json.length; i++) {
	                 
		                 	let obj;
		                 	
		                 	let imgPath;

		                 	if(!json[i].categoryImagePath || json[i].categoryName === '미분류') {
		                 	    // DB에 경로 없거나 카테고리가 미분류일 때
		                 	    imgPath = "<%= ctxPath%>/images/unassigned.png"; 
		                 	}
		                 	else {
		                 	    imgPath = "<%= ctxPath%>/images/" + json[i].categoryImagePath;
		                 	}
		                 			                 	
		                 	if(i==0) {
		                    	obj = {name: json[i].categoryName,
		                               y: Number(json[i].percentage),
		                               sliced: true,
		                               selected: true,
		                               image: imgPath
		                              };
	                    	//	console.log("이미지 경로:", obj.image);
	              			}
		                 	else {
		                    	obj = {name: json[i].categoryName,
		                               y: Number(json[i].percentage),
		                               image: imgPath};
	                 		}
		                 
		                 	resultArr.push(obj);
	                 	                 
	              		} // end of for
	              
	              		// ====================================================== //
	              		Highcharts.chart('chart_container', {
	                  		chart: {
	                      		plotBackgroundColor: null,
	                      		plotBorderWidth: null,
	                      		plotShadow: false,
	                      		type: 'pie'
	                  		},
	                  		title: {
	                      		text: '카테고리별 인원수 통계'
	                  		},
	                  		tooltip: {
	                	  		useHTML: true,
	                      		formatter: function () {
	                          		return `
	                              			<div style="text-align:center;">
	                                  			<img src="\${this.point.image}" width="50" height="50"
	                                       		 	 style="display:block; margin:0 auto 5px;" />
	                                  			 <b>\${this.point.name}</b>: \${this.percentage.toFixed(2)}%
	                              			</div>
	                          			   `;
	                      		}
	                  		},
	                  		accessibility: {
	                      		point: {
	                          		valueSuffix: '%'
	                      		}
	                  		},
	                  		plotOptions: {
	                      		pie: {
	                          		allowPointSelect: true,
	                          		cursor: 'pointer',
	                          		dataLabels: {
	                              		useHTML: true,
	                              		enabled: true,
	                              		distance: 20,
	                              		formatter: function () {
	                                  		return `
	                                      			<img src="\${this.point.image}" width="50" height="50"
	                                           			 style="vertical-align:middle; margin-right:5px;" />
	                                      			<b>\${this.point.name}</b> \${this.percentage.toFixed(2)}%
	                                  			   `;
	                              		}
	                          	}
	                      	}
	                  	},
	                  	series: [{
	                      	name: '게시글 수',
	                      	colorByPoint: true,
	                      	data: resultArr
	                  	}]
	              	});                  
	              	// ====================================================== //
	              
	              	let v_html = `<table>
	              					<thead>
	                           			<tr>
	                              			<th>카테고리</th>
	                              			<th>게시글 수</th>
	                              			<th>퍼센티지</th>
	                           	  		</tr>
	                           	  	</thead>
	                           	  	<tbody>`;
	                           
	              	$.each(json, function(index, item){
	                 	v_html += `<tr>
	                            		<td>\${item.categoryName}</td>
	                            		<td>\${item.cnt}</td>
	                            		<td>\${item.percentage}%</td>
	                          	   </tr>
	                          	   </tbody>`;
	              	});             
	                           
	              	v_html += `</table>`;
	              
	              	$('div#table_container').html(v_html);         
	              
	           	},
	           	error: function(request, status, error){
                	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
               	}
        	});
	       	break;
		}
	}
	
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

                	<!-- 탭 메뉴 -->
                	<ul class="nav nav-tabs mb-3">
                    	<li class="nav-item"><a class="nav-link" href="<%= ctxPath%>/mypage/info">내 정보</a></li>
	                    <li class="nav-item"><a class="nav-link" href="<%= ctxPath%>/mypage/forms">내가 쓴 글</a></li>
	                    <li class="nav-item"><a class="nav-link" href="<%= ctxPath%>/mypage/bookmarks">내 북마크</a></li>
	                    <li class="nav-item"><a class="nav-link active" href="<%= ctxPath%>/mypage/chart">통계</a></li>
                	</ul>
                	
                	<h2>대사살 통계정보(차트)</h2>
                	
                	<form name="searchFrm" style="margin: 20px 0 50px 0;">
				      	<select name="searchType" id="searchType" style="height:30px;">
				        	<option value="">------ 선택하세요 ------</option>
					        <option value="categoryByUsers">카테고리별 인원수 통계</option>				        	
					        <option value="categoryByBoard">카테고리별 게시물 통계</option>
				      	</select>
				    </form>
					
					<div id="chart_container"></div>
					<div id="table_container" style="margin-top:40px;"></div>
                	
              	</div>
           	</div>
           
        </div>
         
   	</div>
         
</body>
</html>