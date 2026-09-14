<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>시스템 로그인 이력</title>
<!-- 다크 네이비 테마 style.css 연동 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/style.css">
<style>
.status-success {
	color: #2b8a3e;
	font-weight: bold;
}

.status-fail {
	color: #e03131;
	font-weight: bold;
}
/* 페이징 간이 서식 */
.pagination {
	display: flex;
	list-style: none;
	padding-left: 0;
	margin-top: 20px;
	gap: 5px;
}

.pagination li.active strong {
	display: block;
	padding: 6px 10px;
	border-radius: 5px;
	background: #00a8a8;
	color: #ffffff;
	font-weight: bold;
}

.loginlog-pagination {
	display: flex;
	justify-content: center;
	margin-top: 24px;
}

.loginlog-pagination .pagination {
	margin: 0;
	flex-wrap: wrap;
	justify-content: center;
}

.loginlog-pagination .pagination a {
	display: block;
	padding: 6px 10px;
	border-radius: 5px;
	background: #242434;
	color: #ffffff;
	text-decoration: none;
}

.loginlog-pagination .pagination a:hover {
	background: #35354b;
	color: #5ddcff;
}

/* ★ 상단 여백 제거 및 밀어올리기 서식 추가 ★ */
main.content-area {
	margin-top: 0px !important; /* 공통 CSS에 잡힌 80px 마진 강제 파괴 */
	padding-top: 20px !important; /* 본문 안쪽 상단 여백을 최소한으로 조절 */
}

.staff-top-bar {
	margin-top: 0px !important;
	margin-bottom: 15px !important; /* 아래 요소와의 간격만 유지 */
}
</style>
<style>
body {
	background: #28283a;
}

.main-container {
	display: flex;
	min-height: calc(100vh - 80px);
	margin-top: 80px;
}

#menu-placeholder {
	width: 250px;
	flex-shrink: 0;
}

.content-area {
	flex: 1;
	padding: 40px;
	background: #28283a;
	color: #fff;
}

.staff-top-bar, .staff-summary-bar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 25px;
	gap: 16px;
}

.staff-top-bar .page-title {
	margin: 0;
	color: #fff;
	font-size: 26px;
}

.staff-count {
	color: #b0b5c0
}

.staff-count .count-num {
	color: #68b8bd;
	font-weight: 700
}

.staff-table-wrapper {
	overflow: auto;
	border-radius: 12px;
	background: #3e3e55;
	box-shadow: 0 8px 24px rgba(0, 0, 0, .3);
}

.staff-table {
	width: 100%;
	min-width: 760px;
	border-collapse: collapse;
}

.staff-table th {
	padding: 18px 20px;
	background: #242434;
	border-bottom: 2px solid #48485e;
	color: #b0b5c0;
	text-align: left;
}

.staff-table td {
	padding: 16px 20px;
	background: #323244;
	border-bottom: 1px solid #48485e;
	color: #fff;
}

@media ( max-width :760px) {
	.main-container {
		margin-top: 64px
	}
	.content-area {
		padding: 20px
	}
	#menu-placeholder {
		width: 210px;
	}
}
</style>
</head>
<body>

	<!-- 💡 [교정] 태그 끝에 명확하게 슬래시(/)를 닫아 표준 액션 규격 준수 및 파싱 크래시 해결 -->
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div class="main-container">
		<!-- 💡 [교정] 메뉴 인클루드 태그 역시 단독 태그 종결자(/) 명시 완료 -->
		<jsp:include page="/WEB-INF/views/menu.jsp" />
		<div id="menu-placeholder"></div>
		<!-- 본문 레이아웃 구역 -->
		<main class="content-area">

			<!-- 상단 바 구역 -->
			<div class="staff-top-bar">
				<h2 class="page-title">🔐 시스템 로그인 인증 이력</h2>
			</div>

			<!-- 테이블 요약 정보 및 조작 바 구역 -->
			<div class="staff-summary-bar">
				<div class="staff-count">
					전체 이력 수: <span class="count-num">${pageMaker.totalCount}</span> 건
				</div>
			</div>

			<!-- 테이블 둥근 모서리 래퍼와 실물 스타일 서식 매핑 -->
			<div class="staff-table-wrapper">
				<table class="staff-table">
					<thead>
						<tr>
							<th style="width: 100px;">로그 번호</th>
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
										style="text-align: center; color: #b0b5c0; padding: 30px;">
										기록된 로그인 인증 이력이 존재하지 않습니다.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="log" items="${loginLogList}">
									<tr>
										<td>${log.logId}</td>
										<td style="font-weight: bold;"><c:out
												value="${log.memberId}" /></td>
										<td>${log.loginIp}</td>
										<td><fmt:formatDate value="${log.loginDate}"
												pattern="yyyy-MM-dd HH:mm:ss" /></td>
										<td><c:choose>
												<c:when test="${log.loginStatus eq 'SUCCESS'}">
													<span class="status-success">성공</span>
												</c:when>
												<c:otherwise>
													<span class="status-fail">실패</span>
												</c:otherwise>
											</c:choose></td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>

			<!-- 페이징 내비게이션 영역 -->
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

			<!-- 다조건 하단 검색 폼 구역 -->
			<div style="margin-top: 25px;">
				<form:form action="list" method="get">
					<select name="searchType"
						style="padding: 8px; background: #242434; color: #fff; border: 1px solid #48485e; border-radius: 4px;">
						<option value="m" ${pageMaker.searchType == 'm' ? 'selected' : ''}>사번</option>
						<option value="s" ${pageMaker.searchType == 's' ? 'selected' : ''}>결과
							상태</option>
					</select>
					<input type="text" name="keyword" value="${pageMaker.keyword}"
						class="search-input" placeholder="검색어 입력"
						style="width: 200px; border-radius: 4px; border: 1px solid #48485e; padding: 7px;">
					<button type="submit" class="staff-register-btn"
						style="padding: 8px 16px; border-radius: 4px;">검색</button>
				</form:form>
			</div>

		</main>
	</div>

	<!-- 정적 자원 로딩 마감 -->
	<script
		src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
</body>
</html>
