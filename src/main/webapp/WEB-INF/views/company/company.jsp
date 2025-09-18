<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../header/header1.jsp" />
<%
    String ctxPath = request.getContextPath();
%>

<style>
  /* 레이아웃 기본 */
  #mycontent{padding:0 !important;}
  #leftSess {display:none !important;}

  .companyTop {
    background-image:url("<%=ctxPath %>/images/footerBanner.png");
    background-size:cover; background-position:center;
    width:100%; min-height:38vh; padding:7% 20px;
    text-align:center; color:#fff; display:flex; align-items:center; justify-content:center;
    flex-direction:column;
  }
  .cpTop {font-size:2.2rem; line-height:1.25; font-weight:700; letter-spacing:-.2px;}
  .cpInfo {font-size:1.1rem; opacity:.95; margin-top:.6rem;}

  /* 섹션 공통 */
  .about-wrap {background:#fff;width:100%;}
  .about-section {
    margin:0 auto; padding:72px 20px;
    display:grid; grid-template-columns:1.1fr 1fr; gap:48px; align-items:center;
    border-bottom:1px solid #eee;
    opacity:0; transform:translateY(28px); transition:opacity .7s ease, transform .7s ease;
    will-change: transform, opacity;
  }
  .aboutContainer {max-width:1200px;margin:0 auto;}
  .about-section.show {opacity:1; transform:none;}

  /* 좌우 반전 */
  .about-section.alt {grid-template-columns:1fr 1.1fr;}
  .about-section .text h3{font-size:1.8rem; margin:0 0 .6rem; line-height:1.2; font-weight:700;}
  .about-section .text p{font-size:1.05rem; color:#444; line-height:1.75; margin:0;}
  .about-section .text .sub{font-size:.95rem; color:#777; margin:.6rem 0 0;}

  /* 이미지 박스 */
  .about-img {
    width:100%; aspect-ratio: 16/11; display:block; overflow:hidden; border-radius:20px;
    box-shadow: 0 8px 28px rgba(0,0,0,.08); background:#f6f7fb;
  }
  .about-img img{
    width:100%; height:100%; object-fit:cover; display:block; filter:saturate(1.06) contrast(1.02);
    transform:scale(1.02); transition:transform .8s ease;
  }
  .about-section.show .about-img img {transform:scale(1);}

  /* 태그/뱃지 */
  .chip {display:inline-block; font-size:.8rem; padding:.38rem .7rem; border-radius:999px;
         background:#eef1ff; color:#4f46e5; margin-bottom:.75rem; font-weight:600;}

  /* 반응형 */
  @media (max-width: 992px){
    .about-section, .about-section.alt {grid-template-columns:1fr; gap:22px; padding:56px 20px;}
    .about-section.alt .text {order:2;}
  }
  @media (max-width: 480px){
    .cpTop{font-size:1.7rem;}
    .cpInfo{font-size:1rem;}
    .about-section .text h3{font-size:1.5rem;}
    .about-section .text p{font-size:1rem;}
  }
</style>

  <!-- Hero -->
  <div class="companyTop">
    <h2 class="cpTop">대사살</h2>
    <article class="cpInfo">직장인들이 모여 자유롭게 얘기할 수 있는 커뮤니티 사이트입니다.</article>
  </div>

  <!-- 스크롤 리빌 섹션들 -->
  <main class="about-wrap">
	<div class="aboutContainer">
	    <section class="about-section" data-reveal>
	      <figure class="about-img">
	        <img src="<%=ctxPath %>/images/info1.png" loading="lazy" alt="자유로운 커뮤니티 분위기">
	      </figure>
	      <div class="text">
	        <span class="chip">OUR PHILOSOPHY</span>
	        <h3>회사에서 살아남는 법, <br/>“같이” 찾습니다</h3>
	        <p>
	          대사살은 혼자 버티지 않도록 돕는 익명 커뮤니티입니다.
	          업무 팁부터 인간관계, 커리어 전환까지 — 실전에서 통하는 이야기를 나누고,
	          필요하면 바로 써먹을 수 있게 정리합니다.
	        </p>
	        <p class="sub">실시간 익명으로 모든 소식을 빠르게 공유</p>
	      </div>
	    </section>
	
	    <section class="about-section alt" data-reveal>
	      <div class="text">
	        <span class="chip">FEATURE</span>
	        <h3>채팅과 소통도<br/>실시간으로 빠른 피드</h3>
	        <p>
	          MBTI처럼 성향을 간단히 진단하면, 글·댓글·자료가 맞춤 추천됩니다.
	          ‘꼰대형’, ‘MZ형’ 같은 카테고리로 분류되어 토론의 결이 분명해집니다.
	        </p>
	        <p class="sub">로그인한 유저라면 누구든지 자유롭게 소통</p>
	      </div>
	      <figure class="about-img">
	        <img src="<%=ctxPath %>/images/info2.png" loading="lazy" alt="성향 기반 맞춤 카테고리">
	      </figure>
	    </section>
	
	    <section class="about-section" data-reveal>
	      <figure class="about-img">
	        <img src="<%=ctxPath %>/images/info3.png" loading="lazy" alt="실무 중심 자료">
	      </figure>
	      <div class="text">
	        <span class="chip">RESOURCES</span>
	        <h3>회사에서 나의 취향/성향 카테고리는 무엇일까?</h3>
	        <p>
	          MBTI처럼 성향을 간단히 진단하면, 글·댓글·자료가 맞춤 추천됩니다.
	          ‘꼰대형’, ‘MZ형’ 같은 카테고리로 분류되어 토론의 결이 분명해집니다.
	        </p>
	        <p class="sub">MZ형 부터 금쪽이형까지 다양한 문제들로 구성</p>
	      </div>
	    </section>
	
	    <section class="about-section alt" data-reveal>
	      <div class="text">
	        <span class="chip">COMMUNITY</span>
	        <h3>존중이 기본인 게시판 문화</h3>
	        <p>
	          정해진 카테고리에서 게시판 내에 익명으로 댓글, 신고 및 업로드 등으로
	          재미있는 커뮤니티 환경을 유지합니다. 기록은 남고, 감정 소모는 줄입니다.
	        </p>
	        <p class="sub">사진첨부 · 댓글 작성 · 로그 감사</p>
	      </div>
	      <figure class="about-img">
	        <img src="<%=ctxPath %>/images/info4.png" loading="lazy" alt="건강한 커뮤니티 토론">
	      </figure>
	    </section>
	</div>
  </main>
</div>
  <jsp:include page="../footer/footer1.jsp" />

  <script>
    // IntersectionObserver로 섹션 등장 애니메이션
    (function(){
      const sections = document.querySelectorAll('[data-reveal]');
      const io = new IntersectionObserver((entries, obs) => {
        entries.forEach(entry => {
          if(entry.isIntersecting){
            entry.target.classList.add('show');
            obs.unobserve(entry.target); // 1번만
          }
        });
      }, { threshold: 0.15 });

      sections.forEach(s => io.observe(s));
    })();
  </script>

