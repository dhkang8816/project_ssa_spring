<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>보호 동물 목록</title>
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
	<h2>보호 동물 목록 화면</h2>

	<!-- 기존 코드 중 '신규 동물 등록' 버튼 옆에 나란히 붙여줍니다 -->
	<div style="margin-bottom: 10px;">
		<button type="button"
			onclick="location.href='${pageContext.request.contextPath}/animal/register'">신규
			동물 등록</button>

		<!-- 💡 [추가] 실시간 개체수 현황판으로 즉시 이동하는 버튼 링크 -->
		<button type="button"
			style="margin-left: 5px; background-color: #4CAF50; color: white;"
			onclick="location.href='${pageContext.request.contextPath}/animal/counterList'">📊
			개체수 현황 조회</button>
	</div>


	<table border="1">
		<thead>
			<tr>
				<th>식별번호</th>
				<th>축종</th>
				<th>품종</th>
				<th>동물이름</th>
				<th>입소일자</th>
				<th>보호상태</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${empty animalList}">
					<tr>
						<td colspan="6" align="center">등록된 보호 동물이 없습니다.</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach var="animal" items="${animalList}">
						<tr>
							<td><a
								href="${pageContext.request.contextPath}/animal/detail?animalId=${animal.animalId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">
									${animal.animalId} </a></td>
							<td>
								<!-- 프론트엔드 코드 매핑 (0: 개, 1: 고양이) --> <c:choose>
									<c:when test="${animal.animalType == '0'}">개</c:when>
									<c:when test="${animal.animalType == '1'}">고양이</c:when>
									<c:otherwise>${animal.animalType}</c:otherwise>
								</c:choose>
							</td>
							<td>${animal.animalBreed}</td>
							<td>${animal.animalName}</td>
							<td><fmt:formatDate value="${animal.entranceDate}"
									pattern="yyyy-MM-dd" /></td>
							<td>
								<!-- 💡 신규 동물 보호상태 매핑 반영 (0: 보호중, 1: 입양, 2: 퇴소) --> <c:choose>
									<c:when test="${animal.animalStatus == '0'}">보호중</c:when>
									<c:when test="${animal.animalStatus == '1'}">입양</c:when>
									<c:when test="${animal.animalStatus == '2'}">퇴소</c:when>
									<c:otherwise>${animal.animalStatus}</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>

	<!-- 페이징 버튼 영역 (기존 프로젝트 스타일 완벽 매핑) -->
	<div class="text-center">
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
							<!-- 현재 페이지 강조 스타일 -->
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

	<!-- 검색 폼 영역 (AnimalDetailMapper 동적 조건 연동) -->
	<form:form action="list" method="get">
		<select name="searchType">
			<option value="t" ${pageMaker.searchType == 't' ? 'selected' : ''}>축종구분(코드)</option>
			<option value="b" ${pageMaker.searchType == 'b' ? 'selected' : ''}>품종</option>
			<option value="n" ${pageMaker.searchType == 'n' ? 'selected' : ''}>동물이름</option>
			<option value="s" ${pageMaker.searchType == 's' ? 'selected' : ''}>보호상태(코드)</option>
		</select>
		<input type="text" name="keyword" value="${pageMaker.keyword}"
			placeholder="검색어 입력">
		<button type="submit">검색</button>
	</form:form>
	<br>
	<a href="${pageContext.request.contextPath}/">메인으로</a>
</body>
</html>
