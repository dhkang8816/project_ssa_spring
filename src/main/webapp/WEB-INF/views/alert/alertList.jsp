<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>경보 이력 목록</title>
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
	<h2>시스템 경보 이력 목록 화면</h2>

	<!-- 버튼 및 상단 영역 -->
	<div style="margin-bottom: 10px;">
		<button type="button"
			onclick="location.href='${pageContext.request.contextPath}/alert/register'">수동
			경보 등록</button>
	</div>

	<!-- 데이터 테이블 리스트 -->
	<table border="1">
		<thead>
			<tr>
				<th>경보번호</th>
				<th>경보대상구분</th>
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
						<td colspan="6" align="center">조회된 경보 이력 데이터가 없습니다.</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach var="alert" items="${alertList}">
						<tr>
							<!-- 1. 경보번호 (상세보기 이동 링크 + 페이징/검색 상태 유지) -->
							<td><a
								href="${pageContext.request.contextPath}/alert/alertDetail?alertId=${alert.alertId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">
									${alert.alertId} </a></td>
							<!-- 2. 경보대상구분 -->
							<td>${alert.alertType}</td>

							<!-- 3. 알림 메시지 내용 -->
							<td><c:out value="${alert.alertMsg}" /></td>
							<!-- 4. 전송성공여부 -->
							<td>${alert.sendStatus}</td>
							<!-- 5. 최초경보시각 (TIMESTAMP 포맷팅) -->
							<td><fmt:formatDate value="${alert.firstSendTime}"
									pattern="yyyy-MM-dd HH:mm:ss" /></td>
							<!-- 6. 경보전송일시 (DATE 포맷팅) -->
							<td><fmt:formatDate value="${alert.sendDate}"
									pattern="yyyy-MM-dd HH:mm:ss" /></td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>

	<!-- 페이징 버튼 영역 (보내주신 수식 및 정적 스타일 완벽 매핑) -->
	<div class="text-center">
		<ul class="pagination"
			style="display: flex; list-style: none; padding-left: 0;">
			<!-- 이전 버튼 -->
			<c:if test="${pageMaker.prev}">
				<li style="margin-right: 5px;"><a
					href="list?page=${pageMaker.startPage - 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">&laquo;
						이전</a></li>
			</c:if>

			<!-- 페이지 번호 루프 -->
			<c:forEach var="pageNum" begin="${pageMaker.startPage}"
				end="${pageMaker.endPage}">
				<li class="${pageMaker.page == pageNum ? 'active' : ''}"
					style="margin-right: 5px;"><c:choose>
						<c:when test="${pageMaker.page == pageNum}">
							<strong style="color: red;">${pageNum}</strong>
							<!-- 현재 페이지 빨간색 강조 -->
						</c:when>
						<c:otherwise>
							<a
								href="list?page=${pageNum}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">${pageNum}</a>
						</c:otherwise>
					</c:choose></li>
			</c:forEach>

			<!-- 다음 버튼 -->
			<c:if test="${pageMaker.next}">
				<li style="margin-right: 5px;"><a
					href="list?page=${pageMaker.endPage + 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">다음
						&raquo;</a></li>
			</c:if>
		</ul>
	</div>

	<!-- 검색 폼 영역 (스프링 폼 태그 및 AlertLogMapper 검색 조건 연동) -->
	<form:form action="list" method="get">
		<select name="searchType">
			<option value=""
				${pageMaker.searchType == null or pageMaker.searchType == '' ? 'selected' : ''}>전체</option>
			<option value="type"
				${pageMaker.searchType == 'type' ? 'selected' : ''}>경보대상구분</option>
			<option value="msg"
				${pageMaker.searchType == 'msg' ? 'selected' : ''}>경보메세지</option>
		</select>
		<input type="text" name="keyword" value="${pageMaker.keyword}"
			placeholder="검색어 입력">
		<button type="submit">검색</button>
	</form:form>

	<br>
	<a href="${pageContext.request.contextPath}/">메인으로</a>
</body>
</html>
