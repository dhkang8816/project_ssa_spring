<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공통코드 목록 확인용</title>
<style>
body {
	font-family: 'Malgun Gothic', sans-serif;
	padding: 20px;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 15px;
}

th, td {
	border: 1px solid #ddd;
	padding: 10px;
	text-align: center;
}

th {
	background-color: #f5f5f5;
}

.no-data {
	padding: 30px;
	color: #888;
}

.search-box {
	margin-top: 20px;
	padding: 15px;
	background: #f9f9f9;
	border: 1px solid #ddd;
}

.pagination {
	list-style: none;
	display: flex;
	justify-content: center;
	padding: 0;
	margin-top: 20px;
}

.pagination li {
	margin: 0 5px;
}

.pagination li.active a {
	font-weight: bold;
	color: red;
}
</style>
</head>
<body>

	<h2>🛠️ 공통코드 데이터 연동 확인 화면</h2>
	
	<!-- 💡 pageMaker 객체에서 값 가져오도록 수정 -->
	<p>
		현재 페이지: <strong>${pageMaker.page}</strong> | 검색된 총 데이터 개수: <strong>${pageMaker.totalCount}개</strong>
	</p>
	
	<button type="button"
		onclick="location.href='${pageContext.request.contextPath}/commoncode/registerForm'">신규 코드 등록</button>

	<!-- 💡 검색 폼 영역 추가 -->
	<div class="search-box">
		<form action="${pageContext.request.contextPath}/commoncode/list" method="get">
			그룹코드: <input type="text" name="searchGrpCode" value="${pageMaker.searchGrpCode}">
			코드이름: <input type="text" name="searchKeyword" value="${pageMaker.searchKeyword}">
			사용여부: 
			<select name="searchUseYn">
				<option value="">전체</option>
				<option value="Y" ${pageMaker.searchUseYn == 'Y' ? 'selected' : ''}>Y</option>
				<option value="N" ${pageMaker.searchUseYn == 'N' ? 'selected' : ''}>N</option>
			</select>
			<button type="submit">검색</button>
		</form>
	</div>

	<table>
		<thead>
			<tr>
				<th>번호</th>
				<th>그룹코드</th>
				<th>상세코드</th>
				<th>코드명칭</th>
				<th>정렬순서</th>
				<th>사용여부</th>
				<th>등록일자</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${not empty codeList}">
					<c:forEach var="cc" items="${codeList}" varStatus="status">
						<tr>
							<td>${status.count}</td>
							<td><a
								href="${pageContext.request.contextPath}/commoncode/detail?grpCode=${cc.grpCode}&code=${cc.code}">
									${cc.grpCode} </a></td>
							<td>${cc.code}</td>
							<td style="text-align: left; padding-left: 15px;">${cc.codeName}</td>
							<td>${cc.sortSeq}</td>
							<td>${cc.useYn}</td>
							<td><fmt:formatDate value="${cc.codeDate}"
									pattern="yyyy-MM-dd HH:mm:ss" /></td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="7" class="no-data">조회된 데이터가 없습니다. DB에 값이 들어있는지 확인하세요.</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>

	<!-- 💡 하단 페이징 버튼 영역 추가 (검색 조건 유지 포함) -->
	<ul class="pagination">
		<c:if test="${pageMaker.prev}">
			<li><a href="list?page=${pageMaker.startPage - 1}&searchGrpCode=${pageMaker.searchGrpCode}&searchKeyword=${pageMaker.searchKeyword}&searchUseYn=${pageMaker.searchUseYn}">&laquo; 이전</a></li>
		</c:if>

		<c:forEach var="pageNum" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
			<li class="${pageMaker.page == pageNum ? 'active' : ''}">
				<a href="list?page=${pageNum}&searchGrpCode=${pageMaker.searchGrpCode}&searchKeyword=${pageMaker.searchKeyword}&searchUseYn=${pageMaker.searchUseYn}">${pageNum}</a>
			</li>
		</c:forEach>

		<c:if test="${pageMaker.next}">
			<li><a href="list?page=${pageMaker.endPage + 1}&searchGrpCode=${pageMaker.searchGrpCode}&searchKeyword=${pageMaker.searchKeyword}&searchUseYn=${pageMaker.searchUseYn}">다음 &raquo;</a></li>
		</c:if>
	</ul>
	
	<br>
	<a href="${pageContext.request.contextPath}/">메인으로</a>

</body>
</html>