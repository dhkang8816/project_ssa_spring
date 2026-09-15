<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>드론 관리 목록</title>
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
	margin: 0 0 6px 0 !important;
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

/* 텍스트 및 일반 링크 */
a.main-link {
	color: #38bdf8 !important;
	font-weight: 600;
	text-decoration: none;
	display: inline-block;
	margin-top: 20px;
	transition: color 0.15s ease;
}

a.main-link:hover {
	color: #7dd3fc !important;
	text-decoration: underline !important;
}

/* 액션 단추 (조작 버튼) */
button {
	padding: 9px 16px;
	border: 0;
	border-radius: 8px !important;
	font-weight: 700;
	font-size: 13.5px;
	cursor: pointer;
	transition: all 0.15s ease;
}

/* 신규 등록 액션: 청량한 네온 그린 스킨 */
button.btn-register {
	background-color: #10b981 !important;
	color: #ffffff !important;
}

button.btn-register:hover {
	background-color: #059669 !important;
}

/* 검색 버튼: 선명한 네온 블루 스킨 */
button.btn-search {
	background-color: #0ea5e9 !important;
	color: #ffffff !important;
}

button.btn-search:hover {
	background-color: #0284c7 !important;
}

/* [5. 공통 알약 배지(Badge) 정의] */
.badge-status {
	padding: 4px 12px !important;
	border-radius: 20px !important;
	font-size: 11.5px !important;
	font-weight: 700 !important;
	display: inline-block;
}

/* 배정 대기 및 미배정: 반투명 오렌지 패널 핏 */
.badge-status.pending {
	background-color: rgba(245, 158, 11, 0.15) !important;
	color: #f59e0b !important;
	border: 1px solid rgba(245, 158, 11, 0.3) !important;
}

/* [6. 하단 페이징 내비게이션 표준 규격] */
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

/* 현재 활성화된 페이지 번호 */
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
/* 직원관리 기준 목록 레이아웃 */
.panel { display: grid !important; grid-template-columns: minmax(180px, 1fr) auto; grid-template-areas: "title search" "summary action" "table table" "pager pager"; gap: 20px; padding: 0 !important; background: transparent !important; border: 0 !important; box-shadow: none !important; overflow-x: auto; }
.panel > h2 { grid-area: title; margin: 0 !important; padding: 0 0 16px; border-bottom: 1px solid #1e293b; color: #fff !important; font-size: 22px !important; }.panel > br { display: none; }
.panel > .staff-list-summary { grid-area: summary; color: #94a3b8; font-size: 14px; font-weight: 500; }.panel > .staff-list-summary strong { color: #38bdf8; background: rgba(56,189,248,.1); border-radius: 4px; padding: 2px 6px; }
.panel > .search-box, .panel > form { grid-area: search; justify-self: end; margin: 0 !important; }.panel > .btn-register { grid-area: action; justify-self: end; margin: 0 !important; }.panel > table { grid-area: table; min-width: 850px; margin: 0 !important; }.panel > table th, .panel > table td { white-space: nowrap; }.panel > div[style*="margin-top"], .panel > .pagination { grid-area: pager; justify-self: center; margin: 0 !important; }
@media (max-width: 760px) { .panel { grid-template-columns: 1fr; grid-template-areas: "title" "search" "summary" "action" "table" "pager"; } .panel > form, .panel > .btn-register { justify-self: stretch; } }
</style>
</head>
<body>
	<!-- 기존 상단/사이드바 디자인 무결점 유지 인클루드 -->
	<jsp:include page="/WEB-INF/views/menu.jsp" />
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<!-- 메인 관제 페이지 레이아웃 영역 -->
	<div class="control-page-content">
		<div class="panel">

			<h2>드론 관리 목록</h2>
			<div class="staff-list-summary">총 <strong>${pageMaker.totalCount}</strong>건</div>

			<!-- 신규 드론 등록 액션 단추 배정 (네온 그린 커스텀 탑재) -->
			<div style="margin-bottom: 15px; text-align: right;">
			    <button type="button" class="btn-register"
			        onclick="return openFormPopup('${pageContext.request.contextPath}/drone/register', 'droneRegister');">
			        신규 드론 등록</button>
			</div>

			<!-- 하이테크 스킨 기반 데이터 테이블 -->
			<table data-csv-export data-csv-filename="drone-list">
				<thead>
					<tr>
						<th style="width: 50%;">드론 기체 ID</th>
						<th style="width: 50%;">담당 관제원 사번</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${empty droneList}">
							<tr>
								<td colspan="2" class="no-data">등록된 드론 기체가 없습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="drone" items="${droneList}">
								<!-- 기존 상세 조회 팝업 자바스크립트 호출 경로 무결점 보존 -->
								<tr style="cursor: pointer;"
									onclick="return openDetailPopup('${pageContext.request.contextPath}/drone/detail?droneId=${drone.droneId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}', 'droneDetail');">
									<td>${drone.droneId}</td>
									<td><c:choose>
											<c:when test="${empty drone.memberId}">
												<!-- 기존 텍스트 구문을 타원형 미배정 알약 배지로 전면 치환 -->
												<span class="badge-status pending">미배정</span>
											</c:when>
											<c:otherwise>${drone.memberId}</c:otherwise>
										</c:choose></td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
			<!-- 검색 폼 영역 (d: 드론ID, m: 담당사번) -->
			<form:form action="list" method="get">
				<select name="searchType">
					<option value="d" ${pageMaker.searchType == 'd' ? 'selected' : ''}>드론
						기체 ID</option>
					<option value="m" ${pageMaker.searchType == 'm' ? 'selected' : ''}>담당
						사번</option>
				</select>
				<input type="text" name="keyword" value="${pageMaker.keyword}"
					placeholder="검색어 입력">
				<button type="submit">검색</button>
			</form:form>
			<!-- 하단 페이징 랙 매핑 분기 -->
			<div style="margin-top: 25px;">
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
		</div>
	</div>
</body>
<script>
	var msg = "${msg}";
	if (msg === "REGISTER_SUCCESS")
		alert("신규 드론 기체가 등록되었습니다.");
	if (msg === "MODIFY_SUCCESS")
		alert("드론 배정 정보가 수정되었습니다.");
	if (msg === "REMOVE_SUCCESS")
		alert("드론 기체 정보가 삭제되었습니다.");
</script>
</html>
