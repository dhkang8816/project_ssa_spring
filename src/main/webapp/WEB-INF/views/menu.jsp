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

</head>
<body>
	<main>
		<!-- 1. 좌측 고정 사이드바 메뉴 -->
		<nav>
			<div class="sidebar-header">
				<span class="main-tag">메뉴</span>
			</div>
			<!-- 깨진 ul/li 구조를 올바르게 감싸줍니다 -->
			<ul class="sidebar-list">
				<li><a href="#">관리자 메뉴</a>
					<ul class="submenu">
						<li><a href="<c:url value='/workflow/list'/>">결재 관리</a></li>
						<li><a href="<c:url value='/member/list'/>">직원 관리</a></li>
						<li><a href="<c:url value='/loginlog/list'/>">로그인 이력</a></li>
						<li><a href="<c:url value='/commoncode/list'/>">시스템 코드 등록</a></li>
					</ul></li>
				<li><a href="#">보고서 등록</a>
					<ul class="submenu">
						<li><a href="<c:url value='/patrolreport/list'/>">업무일지 목록</a></li>
					</ul></li>
				<li><a href="#">드론관리</a>
					<ul class="submenu">
						<li><a href="<c:url value='/flighthistory/list'/>">비행 이력</a></li>
						<li><a href="<c:url value='/drone/list'/>">드론 관리</a></li>
					</ul></li>
				<li><a href="#">이상관리</a>
					<ul class="submenu">
						<li><a href="<c:url value='/alert/list'/>">경보 이력</a></li>
						<li><a href="<c:url value='/detection/list'/>">탐지 이력</a></li>
						<li><a href="<c:url value='/dangerlog/list'/>">이상객체 탐지 이력</a></li>
						<li><a href="<c:url value='/dashboard/main'/>">통계 대시보드</a></li>
					</ul></li>
				<li><a href="#">동물관리</a>
					<ul class="submenu">
						<li><a href="<c:url value='/animal/list'/>">유기동물 관리</a></li>
						<li><a href="<c:url value='/danger/list'/>">이상객체 관리</a></li>
					</ul></li>
			</ul>
		</nav>

		<!-- 2. 실제 메인 콘텐츠가 뿌려질 영역 (여기에 본문 내용을 넣으세요) -->
		<div class="control-content-wrapper">
			<!--       <h2 class="section-title">유기동물 관제 대시보드</h2> -->
			<!-- 테이블이나 영상 스트리밍 화면이 이 자리에 들어옵니다 -->
		</div>
	</main>

</body>
</html>
