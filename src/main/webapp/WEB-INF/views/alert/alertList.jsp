<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<title>경보 이력 목록</title>
<style>
/* [1. 레이아웃 및 여백 규격] */
body {
	background-color: #0b0f19 !important; /* 깊은 사이버 다크 톤 강제 적용 */
	color: #e2e8f0 !important;
	font-family: 'Segoe UI', Roboto, 'Malgun Gothic', sans-serif;
	margin: 0;
	padding: 0;
	overflow-x: hidden;
}

/* 초슬림 사이드바 폭(150px)과 헤더 높이(80px)에 맞춰 정밀 좌측 밀착 정렬 */
.control-page-content {
	position: absolute !important;
	top: 80px !important;
	left: 150px !important;
	width: calc(100% - 150px) !important;
	padding: 30px 40px;
	box-sizing: border-box;
	z-index: 50 !important;
}

@media ( max-width : 760px) {
	.control-page-content {
		left: 0 !important;
		width: 100% !important;
		padding: 20px 16px;
	}
}

/* [2. 타이틀 및 카드 프레임 스킨] */
.panel {
	background: rgba(20, 26, 42, 0.85) !important;
	border: 1px solid #1e293b !important;
	border-radius: 16px;
	padding: 28px !important;
	box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
	backdrop-filter: blur(4px);
	width: 100%;
	box-sizing: border-box;
}

.panel h2 {
	color: #ffffff;
	margin: 0 0 24px 0 !important;
	font-size: 20px;
	font-weight: 700;
	letter-spacing: -0.02em;
	text-align: left;
}

/* 검색 상자 프레임 고도화 */
.search-box {
	margin: 20px 0;
	padding: 20px;
	background: rgba(17, 24, 39, 0.6) !important;
	border: 1px solid #1e293b !important;
	border-radius: 12px;
}

/* [3. 데이터 테이블(그리드) 마스크 정의] */
table {
	width: 100%;
	border-collapse: separate !important;
	border-spacing: 0 !important;
	margin-top: 16px;
	background-color: transparent !important;
	box-shadow: none !important;
	border: 1px solid #1e293b !important;
	border-radius: 8px;
	overflow: hidden;
}

th {
	background-color: #111827 !important; /* 다크 톤 일체화 */
	color: #38bdf8 !important; /* 네온 블루 컬러 각인 */
	padding: 14px 16px !important;
	font-size: 13px;
	font-weight: 700;
	text-align: center !important; /* 전체 중앙 정렬 */
	border: 0 !important;
	border-bottom: 2px solid #1e293b !important;
}

td {
	padding: 14px 16px !important;
	background-color: transparent !important;
	color: #cbd5e1 !important;
	font-size: 13.5px;
	text-align: center !important; /* 전체 중앙 정렬 */
	border: 0 !important;
	border-bottom: 1px solid #1e293b !important;
}

/* 행 호버 인터랙션 (0초 피드백) */
tr {
	transition: background-color 0s ease;
}

tbody tr:hover td {
	background-color: rgba(30, 41, 59, 0.6) !important;
	color: #ffffff !important;
}

.no-data {
	padding: 60px !important;
	color: #64748b !important;
	font-size: 14px;
}

/* [4. 조작 버튼 및 입력 UI 콤포넌트 모던화] */
form {
	display: flex;
	flex-wrap: wrap;
	gap: 12px;
	align-items: center;
	color: #cbd5e1;
	font-size: 13.5px;
}

input[type="text"], select {
	padding: 8px 12px;
	background: #111827 !important;
	color: #ffffff !important;
	border: 1px solid #334155 !important;
	border-radius: 6px;
	outline: none;
	font-size: 13.5px;
	transition: all 0.15s ease;
}

input[type="text"]:focus, select:focus {
	border-color: #0ea5e9 !important;
	box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25);
}

/* 관제 스킨용 네온 블루 링크 스타일 마스크 */
a {
	color: #38bdf8 !important;
	font-weight: 600;
	text-decoration: none !important;
	transition: color 0.15s ease;
}

