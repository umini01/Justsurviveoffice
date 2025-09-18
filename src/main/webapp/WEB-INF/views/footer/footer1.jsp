<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath();
%>    
    
 
  </div>
    </div>
		<footer>
			<div class="footerBox" id="footerBox">
				<div class="footerNav">
					<ul class="footerInn">
					  <li class="footerCk"><a href="<%= ctxPath%>/company/company">회사소개</a></li>
					  <li class="footerCk"> <a href="javascript:void(0)" onclick="openPolicyPopup()">개인정보처리방침</a></li>
					  <li class="footerCk"><a href="<%= ctxPath%>/privacy/location">오시는 길</a></li>
					</ul>
					<ul class="footerInn">
					  <li class="footerCk"><a href="#"><i class="fa-brands fa-instagram"></i></a></li>
					  <li class="footerCk"><a href="#"><i class="fa-brands fa-twitter"></i></a></li>
					  <select name="footerBrd" id="footerBrd" >
					  	<option value="test">---- 선택 ----</option>
					  </select>
					 </ul>
				</div>
				<div class="footerBot">
					<div class="footerLogo"><img src="<%= ctxPath%>/images/footerLogo.png" alt="로고"></div>
					<div class="footerInfo">
						<p>대사살(대충사무실에서살아남기)</p>
						<p>주소: 서울특별시 역삼역 한독빌딩 8층 OOO</p>
						<p>Email: JustSurviveOffice@Gmail.com
						<p>TEL: 000-1111-2222</p>
						<p>COPYRIGHT All Right Reserved</p>
					</div>
				</div>
			</div>
		</footer>
	</div>
	<div id="PrivacyModal" class="modal">
	  <div class="modal-content">
	    <span class="close" onclick="closePolicyPopup()">&times;</span>
	    <iframe src="<%=ctxPath%>/privacy/privacy" style="width:100%;height:70vh;border:none;"></iframe>
	  </div>
	</div>
	<script>
	function openPolicyPopup() {
		  document.getElementById("PrivacyModal").style.display = "block";
		}
		function closePolicyPopup() {
		  document.getElementById("PrivacyModal").style.display = "none";
		}
	</script>
</body>
</html>