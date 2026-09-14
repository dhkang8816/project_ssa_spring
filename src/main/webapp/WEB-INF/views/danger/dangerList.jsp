<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이상 객체 마스터 목록</title>
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
	<h2>🚨 이상 객체 마스터 목록 화면</h2>

	<!-- 신규 이상 객체 등록 페이지로 이동하는 버튼 -->
	<div style="margin-bottom: 10px;">
		<button type="button"
			onclick="return openFormPopup('${pageContext.request.contextPath}/danger/register', 'dangerRegister');">신규
			객체 등록</button>
	</div>

	<table border="1">
		<thead>
			<tr>
				<th style="width: 100px;">식별번호</th>
				<th style="width: 250px;">이상 객체 이름</th>
				<th style="width: 150px;">등록일자</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${empty dangerList}">
					<tr>
						<td colspan="3" align="center">등록된 이상 객체 종류가 없습니다.</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach var="danger" items="${dangerList}">
						<tr style="cursor: pointer;"
							onclick="return openDetailPopup('${pageContext.request.contextPath}/danger/detail?dangerId=${danger.dangerId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}', 'dangerDetail');">
							<td align="center">${danger.dangerId}</td>
							<td>&nbsp;<c:out value="${danger.dangerName}" /></td>
							<td align="center"><fmt:formatDate
									value="${danger.dangerDate}" pattern="yyyy-MM-dd" /></td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>

	<!-- 페이징 버튼 영역 -->
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

	<!-- 검색 폼 영역 (n: 이상객체이름) -->
	<form:form action="list" method="get">
		<select name="searchType">
			<option value="n" ${pageMaker.searchType == 'n' ? 'selected' : ''}>이상
				객체 이름</option>
		</select>
		<input type="text" name="keyword" value="${pageMaker.keyword}"
			placeholder="검색어 입력">
		<button type="submit">검색</button>
	</form:form>
	<br>
	<a href="${pageContext.request.contextPath}/">메인으로</a>

	<script>
		var msg = "${msg}";
		if (msg === "REGISTER_SUCCESS")
			alert("신규 이상 객체가 마스터에 등록되었습니다.");
		if (msg === "MODIFY_SUCCESS")
			alert("이상 객체 정보가 수정되었습니다.");
		if (msg === "REMOVE_SUCCESS")
			alert("이상 객체가 안전하게 삭제되었습니다.");
	</script>
</body>
</html>