a:hover {
	color: #7dd3fc !important;
	text-decoration: underline !important;
}

/* 검색 버튼: 선명한 네온 블루 스킨 */
button {
	padding: 9px 16px;
	background-color: #0ea5e9 !important;
	color: #ffffff !important;
	border: 0;
	border-radius: 8px !important;
	font-weight: 700;
	font-size: 13.5px;
	cursor: pointer;
	transition: all 0.15s ease;
}

button:hover {
	background-color: #0284c7 !important;
}

/* 연결 로그 없음: 차분한 비활성화 그레이 스킨 배지 */
.badge-none {
	color: #64748b !important;
	font-size: 13px;
}

/* [5. 하단 페이징 내비게이션 표준 규격] */
.pagination {
	display: flex;
	list-style: none;
	gap: 6px;
	justify-content: center;
	padding: 0;
	margin: 0 !important;
}

.pagination li {
	margin: 0 !important;
}

.pagination a, .pagination strong {
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

.pagination a:hover {
	color: #ffffff !important;
	background: #1f2937 !important;
	border-color: #334155;
}

/* 현재 활성화된 페이지 번호 강조색 (기존의 빨간색 스타일 파쇄 후 네온블루 결합) */
.pagination li.active strong, .pagination strong {
	color: #38bdf8 !important;
	background: rgba(14, 165, 233, 0.15) !important;
	border-color: #0ea5e9 !important;
}

@media ( max-width : 760px) {
	table {
		display: block;
		overflow-x: auto;
		white-space: nowrap;
	}
}
/* [4. 조작 버튼 및 입력 UI 콤포넌트 모던화 - 상세/처리 버튼 추가] */
a.btn-action-link {
	display: inline-block !important;
	padding: 6px 12px !important;
	background-color: #242b35 !important;
	border: 1px solid #3e4b5b !important;
	border-radius: 6px !important;
	color: #38bdf8 !important;
	font-size: 12px !important;
	font-weight: 600 !important;
	text-decoration: none !important;
	box-sizing: border-box !important;
	line-height: 1.2 !important;
	text-align: center !important;
	cursor: pointer !important;
	transition: all 0.15s ease !important;
}

/* 마우스 오버 시 파란색 하이라이트 강제 활성화 마스크 */
a.btn-action-link:hover {
	background-color: #0ea5e9 !important;
	border-color: #38bdf8 !important;
	color: #ffffff !important;
	text-decoration: none !important;
}

/* 직원관리 기준 목록 레이아웃 */
.panel {
	display: grid !important;
	grid-template-columns: minmax(180px, 1fr) auto;
	grid-template-areas: "title search" "summary action" "table table"
		"pager pager";
	gap: 20px;
	padding: 0 !important;
	background: transparent !important;
	border: 0 !important;
	box-shadow: none !important;
	overflow-x: auto;
}

.panel>h2 {
	grid-area: title;
	margin: 0 !important;
	padding: 0 0 16px;
	border-bottom: 1px solid #1e293b;
	color: #fff !important;
	font-size: 22px !important;
}

.panel>br {
	display: none;
}

.panel>.staff-list-summary {
	grid-area: summary;
	color: #94a3b8;
	font-size: 14px;
	font-weight: 500;
}

.panel>.staff-list-summary strong {
	color: #38bdf8;
	background: rgba(56, 189, 248, .1);
	border-radius: 4px;
	padding: 2px 6px;
}

.panel>.search-box {
	grid-area: search;
	justify-self: end;
	margin: 0 !important;
}

.panel>table {
	grid-area: table;
	min-width: 850px;
	margin: 0 !important;
}

.panel>table th, .panel>table td {
	white-space: nowrap;
}

.panel>div[style*="margin-top"] {
	grid-area: pager;
	justify-self: center;
	margin: 0 !important;
}

@media ( max-width :760px) {
	.panel {
		grid-template-columns: 1fr;
		grid-template-areas: "title" "search" "summary" "table" "pager"
	}
	.panel>.search-box {
		justify-self: stretch
	}
}
</style>
</head>
<body>
	<!-- 기존 레이아웃 시스템 인클루드 완벽 유지 -->
	<jsp:include page="/WEB-INF/views/menu.jsp" />
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<!-- 메인 관제 페이지 레이아웃 컨테이너 -->
	<div class="control-page-content">
		<div class="panel">

			<h2>시스템 경보 이력 목록</h2>


				<!-- 💡 기존 staff-summary-bar 부분을 이 코드로 통째로 교체 -->
				<div class="staff-summary-bar"
				     style="display: flex !important; justify-content: space-between !important; align-items: center !important; width: 100% !important; box-sizing: border-box !important; grid-column: 1 / -1 !important; line-height: 1.2 !important; height: auto !important; margin-bottom: 5px !important;">
				     
				    <!-- 왼쪽: 건수 레이어 (부트스트랩 강제 폰트 크기 초기화) -->
				    <div class="staff-count" style="display: inline-block !important; color: #94a3b8 !important; font-size: 14px !important; font-weight: 500 !important; margin: 0 !important; padding: 0 !important;">
				        총 <strong style="color: #38bdf8 !important;">${pageMaker.totalCount}</strong>건
				    </div>
				    
				    <!-- 오른쪽: 버튼 묶음 상자 (부트스트랩의 마진/패딩 침범 원천 차단) -->
				    <div class="summary-action-group"
				         style="display: flex !important; gap: 8px !important; align-items: center !important; float: none !important; margin: 0 !important; padding: 0 !important; height: auto !important;">
				         
				        <!-- 🌟 CSV 버튼: 부트스트랩의 버튼 스타일 강제 초기화 및 네온 블루 강제 정착 -->
				        <button class="csv-download-btn neon-theme"
		                onclick="downloadTableAsCsv('#alertTable', 'alert-list')"
				                style="float: none !important; margin: 0 !important; display: inline-flex !important; align-items: center !important; justify-content: center !important; white-space: nowrap !important; box-sizing: border-box !important; height: 36px !important; padding: 0 16px !important; line-height: 1 !important; border-radius: 6px !important;">
				            <i class="fa-solid fa-file-csv" style="font-size: 14px; margin: 0 !important; padding: 0 !important;"></i> CSV
				        </button>
				    </div>
				</div>


			<!-- 하이테크 스킨 데이터 테이블 그리드 -->
			<table id="alertTable" data-csv-export data-csv-filename="alert-list">
				<thead>
					<tr>
						<th>경보번호</th>
						<th>경보대상구분</th>
						<th>연결 로그</th>
						<th>경보알림메세지내용</th>
						<th>전송성공여부</th>
						<th>최초경보시각</th>
						<th>경보전송일시</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${empty alertList}">
							<tr>
								<td colspan="7" class="no-data">조회된 경보 이력 데이터가 없습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="alert" items="${alertList}">
								<tr>
									<!-- 1. 경보번호 (상세보기 이동 링크 + 페이징/검색 상태 유지 보존) -->
									<td style="font-weight: bold;"><a data-detail-popup
										data-popup-name="alertDetail"
										href="${pageContext.request.contextPath}/alert/alertDetail?alertId=${alert.alertId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">
											${alert.alertId} </a></td>

									<!-- 2. 경보대상구분 -->
									<td>${alert.alertType}</td>

									<!-- 3. 연결 로그 분석 구조 바인딩 (클래스 기반 대시보드 스킨 전환) -->
									<td><c:choose>
											<c:when test="${not empty alert.dlogId}">
												<a class="btn-action-link" data-detail-popup
													data-popup-name="detectionDetail"
													href="${pageContext.request.contextPath}/detection/detail?dlogId=${alert.dlogId}">
													일반 탐지 #${alert.dlogId} </a>
											</c:when>
											<c:when test="${not empty alert.danlogId}">
												<a class="btn-action-link" data-detail-popup
													data-popup-name="dangerLogDetail"
													href="${pageContext.request.contextPath}/dangerlog/detail?danlogId=${alert.danlogId}">
													이상객체 #${alert.danlogId} </a>
											</c:when>
											<c:otherwise>
												<span class="badge-none"
													style="color: #64748b !important; font-size: 13px !important;">연결
													로그 없음</span>
											</c:otherwise>
										</c:choose></td>


									<!-- 4. 알림 메시지 내용 -->
									<td style="text-align: left;"><c:out
											value="${alert.alertMsg}" /></td>

									<!-- 5. 전송성공여부 -->
									<td>${alert.sendStatus}</td>

									<!-- 6. 최초경보시각 (TIMESTAMP 포맷팅) -->
									<td><fmt:formatDate value="${alert.firstSendTime}"
											pattern="yyyy-MM-dd HH:mm:ss" /></td>

									<!-- 7. 경보전송일시 (DATE 포맷팅) -->
									<td><fmt:formatDate value="${alert.sendDate}"
											pattern="yyyy-MM-dd HH:mm:ss" /></td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
			<!-- 검색 폼 영역 (스프링 폼 태그 및 AlertLogMapper 검색 조건 연동 완벽 보존) -->
			<div class="search-box">
				<form:form action="list" method="get">
					<select name="searchType" id="alertSearchType"
						onchange="toggleAlertKeywordInput();">
						<option value=""
							${pageMaker.searchType == null or pageMaker.searchType == '' ? 'selected' : ''}>전체</option>
						<option value="type"
							${pageMaker.searchType == 'type' ? 'selected' : ''}>경보대상구분</option>
						<option value="msg"
							${pageMaker.searchType == 'msg' ? 'selected' : ''}>경보메세지</option>
					</select>
					<select name="keyword" id="alertTypeKeyword"
						${pageMaker.searchType == 'msg' ? 'disabled' : ''}>
						<option value="">전체 유형</option>
						<option value="1" ${pageMaker.keyword == '1' ? 'selected' : ''}>이상객체</option>
						<option value="0" ${pageMaker.keyword == '0' ? 'selected' : ''}>개체미달</option>
					</select>
					<input type="text" name="keyword" id="alertMessageKeyword"
						value="${pageMaker.searchType == 'msg' ? pageMaker.keyword : ''}"
						placeholder="경보 메시지 검색"
						${pageMaker.searchType == 'msg' ? '' : 'disabled'}>
					<button type="submit" class="btn-search">검색</button>
				</form:form>
			</div>
			<script>
				function toggleAlertKeywordInput() {
					var isMessageSearch = document
							.getElementById('alertSearchType').value === 'msg';
					document.getElementById('alertTypeKeyword').disabled = isMessageSearch;
					document.getElementById('alertMessageKeyword').disabled = !isMessageSearch;
				}
			</script>
			<!-- 하단 페이징 버튼 영역 (보내주신 수식 로직 및 strong 분기 완벽 매핑) -->
			<div style="margin-top: 25px;">
				<ul class="pagination">
					<!-- 이전 버튼 -->
					<c:if test="${pageMaker.prev}">
						<li><a
							href="list?page=${pageMaker.startPage - 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">&laquo;
								이전</a></li>
					</c:if>

					<!-- 페이지 번호 루프 -->
					<c:forEach var="pageNum" begin="${pageMaker.startPage}"
						end="${pageMaker.endPage}">
						<li class="${pageMaker.page == pageNum ? 'active' : ''}"><c:choose>
								<c:when test="${pageMaker.page == pageNum}">
									<!-- 기존 빨간색 스타일을 파쇄하고 대시보드 정체성 네온블루 결합 -->
									<strong>${pageNum}</strong>
								</c:when>
								<c:otherwise>
									<a
										href="list?page=${pageNum}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">${pageNum}</a>
								</c:otherwise>
							</c:choose></li>
					</c:forEach>

					<!-- 다음 버튼 -->
					<c:if test="${pageMaker.next}">
						<li><a
							href="list?page=${pageMaker.endPage + 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">다음
								&raquo;</a></li>
					</c:if>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>
