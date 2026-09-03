<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 목록</title>
<style>
	.pagination li.active a {
		font-weight: bold;
		color: red;
	}
	/* 💡 미니 썸네일 전용 스타일 */
	.mini-profile {
		width: 35px;
		height: 35px;
		border-radius: 50%; /* 이미지를 동그랗게 마감 */
		border: 1px solid #ddd;
		object-fit: cover;
		vertical-align: middle;
	}
</style>
</head>
<body>
	<h2>직원 목록 화면</h2>

	<!-- 계정 등록(회원가입) 페이지로 이동하는 버튼 추가 -->
	<div style="margin-bottom: 10px;">
		<button type="button"
			onclick="location.href='${pageContext.request.contextPath}/member/registForm'">계정 등록</button>
	</div>
	
	<table border="1" style="border-collapse: collapse; text-align: center; align-items: middle;">
		<thead>
			<tr>
				<th style="width: 60px;">사진</th>
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
						<td colspan="8" align="center">등록된 직원이 없습니다.</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach var="member" items="${memberList}">
						<tr>
							<!-- 💡 [수정] 컨트롤러의 getPicture 스트림 주소를 찔러서 외부/내부 경로 연동 처리 완료 -->
							<td style="padding: 5px;">
								<img src="${pageContext.request.contextPath}/member/getPicture?id=${member.memberId}" 
									 alt="미니프로필" class="mini-profile" 
									 onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';" />
							</td>
							
							<td>
								<a href="${pageContext.request.contextPath}/member/detail?memberId=${member.memberId}">
									${member.memberId}
								</a>
							</td>
							<td>${member.name}</td>
							<td>${member.department}</td>
							<td>${member.phone}</td>
							<td>${member.email}</td>
							<td>${member.regDate}</td>
							<td>
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
	    <ul class="pagination" style="display: flex; list-style: none; padding-left: 0;">
	        <c:if test="${pageMaker.prev}">
	            <li style="margin-right: 5px;"><a href="list?page=${pageMaker.startPage - 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">&laquo; 이전</a></li>
	        </c:if>
	        
	        <c:forEach var="pageNum" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
	            <li class="${pageMaker.page == pageNum ? 'active' : ''}" style="margin-right: 5px;">
	                <c:choose>
	                    <c:when test="${pageMaker.page == pageNum}">
	                        <strong style="color: red;">${pageNum}</strong>
	                    </c:when>
	                    <c:otherwise>
	                        <a href="list?page=${pageNum}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">${pageNum}</a>
	                    </c:otherwise>
	                </c:choose>
	            </li>
	        </c:forEach>
	        
	        <c:if test="${pageMaker.next}">
	            <li style="margin-right: 5px;"><a href="list?page=${pageMaker.endPage + 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">다음 &raquo;</a></li>
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
