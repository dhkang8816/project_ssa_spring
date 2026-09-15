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
<title>시스템 로그인 이력</title>
<!-- 다크 네이비 테마 style.css 연동 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/style.css">
<style>
/* 1. 글로벌 바디 레이아웃 셋업 */
body {
	background-color: #0b0f19 !important; /* 깊은 사이버 다크 톤 강제 고정 */
	color: #e2e8f0 !important;
	font-family: 'Segoe UI', Roboto, sans-serif;
	margin: 0;
	padding: 0;
	overflow-x: hidden;
}

/* 2. [구조 대개편] 150px 초슬림 사이드바와 완벽한 밀착 정렬 싱크 보정 */
.main-container {
	display: block !important; /* 기존 flex 레이아웃으로 인한 엇박자 꼬임 파쇄 */
	margin-top: 0 !important;
}

#menu-placeholder {
	display: none !important;
	width: 0 !important;
}

/* 실제 우측 본문 영역을 150px 내비게이션 바로 우측에 완전 자석 정렬 */
.content-area {
	position: absolute !important;
	top: 80px !important; /* 상단 고정 헤더 높이만큼 정확히 확보 */
	left: 150px !important; /* ⭕ 얇아진 150px 메뉴바 경계선에 완벽 밀착 */
	width: calc(100% - 150px) !important; /* 우측 남은 잔여 공간 100% 흡수 */
	padding: 30px 40px !important;
	background: transparent !important;
	box-sizing: border-box;
	z-index: 50 !important;
}

@media ( max-width : 760px) {
	.content-area {
		left: 0 !important;
		width: 100% !important;
		padding: 20px 16px !important;
	}
}

/* 3. 상단 대타이틀 영역 스타일링 */
.staff-top-bar, .staff-summary-bar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
	gap: 16px;
	width: 100%;
}

.staff-top-bar .page-title {
	margin: 0;
	color: #ffffff !important;
	font-size: 22px;
	font-weight: 700;
	letter-spacing: -0.02em;
}

/* 4. 요약 정보 가독성 증폭 */
.staff-count {
	color: #94a3b8 !important;
	font-size: 14px;
	font-weight: 500;
}

.staff-count .count-num {
	color: #38bdf8 !important; /* 스카이블루 관제 브랜드 스킨 컬러 각인 */
	font-weight: 700;
	background: rgba(56, 189, 248, 0.1);
	padding: 2px 6px;
	border-radius: 4px;
}

/* 5. 와이드 관제 데이터 그리드 프레임 테마 */
.staff-table-wrapper {
	overflow-x: auto;
	overflow-y: hidden;
	border-radius: 12px !important;
	background: rgba(20, 26, 42, 0.85) !important; /* 반투명 글래스 패널 */
	border: 1px solid #1e293b !important;
	box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4) !important;
	width: 100%;
}

.staff-table {
	width: 100%;
	min-width: 760px;
	border-collapse: separate !important;
	border-spacing: 0 !important;
}

.staff-table th {
	white-space: nowrap;
	padding: 14px 16px !important;
	background: #111827 !important; /* 사이드바 뼈대 다크 톤과 완전 동기화 */
	border-bottom: 2px solid #1e293b !important;
	color: #38bdf8 !important; /* 열 레이블 상단 스카이블루 일체화 */
	font-size: 13px;
	font-weight: 700;
	text-align: center !important; /* 가시성을 극대화하기 위한 전체 중앙 가이드 고정 */
}

.staff-table td {
	white-space: nowrap;
	padding: 14px 16px !important;
	background: transparent !important;
	border-bottom: 1px solid #1e293b !important;
	color: #cbd5e1 !important;
	font-size: 13.5px;
	text-align: center !important; /* 균형 정렬 고정 */
}

/* 리스트 행 순회 스캔 모션 즉시 피드백 */
.staff-table tbody tr {
	transition: background-color 0.15s ease;
}

.staff-table tbody tr:hover td {
	background-color: rgba(30, 41, 59, 0.6) !important;
	color: #ffffff !important;
}

/* 6. [디자인 개량] 기존의 텍스트 색상을 모던 신호등 알약 배지 콤포넌트로 업그레이드 */
.badge-status {
	padding: 4px 12px !important;
	border-radius: 20px !important; /* 완벽한 타원 알약 핏 마감 */
	font-size: 11.5px !important;
	font-weight: 700 !important;
	display: inline-block;
}

.status-success {
	background-color: rgba(16, 185, 129, 0.15) !important;
	color: #10b981 !important;
	border: 1px solid rgba(16, 185, 129, 0.3) !important;
} /* 로그인 성공 */
.status-fail {
	background-color: rgba(239, 68, 68, 0.15) !important;
	color: #ef4444 !important;
	border: 1px solid rgba(239, 68, 68, 0.3) !important;
} /* 로그인 실패 */

/* 7. 중앙 하단 페이징 내비게이션 랙 */
.loginlog-pagination {
	display: flex;
	justify-content: center;
	margin-top: 25px;
	width: 100%;
}

.pagination {
	display: flex;
	list-style: none;
	padding-left: 0;
	gap: 6px;
	margin: 0;
}

.pagination li a, .pagination li strong {
	display: block;
	padding: 6px 12px;
	background: #111827 !important;
	color: #94a3b8 !important;
	border: 1px solid #1e293b;
	border-radius: 6px;
	text-decoration: none;
	font-size: 13px;
	font-weight: 600;
	transition: all 0.15s;
}

.pagination li a:hover {
	color: #ffffff !important;
	background: #1f2937 !important;
	border-color: #334155;
}
/* 페이징 활성화 번호 강조 */
.pagination li.active strong {
	color: #38bdf8 !important;
	background: rgba(14, 165, 233, 0.15) !important;
	border-color: #0ea5e9 !important;
}

