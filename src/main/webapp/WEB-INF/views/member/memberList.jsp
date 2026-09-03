<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 목록</title>
</head>
<body>
	<h2>직원 목록 화면</h2>

	<!-- 💡 계정 등록(회원가입) 페이지로 이동하는 버튼 추가 -->
	<div style="margin-bottom: 10px;">
		<button type="button"
			onclick="location.href='${pageContext.request.contextPath}/member/registForm'">계정
			등록</button>
	</div>
	<table border="1">
		<thead>
			<tr>
				<th>사번</th>
				<th>이름</th>
				<th>부서</th>
				<th>연락처</th>
				<th>이메일</th>
				<th>가입일</th>
				<th>계정상태</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${empty memberList}">
					<tr>
						<td colspan="7" align="center">등록된 직원이 없습니다.</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach var="member" items="${memberList}">
						<tr>
							<td><a
								href="${pageContext.request.contextPath}/member/detail?memberId=${member.memberId}">
									${member.memberId} </a></td>
							<td>${member.name}</td>
							<td>${member.department}</td>
							<td>${member.phone}</td>
							<td>${member.email}</td>
							<td>${member.regDate}</td>
							<!-- 💡 cc.useYn 값에 따라 다르게 표시 -->
							<td>
								<!-- 💡 상태 값 출력 (코드값 또는 한글 명칭) --> 
								<c:choose>
									<c:when test="${member.status == '0'}">정상</c:when>
									<c:when test="${member.status == '1'}">정지</c:when>
									<c:when test="${member.status == '2'}">휴면</c:when>
									<c:otherwise>${member.status}</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>
	<!-- 페이징 버튼 영역 예시 -->
	<div class="text-center">
	    <ul class="pagination">
	        <c:if test="${pageMaker.prev}">
	            <li><a href="list?page=${pageMaker.startPage - 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">&laquo; 이전</a></li>
	        </c:if>
	        
	        <c:forEach var="pageNum" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
	            <li class="${pageMaker.page == pageNum ? 'active' : ''}">
	                <a href="list?page=${pageNum}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">${pageNum}</a>
	            </li>
	        </c:forEach>
	        
	        <c:if test="${pageMaker.next}">
	            <li><a href="list?page=${pageMaker.endPage + 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">다음 &raquo;</a></li>
	        </c:if>
	    </ul>
	</div>
	
	<!-- 검색 폼 예시 -->
	<form action="list" method="get">
	    <select name="searchType">
	        <option value="t" ${pageMaker.searchType == 't' ? 'selected' : ''}>이름</option>
	        <option value="c" ${pageMaker.searchType == 'c' ? 'selected' : ''}>사번</option>
	    </select>
	    <input type="text" name="keyword" value="${pageMaker.keyword}" placeholder="검색어 입력">
	    <button type="submit">검색</button>
	</form>
	<br>
	<a href="${pageContext.request.contextPath}/">메인으로</a>
</body>
</html>