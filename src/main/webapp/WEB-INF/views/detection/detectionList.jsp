<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>실시간 관제 탐지 이력</title>
<style>
/* 💡 탐지 스냅샷 미니 썸네일 전용 스타일 */
.mini-snapshot {
	width: 70px;
	height: 45px;
	border-radius: 4px; /* 모서리를 살짝 부드럽게 마감 */
	border: 1px solid #ddd;
	object-fit: cover; /* 비율 유지하며 꽉 차게 */
	vertical-align: middle;
}

.pagination li.active strong {
	font-weight: bold;
	color: red;
}
</style>
<style>
body {
	margin: 0;
	padding: 32px;
	background: #28283a;
	color: #fff;
	font-family: 'Malgun Gothic', sans-serif
}

h2 {
	margin: 0 0 24px;
	font-size: 26px;
	color: #fff
}

table {
	width: 100%;
	border-collapse: collapse;
	margin: 18px 0;
	background: #323244;
	box-shadow: 0 8px 24px rgba(0, 0, 0, .22)
}

th {
	padding: 15px 16px;
	background: #242434 !important;
	color: #b0b5c0;
	border: 0 !important;
	border-bottom: 2px solid #48485e !important;
	text-align: left
}

td {
	padding: 14px 16px;
	background: #323244;
	color: #fff;
	border: 0 !important;
	border-bottom: 1px solid #48485e !important
}

tr:hover td {
	background: #3a3a51
}

a {
	color: #68d6de;
	text-decoration: none
}

button {
	padding: 9px 16px;
	background: #6366f1;
	color: #fff;
	border: 0;
	border-radius: 6px;
	font-weight: 700;
	cursor: pointer
}

button:hover {
	background: #4f46e5
}

form {
	margin-top: 18px;
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
	align-items: center
}

input, select {
	padding: 8px 10px;
	background: #242434;
	color: #fff;
	border: 1px solid #48485e;
	border-radius: 5px
}

.pagination {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
	justify-content: center;
	margin: 22px 0 !important;
	padding: 0 !important
}

.pagination li {
	margin: 0 !important
}

.pagination a, .pagination strong {
	display: block;
	padding: 6px 10px;
	background: #242434;
	border-radius: 5px
}

.pagination .active strong {
	color: #00f0ff !important
}

@media ( max-width :760px) {
	body {
		padding: 20px
	}
	h2 {
		font-size: 22px
	}
	table {
		display: block;
		overflow-x: auto;
		white-space: nowrap
	}
}
</style>
<style>
body {
	padding: 100px 32px 32px 282px;
}

