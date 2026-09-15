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
<title>메뉴</title>
<link rel="icon" href="./favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="<c:url value='/resources/css/style.css'/>">

<style>
/* 1. 사이드바 폭을 글자 크기에 딱 맞게 초슬림화 (200px -> 150px) */
nav {
    position: fixed !important;
    top: 80px !important; 
    left: 0 !important;
    width: 150px !important; /* ⭕ 여백을 완전히 걷어내고 150px로 슬림하게 변경 */
    height: calc(100vh - 80px) !important;
    background-color: #111827 !important; 
    border-right: 1px solid #1e293b;
    box-shadow: 4px 0 20px rgba(0, 0, 0, 0.25);
    box-sizing: border-box;
    overflow-y: auto;
    z-index: 900 !important;
}

/* 2. 대분류 리스트 영역 디자인 */
.sidebar-list {
    list-style: none !important;
    padding: 10px 0 !important; 
    margin: 0 !important;
    width: 100%;
}

.sidebar-list > li {
    padding: 0 !important;
    margin: 0 !important;
    position: relative; 
    width: 100%;
}

/* 3. 대분류 타이틀 내부 여백 최소화 */
.sidebar-list > li > a {
    display: block;
    padding: 14px 14px; /* ⭕ 좌우 패딩을 14px로 더 압축하여 글자와 테두리를 밀착 */
    font-size: 14px;
    font-weight: 600;
    color: #94a3b8 !important; 
    text-decoration: none !important;
    border-left: 4px solid transparent; 
    box-sizing: border-box;
    cursor: pointer;
}

/* 0초 만에 칼같이 들어오는 확실한 피드백 */
.sidebar-list > li:hover > a {
    color: #38bdf8 !important; 
    background: linear-gradient(90deg, rgba(14, 165, 233, 0.15) 0%, rgba(14, 165, 233, 0) 100%); 
    border-left: 4px solid #38bdf8; 
}

/* 4. 서브메뉴(Dropdown) 팝업창 위치를 150px 너비에 맞춰 자석 밀착 */
/* ⭕ 기존 .submenu 속성을 아래 코드로 통째로 교체하세요 */
.submenu {
    display: none; 
    position: absolute;
    top: 0;
    left: 149px; /* 원래 가로폭 경계면 고정 */
    width: 160px; 
    background-color: #1e293b !important; 
    border: 1px solid #334155;
    border-radius: 0 8px 8px 0; 
    box-shadow: 6px 6px 20px rgba(0, 0, 0, 0.4);
    list-style: none !important;
    padding: 6px 0 !important;
    margin: 0 !important;
    z-index: 9999 !important;

    /* 💡 [핵심 해결책] 가상 패딩 추가 */
    /* 서브메뉴 왼쪽에 눈에 보이지 않는 투명한 영역(15px)을 확장하여 */
    /* 마우스가 경계선을 지나갈 때 창이 절대 닫히지 않는 안전지대를 만듭니다. */
    padding-left: 15px !important; 
    margin-left: -15px !important;
}


/* 마우스 호버 시 딜레이 없이 0초 만에 즉시 켜지는 CSS */
.sidebar-list > li:hover .submenu {
    display: block !important;
}

.submenu li {
    padding: 0 !important;
    margin: 0 !important;
}

.submenu li a {
    display: block;
    padding: 10px 16px;
    font-size: 13px;
    font-weight: 500;
    color: #cbd5e1 !important;
    text-decoration: none !important;
    box-sizing: border-box;
}

/* ⭕ 하이라이트 배경색이 가상 패딩 영역까지 삐져나가지 않도록 라운딩 마감 보정 */
.submenu li a:hover {
    color: #ffffff !important;
    background-color: #0ea5e9 !important; 
    border-radius: 4px; /* 반전 영역을 깔끔하게 사각형으로 핏 */
}
/* 5. 메인 영상 페이지 레이아웃도 좁아진 사이드바 폭(150px)에 맞춰 왼쪽으로 추가 밀착 */
.control-content-wrapper {
    left: 150px !important; /* ⭕ 200px에서 150px로 당겨서 메인 화면 영역을 더 확보 */
    width: calc(100% - 150px) !important;
}
</style>
</head>
<body>
<main>
    <!-- 1. 좌측 고정 사이드바 메뉴 (초고속 즉시 반응형 실무 스킨) -->
    <nav>
        <ul class="sidebar-list">
            <!-- [그룹 1] 관리자 메뉴 -->
            <li>
                <a href="#">관리자 메뉴</a>
                <ul class="submenu">
                    <li><a href="<c:url value='/workflow/list'/>">결재 관리</a></li>
                    <li><a href="<c:url value='/member/list'/>">직원 관리</a></li>
                    <li><a href="<c:url value='/loginlog/list'/>">로그인 이력</a></li>
                    <li><a href="<c:url value='/commoncode/list'/>">시스템 코드</a></li>
                </ul>
            </li>
            
            <!-- [그룹 2] 보고서 등록 -->
            <li>
                <a href="#">보고서 등록</a>
                <ul class="submenu">
                    <li><a href="<c:url value='/patrolreport/list'/>">업무일지 목록</a></li>
                </ul>
            </li>
            
            <!-- [그룹 3] 드론관리 -->
            <li>
                <a href="#">드론관리</a>
                <ul class="submenu">
                    <li><a href="<c:url value='/flighthistory/list'/>">비행 이력</a></li>
                    <li><a href="<c:url value='/drone/list'/>">드론 관리</a></li>
                </ul>
            </li>
            
            <!-- [그룹 4] 이상관리 -->
            <li>
                <a href="#">이상관리</a>
                <ul class="submenu">
                    <li><a href="<c:url value='/alert/list'/>">경보 이력</a></li>
                    <li><a href="<c:url value='/detection/list'/>">탐지 이력</a></li>
                    <li><a href="<c:url value='/dangerlog/list'/>">이상객체 탐지 이력</a></li>
                    <li><a href="<c:url value='/dashboard/main'/>">통계 대시보드</a></li>
                </ul>
            </li>
            
            <!-- [그룹 5] 동물관리 -->
            <li>
                <a href="#">동물관리</a>
                <ul class="submenu">
                    <li><a href="<c:url value='/animal/list'/>">유기동물 관리</a></li>
                    <li><a href="<c:url value='/danger/list'/>">이상객체 관리</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <!-- 2. 실제 메인 콘텐츠 영역 가이드라인 보존선 -->
    <div class="control-content-wrapper">
        <!-- 메인 콘텐츠 배관 -->
    </div>
</main>
</body>
</html>
