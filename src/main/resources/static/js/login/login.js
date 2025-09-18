$(function(){
	
	$('button#btnSubmit').click(function(){ // click하면 handler(로그인 시도) 해라
		
		// goLogin_Cookies(); 	//로그인 시도(아이디 저장은 Cookie를 사용함)
		goLogin_LocalStorage(); //로그인 시도(아이디 저장은 LocalStorage를 사용함)
		
	}); 
	
	$('input#loginPwd').bind("keyup",(e)=>{
		if(e.keyCode == 13){ // 엔터는 13, 암호입력란에 엔터를 했을 경우 
			// goLogin_Cookies(); 	//로그인 시도(아이디 저장은 Cookie를 사용함)
			goLogin_LocalStorage();	//로그인 시도(아이디 저장은 LocalStorage를 사용함)
		}
	})
	
}); // end of $(function(){}) =============================

// function Declation

// ==== 로그인 처리 함수(아이디저장은 Cookie를 사용함) === // 
function goLogin_Cookies(){
	
	if($('input#loginUserid').val().trim() == ""){
		alert('아이디를 입력하세요!');
		$('input#loginUserid').val("").focus();
		return; // goLogin() 함수 종료
	}
	
	if($('input#loginPwd').val().trim() == ""){
		alert('비밀번호를 입력하세요!');
		$('input#loginPwd').val("").focus();
		return; // goLogin() 함수 종료
	}
	
	const frm = document.loginFrm;
	frm.submit();
	
	
} // end of function goLogin(){}  ============

// ==== 로그인 처리 함수(아이디저장은 LocalStorage를 사용함) === // 
function goLogin_LocalStorage(){
	
	if($('input#loginUserid').val().trim() == ""){
		alert('아이디를 입력하세요!');
		$('input#loginUserid').val("").focus();
		return; // goLogin() 함수 종료
	}
	
	if($('input#loginPwd').val().trim() == ""){
		alert('비밀번호를 입력하세요!');
		$('input#loginPwd').val("").focus();
		return; // goLogin() 함수 종료
	}
	
	if($('input:checkbox[id="saveid"]').prop("checked")){
		localStorage.setItem('saveid', $('input:text[name="userid"]').val());
	} else {
		localStorage.removeItem('saveid');
	}
	
	const frm = document.loginFrm;
	frm.submit();
	
	
} // end of function goLogin(){}  ============

// ==== 로그아웃 처리 함수 === //
function goLogOut(ctx_Path){
	
	// 로그아웃을 처리해주는 페이지로 이동 <%= = %> 밖으로 뺸 jsp라서 못 쓴다.
	location.href=`${ctx_Path}/users/logout.up`;
	
} // end of function goLogOut(){} ========================

// == 코인충전 결제금액 선택하기(실제로 카드 결제) == //

function goCoinPurchaseTypeChoice(userid,ctx_Path){

	// 코인충전 결제금액 선택하기 팝업창 띄우기 시작
	const url =`${ctx_Path}/member/coinPurchaseTypeChoice.up?userid=${userid}`;
	
	// 너비 650, 높이 570 인 팝업창을 화면 가운데 위치시키기
	const width = 650;
	const height = 570;
	
	const left = Math.ceil((window.screen.width - width) / 2);
	
	const top = Math.ceil((window.screen.height - height)/2);  // 정수로 만듬
	// 1400 - 650 = 750 /2 => 375
	
	window.open(url, "goCoinPurchaseTypeChoice", `left=${left}, top=${top}, width=${width}, height=${height}`); // 작명은 마음대로 한다.
		
} // end of function goCoinPurchaseTypeChoice(userid,ctxPath){
	
/*function test(){
	alert(`헤헤헤`);
}*/

// ===포트원(구 아임포트) 결제모듈 구현하는 함수 === //
function goCoinPurchaseEnd(ctx_Path, coinmoney, userid){

	// alert(`확인용 부모창의 함수호출. \n 결제금액: ${coinmoney}용 , 사용자id ${userid}`);
	// 금액 확인 시, coinpurchasetypejs에 파라미터에 변수에 담아서 값을 보내야, 여기서 그 값을 받는다.
	
	// 포트원(구 아임포트) 결제 팝업창 띄우기 (GET방식은 문자열한다고 "" 하면 안된다.)
	const url =`${ctx_Path}/member/coinPurchaseEnd.up?userid=${userid}&coinmoney=${coinmoney}`;
	
	// 너비 1000, 높이 600 인 팝업창을 화면 가운데 위치시키기
	const width = 1000;
	const height = 600;
	
    const left = Math.ceil((window.screen.width - width) / 2);
							// 1400 - 1000 = 200
	
	const top = Math.ceil((window.screen.height - height) / 2);  // 정수로 만듬
						// 1400 - 650 = 750 /2 => 375
	
	window.open(url, "coinPurchaseEnd", `left=${left}, top=${top}, width=${width}, height=${height}`); // 작명은 마음대로 한다.
		
} // end of function goCoinPurchase(ctx_Path, coinmoney, userid){


		
// ==== DB 상의 tbl_member 테이블에 해당 사용자의 코인금액 및 포인트를 증가(update)시켜주는 함수 === //
function goCoinUpdate(ctxPath, userid, coinmoney) {
	
	console.log(`-- 확인용 userid : ${userid}, ${coinmoney}`);
	
	// 입력받은 값을 가지고 db에 가서 업데이트 시켜줌.
	// 스크립트 내에서 자바를 불러올 땐, $ajax를 쓰면된다. 
	$.ajax({
		url:`${ctxPath}/users/coinUpdateLoginUser.up`,
		data:{"userid" : userid,
			  "coinmoney" : coinmoney},
		type:"post",
		async:true,
		dataType:"json",
		success:function(json){
			console.log("확인용 json => ", json);
			// {message: '김예준님의 300,000만원 결제가 완료되었습니다.', loc:'/myMVC/index.up'}
			
			alert(json.message);
			location.href = json.loc;
		},
		error: function(request, status, error){
		    alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
	});
	
} // end of function goCoinUpdate(ctxPath, userid, coinmoney)

// 내정보 수정하기 //
function goEditMyInfo(userid,ctx_Path){
	
	// 나의정보 수정하기 팝업창 띄우기
	   const url = `${ctx_Path}/member/memberEdit.up?userid=${userid}`;
	//  또는
	//  const url = ctx_Path+"/member/memberEdit.up?userid="+userid;   
	   
	   // 너비 800, 높이 680 인 팝업창을 화면 가운데 위치시키기
	   const width = 800;
	   const height = 680;
	/*   
	   console.log("모니터의 넓이 : ",window.screen.width);
	   // 모니터의 넓이 :  1440
	   
	   console.log("모니터의 높이 : ",window.screen.height);
	   // 모니터의 높이 :  900
	*/   
	   const left = Math.ceil((window.screen.width - width)/2);  // 정수로 만듬 
	   const top = Math.ceil((window.screen.height - height)/2); // 정수로 만듬
	   window.open(url, "myInfoEdit", `left=${left}, top=${top}, width=${width}, height=${height}`);
	
} // end of function goEditMyInfo(userid,ctx_Path){}