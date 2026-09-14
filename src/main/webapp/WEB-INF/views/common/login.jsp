<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>로그인</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/style.css">
<style>
/* 1. 글로벌 바디 및 레이아웃 정의 */
body.login-page {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    background-color: #0b0f19 !important; /* 메인 관제소와 완벽히 동기화된 깊은 블랙네이비 톤 */
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', Roboto, sans-serif;
}

/* 2. 로그인 중앙 정렬용 외부 래퍼 */
.login-wrapper {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 60px 20px; /* 고정 헤더 영역 확보 및 반응형 패딩 */
    box-sizing: border-box;
}

/* 3. [구조 개량] 글래스모피즘 스타일의 하이테크 로그인 컨테이너 */
.login-container {
    width: 100%;
    max-width: 420px;
    padding: 40px;
    background: rgba(20, 26, 42, 0.85) !important; /* 관제 카드와 일치하는 투명 셋업 */
    border: 1px solid #1e293b !important;
    border-radius: 16px !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.5) !important;
    backdrop-filter: blur(4px);
    box-sizing: border-box;
}

/* 4. 타이틀 폰트 최적화 */
.login-container h2 {
    margin: 0 0 32px 0;
    color: #ffffff !important;
    text-align: center;
    font-size: 24px;
    font-weight: 700;
    letter-spacing: -0.03em;
}

/* 5. 입력 폼 그룹 컴포넌트 */
.input-group {
    display: flex;
    flex-direction: column;
    margin-bottom: 22px;
    box-sizing: border-box;
}

.input-group label {
    margin-bottom: 8px;
    color: #94a3b8 !important; /* 시인성이 개선된 슬레이트 그레이 컬러 */
    font-size: 13px;
    font-weight: 600;
    letter-spacing: -0.01em;
}

/* 사번 및 패스워드 인풋 창 슬림화 및 포커스 바인딩 */
.input-group input {
    width: 100%;
    background: #111827 !important; /* 사이드바와 동일한 내부 반전 색상 */
    padding: 12px 16px !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 8px !important;
    outline: none;
    font-size: 14px;
    box-sizing: border-box;
    transition: all 0.15s ease-in-out;
}

/* 인풋 입력창 포커스(클릭) 시 관제 블루 네온 링 장착 */
.input-group input:focus {
    border-color: #0ea5e9 !important;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25) !important;
}

/* 플레이스홀더(가이드 텍스트) 침침함 보정 */
.input-group input::placeholder {
    color: #4b5563;
    font-size: 13px;
}

/* 6. [디자인 개량] 고성능 스카이블루 로그인 서브밋 버튼 */
.login-btn {
    width: 100%;
    padding: 13px !important;
    border: 0 !important;
    border-radius: 8px !important;
    background: #0ea5e9 !important; /* 기존 보라색 걷어내고 관제 블루 전면 교체 */
    color: #ffffff !important;
    font-size: 15px;
    font-weight: 700;
    cursor: pointer;
    box-shadow: 0 4px 12px rgba(14, 165, 233, 0.2);
    transition: all 0.15s ease;
    box-sizing: border-box;
}

.login-btn:hover {
    background: #0284c7 !important; /* 한 단계 진한 호버 컬러 매핑 */
    box-shadow: 0 4px 16px rgba(14, 165, 233, 0.35);
    transform: translateY(-1px); /* 아주 미세하게 뜨는 조작감 부여 */
}

.login-btn:active {
    transform: translateY(0);
}
</style>
</head>
<body class="login-page">

<!-- 상단 공통 네온 헤더 바 인클루드 스왑 연동 -->
<jsp:include page="/WEB-INF/views/header.jsp" />

<div class="login-wrapper">
    <div class="login-container">
        <h2>시스템 로그인</h2>
        
        <!-- 오리지널 Form 보안 바인딩 및 라우팅 구조 100% 보존선 -->
        <form:form id="loginForm" action="${pageContext.request.contextPath}/login" method="post">
            
            <!-- CSRF 변수 암호화 토큰 주입 파이프라인 유지 -->
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            
            <!-- 사번 입력 필드 -->
            <div class="input-group">
                <label for="username">사번 (아이디)</label> 
                <input type="text" id="username" name="memberId" placeholder="사번을 입력하세요" required autocomplete="username">
            </div>
            
            <!-- 비밀번호 입력 필드 -->
            <div class="input-group">
                <label for="password">비밀번호</label> 
                <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required autocomplete="current-password">
            </div>
            
            <!-- 로그인 실행 버튼 -->
            <button type="submit" class="login-btn">접속하기</button>
            
        </form:form>
    </div>
</div>
	<script>
        const contextPath = "${pageContext.request.contextPath}";
        fetch(contextPath + '/menu')
            .then(response => response.text())
            .then(data => {
                document.getElementById('menu-placeholder').innerHTML = data;
                document.dispatchEvent(new Event('menuLoaded'));
            })
            .catch(error => console.error('메뉴를 불러오는 중 오류 발생:', error));
    </script>
	<script
		src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
</body>
</html>