/* 8. 다조건 하단 검색 폼 랙 모던화 */
.search-form-bar form {
	display: flex;
	gap: 6px;
	align-items: center;
	justify-content: center;
}

.search-form-bar select {
	padding: 9px 12px !important;
	background-color: #111827 !important;
	color: #ffffff !important;
	border: 1px solid #334155 !important;
	border-radius: 8px !important;
	font-size: 13.5px;
	outline: none;
}

.search-form-bar .search-input {
	width: 200px !important;
	padding: 9px 16px !important;
	background: #111827 !important;
	border: 1px solid #334155 !important;
	border-radius: 8px !important;
	color: #ffffff !important;
	font-size: 13.5px;
	outline: none;
}

.search-form-bar .search-input:focus {
	border-color: #0ea5e9 !important;
	box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25);
}

/* 검색 제출용 블루 단추 */
.btn-search-submit {
	padding: 9px 18px !important;
	border: 0 !important;
	border-radius: 8px !important;
	background: #0ea5e9 !important;
	color: #ffffff !important;
	font-weight: 700;
	font-size: 13.5px;
	cursor: pointer;
	transition: all 0.15s ease;
}

.btn-search-submit:hover {
	background: #0284c7 !important;
	transform: translateY(-1px);
}
</style>
</head>
<body class="login-page">

	<!-- 1. 가장 상단 공통 네온 헤더 바 조립 -->
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div class="main-container">
		<!-- 2. 좌측 슬림 메뉴바 조립 -->
		<jsp:include page="/WEB-INF/views/menu.jsp" />

		<!-- 3. 우측 본문 콘텐츠 영역 연동 -->
		<main class="content-area">

			<!-- 상단 바 구역 -->
			<div class="staff-top-bar">
				<h2 class="page-title">로그인 인증 이력</h2>
			</div>

			<!-- 테이블 요약 정보 구역 -->
			<div class="staff-summary-bar">
				<div class="staff-count">
					전체 이력 수: <span class="count-num">${pageMaker.totalCount}</span> 건
				</div>
				<button class="csv-download-btn neon-theme"
					onclick="downloadTableAsCsv('#loginLogTable', 'login-log-list')">
					<i class="fa-solid fa-file-csv" style="font-size: 14px;"></i> CSV
				</button>
			</div>

			<!-- 메인 데이터 테이블 프레임 랙 -->
			<div class="staff-table-wrapper">
				<table id="loginLogTable" class="staff-table" data-csv-export
					data-csv-filename="login-log-list">
					<thead>
						<tr>
							<th style="width: 120px;">로그 번호</th>
							<th style="width: 180px;">사번(아이디)</th>
							<th>요청 IP 주소</th>
							<th>로그인 시도 일시</th>
							<th style="width: 150px;">인증 결과</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${empty loginLogList}">
								<tr>
									<td colspan="5"
										style="color: #64748b; padding: 60px; font-size: 14px;">기록된
										로그인 인증 이력이 존재하지 않습니다.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="log" items="${loginLogList}">
									<tr>
										<td><strong>${log.logId}</strong></td>
										<td style="color: #38bdf8; font-weight: 600;"><c:out
												value="${log.memberId}" /></td>
										<td><code>${log.loginIp}</code></td>
										<td><fmt:formatDate value="${log.loginDate}"
												pattern="yyyy-MM-dd HH:mm:ss" /></td>
										<td>
											<!-- ⭕ 기존 컬러 텍스트 구문을 세련된 알약 배지 콤포넌트 형태로 전면 보정 --> <c:choose>
												<c:when test="${log.loginStatus eq 'SUCCESS'}">
													<span class="badge-status status-success">성공</span>
												</c:when>
												<c:otherwise>
													<span class="badge-status status-fail">실패</span>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
			<!-- .staff-table-wrapper END -->

			<!-- 페이징 내비게이션 영역 (⭕ 정위치 마크업 결합 완수) -->
			<div class="loginlog-pagination">
				<ul class="pagination">
					<c:if test="${pageMaker.prev}">
						<li><a
							href="list?page=${pageMaker.startPage - 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">&laquo;
								이전</a></li>
					</c:if>
					<c:forEach var="pageNum" begin="${pageMaker.startPage}"
						end="${pageMaker.endPage}">
						<li class="${pageMaker.page == pageNum ? 'active' : ''}"><c:choose>
								<c:when test="${pageMaker.page == pageNum}">
									<strong>${pageNum}</strong>
								</c:when>
								<c:otherwise>
									<a
										href="list?page=${pageNum}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">${pageNum}</a>
								</c:otherwise>
							</c:choose></li>
					</c:forEach>
					<c:if test="${pageMaker.next}">
						<li><a
							href="list?page=${pageMaker.endPage + 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">다음
								&raquo;</a></li>
					</c:if>
				</ul>
			</div>

			<!-- 다조건 하단 검색 폼 구역 (⭕ 모던 하이테크 스킨 피팅) -->
			<div class="search-form-bar" style="margin-top: 25px;">
				<form:form action="list" method="get">
					<select name="searchType">
						<option value="m" ${pageMaker.searchType == 'm' ? 'selected' : ''}>사번</option>
						<option value="s" ${pageMaker.searchType == 's' ? 'selected' : ''}>결과
							상태</option>
					</select>
					<input type="text" name="keyword" value="${pageMaker.keyword}"
						class="search-input" placeholder="검색어 입력">
					<button type="submit" class="btn-search-submit">검색</button>
				</form:form>
			</div>

		</main>
	</div>

	<!-- 정적 자원 로딩 마감 (오리지널 링크 무결성 유지) -->
	<script
		src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
</body>
</html>