@media ( max-width : 760px) {
	body {
		padding: 84px 20px 20px 230px;
	}
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/menu.jsp" />
	<jsp:include page="/WEB-INF/views/header.jsp" />
	<h2>🛸 실시간 관제 탐지 이력 목록</h2>
	<br>

	<table border="1"
		style="border-collapse: collapse; text-align: center;">
		<thead>
			<tr style="background-color: #f2f2f2;">
				<th style="width: 80px; padding: 8px;">로그번호</th>
				<th style="width: 90px; padding: 8px;">스냅샷</th>
				<!-- 💡 캡쳐 화면 컬럼 신규 배치 -->
				<th style="width: 120px; padding: 8px;">드론 기체 ID</th>
				<th style="width: 150px; padding: 8px;">이상 객체 (축종)</th>
				<th style="width: 80px; padding: 8px;">개체수</th>
				<th style="width: 180px; padding: 8px;">탐지 시각</th>
				<th style="width: 100px; padding: 8px;">조치 상태</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${empty detectionList}">
					<tr>
						<td colspan="7" style="padding: 20px; color: gray;">포착된 실시간
							관제 탐지 이력이 없습니다.</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach var="detection" items="${detectionList}">
						<tr style="cursor: pointer;"
							onclick="return openDetailPopup('${pageContext.request.contextPath}/detection/detail?dlogId=${detection.dlogId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}', 'detectionDetail');">
							<td style="padding: 8px;">
								${detection.dlogId}
							</td>

							<!-- 💡 [추가] 컨트롤러의 getSnapshot 주소를 호출하여 물리 폴더 내부의 캡쳐 이미지 출력 -->
							<td style="padding: 4px;">
									<img
									src="${pageContext.request.contextPath}/detection/getSnapshot?dlogId=${detection.dlogId}"
									alt="탐지 스냅샷" class="mini-snapshot"
									onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';" />
							</td>

							<td style="padding: 8px;"><c:choose>
									<c:when test="${empty detection.droneId}">
										<span style="color: gray;">알수없음</span>
									</c:when>
									<c:otherwise>${detection.droneId}</c:otherwise>
								</c:choose></td>
							<td style="padding: 8px; font-weight: bold;"><c:out
									value="${detection.animalType}" /></td>
							<td style="padding: 8px;">${detection.detectCount}마리</td>
							<td style="padding: 8px;"><fmt:formatDate
									value="${detection.detectTime}" pattern="yyyy-MM-dd HH:mm:ss" />
							</td>
							<td style="padding: 8px;">
								<!-- 조치 상태 코드 매핑 (0: 미확인, 1: 조치중, 2: 조치완료) --> <c:choose>
									<c:when test="${detection.actionStatus == '0'}">
										<span style="color: red; font-weight: bold;">미확인</span>
									</c:when>
									<c:when test="${detection.actionStatus == '1'}">
										<span style="color: orange; font-weight: bold;">조치중</span>
									</c:when>
									<c:when test="${detection.actionStatus == '2'}">
										<span style="color: green; font-weight: bold;">조치완료</span>
									</c:when>
									<c:otherwise>${detection.actionStatus}</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>

	<!-- 페이징 버튼 영역 (기존 프로젝트 가이드 매핑) -->
	<div style="margin-top: 15px;">
		<ul class="pagination"
			style="display: flex; list-style: none; padding-left: 0;">
			<c:if test="${pageMaker.prev}">
				<li style="margin-right: 5px;"><a
					href="list?page=${pageMaker.startPage - 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">&laquo;
						이전</a></li>
			</c:if>

			<c:forEach var="pageNum" begin="${pageMaker.startPage}"
				end="${pageMaker.endPage}">
				<li class="${pageMaker.page == pageNum ? 'active' : ''}"
					style="margin-right: 5px;"><c:choose>
						<c:when test="${pageMaker.page == pageNum}">
							<strong style="color: red;">${pageNum}</strong>
						</c:when>
						<c:otherwise>
							<a
								href="list?page=${pageNum}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">${pageNum}</a>
						</c:otherwise>
					</c:choose></li>
			</c:forEach>

			<c:if test="${pageMaker.next}">
				<li style="margin-right: 5px;"><a
					href="list?page=${pageMaker.endPage + 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">다음
						&raquo;</a></li>
			</c:if>
		</ul>
	</div>

	<!-- 다조건 동적 검색 폼 영역 (a: 객체명, d: 드론ID, s: 조치상태) -->
	<form:form action="list" method="get">
		<select name="searchType">
			<option value="a" ${pageMaker.searchType == 'a' ? 'selected' : ''}>이상
				객체 이름</option>
			<option value="d" ${pageMaker.searchType == 'd' ? 'selected' : ''}>드론
				기체 ID</option>
			<option value="s" ${pageMaker.searchType == 's' ? 'selected' : ''}>조치
				상태 (코드)</option>
		</select>
		<input type="text" name="keyword" value="${pageMaker.keyword}"
			placeholder="검색어 입력">
		<button type="submit">검색</button>
	</form:form>
	<br>
	<a href="${pageContext.request.contextPath}/">메인으로</a>

</body>
<script>
	var msg = "${msg}";
	if (msg === "MODIFY_SUCCESS")
		alert("현장 상황 조치 내역이 성공적으로 업데이트되었습니다.");
</script>
</html>
