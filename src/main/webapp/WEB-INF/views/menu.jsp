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

nav {
    position: fixed !important;
    top: 80px !important; 
    left: 0 !important;
    width: 150px !important; 
    height: calc(100vh - 80px) !important;
    background-color: #111827 !important; 
    border-right: 1px solid #1e293b;
    box-shadow: 4px 0 20px rgba(0, 0, 0, 0.25);
    box-sizing: border-box;
    overflow-y: auto;
    z-index: 900 !important;
}


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


.sidebar-list > li > a {
    display: block;
    padding: 14px 14px; 
    font-size: 14px;
    font-weight: 600;
    color: #94a3b8 !important; 
    text-decoration: none !important;
    border-left: 4px solid transparent; 
    box-sizing: border-box;
    cursor: pointer;
}


.sidebar-list > li:hover > a {
    color: #38bdf8 !important; 
    background: linear-gradient(90deg, rgba(14, 165, 233, 0.15) 0%, rgba(14, 165, 233, 0) 100%); 
    border-left: 4px solid #38bdf8; 
}



.submenu {
    display: none; 
    position: absolute;
    top: 0;
    left: 149px; 
    width: 160px; 
    background-color: #1e293b !important; 
    border: 1px solid #334155;
    border-radius: 0 8px 8px 0; 
    box-shadow: 6px 6px 20px rgba(0, 0, 0, 0.4);
    list-style: none !important;
    padding: 6px 0 !important;
    margin: 0 !important;
    z-index: 9999 !important;

    
    
    
    padding-left: 15px !important; 
    margin-left: -15px !important;
}



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


.submenu li a:hover {
    color: #ffffff !important;
    background-color: #0ea5e9 !important; 
    border-radius: 4px; 
}

.control-content-wrapper {
    left: 150px !important; 
    width: calc(100% - 150px) !important;
}
</style>
</head>
<body>
<main>
    
    <nav>
        <ul class="sidebar-list">
            
            <li>
                <a href="#">관리자 메뉴</a>
                <ul class="submenu">
                    <li><a href="<c:url value='/workflow/list'/>">결재 관리</a></li>
                    <li><a href="<c:url value='/member/list'/>">직원 관리</a></li>
                    <li><a href="<c:url value='/loginlog/list'/>">로그인 이력</a></li>
                    <li><a href="<c:url value='/commoncode/list'/>">시스템 코드</a></li>
                </ul>
            </li>
            
            
            <li>
                <a href="#">보고서 등록</a>
                <ul class="submenu">
                    <li><a href="<c:url value='/patrolreport/list'/>">업무일지 목록</a></li>
                </ul>
            </li>
            
            
            <li>
                <a href="#">드론관리</a>
                <ul class="submenu">
                    <li><a href="<c:url value='/flighthistory/list'/>">비행 이력</a></li>
                    <li><a href="<c:url value='/drone/list'/>">드론 관리</a></li>
                </ul>
            </li>
            
            
            <li>
                <a href="#">이상관리</a>
                <ul class="submenu">
                    <li><a href="<c:url value='/alert/list'/>">경보 이력</a></li>
                    <li><a href="<c:url value='/detection/list'/>">탐지 이력</a></li>
                    <li><a href="<c:url value='/dangerlog/list'/>">이상객체 탐지 이력</a></li>
                    <li><a href="<c:url value='/dashboard/main'/>">통계 대시보드</a></li>
                </ul>
            </li>
            
            
            <li>
                <a href="#">동물관리</a>
                <ul class="submenu">
                    <li><a href="<c:url value='/animal/list'/>">유기동물 관리</a></li>
                    <li><a href="<c:url value='/danger/list'/>">이상객체 관리</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    
    <div class="control-content-wrapper">
        
    </div>
</main>
</body>
</html>
