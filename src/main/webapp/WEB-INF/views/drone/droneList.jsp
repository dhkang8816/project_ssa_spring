<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>드론 관리 목록</title>
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
	<h2>🛸 드론 관리 목록 화면</h2>

	<!-- 신규 드론 등록 페이지로 이동하는 버튼 -->
	<div style="margin-bottom: 10px;">
		<button type="button"
			onclick="location.href='${pageContext.request.contextPath}/drone/register'">신규
			드론 등록</button>
	</div>

	<table border="1">
		<thead>
			<tr>
				<th style="width: 200px;">드론 기체 ID</th>
				<th style="width: 200px;">담당 관제원 사번</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${empty droneList}">
					<tr>
						<td colspan="2" align="center">등록된 드론 기체가 없습니다.</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach var="drone" items="${droneList}">
						<tr>
							<td align="center"><a
								href="${pageContext.request.contextPath}/drone/detail?droneId=${drone.droneId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">
									${drone.droneId} </a></td>
							<td align="center"><c:choose>
									<c:when test="${empty drone.memberId}">
										<span style="color: gray;">미배정</span>
									</c:when>
									<c:otherwise>${drone.memberId}</c:otherwise>
								</c:choose></td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>

	<!-- 페이징 버튼 영역 (기존 프로젝트 스타일 완벽 매핑) -->
	<div class="text-center">
		<ul class="pagination"
			style="display: flex; list-style: none; padding-left: 0; margin-top: 15px;">
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
	<br>
	<a href="${pageContext.request.contextPath}/">메인으로</a>

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
