<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>실시간 개체수 현황</title>
</head>
<body>
	<h2>📊 실시간 개체수 현황 대시보드</h2>

	<!-- 동물관리 리스트로 돌아가는 버튼 -->
	<div style="margin-bottom: 10px;">
		<button type="button"
			onclick="location.href='${pageContext.request.contextPath}/animal/list'">동물 관리 목록</button>
	</div>
	
	<table border="1">
		<thead>
			<tr>
				<th>축종 코드 (ID)</th>
				<th>축종 명칭</th>
				<th>현재 보호 개체수</th>
				<th>최종 갱신 일시</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${empty counterList}">
					<tr>
						<td colspan="4" align="center">등록된 현황판 데이터가 없습니다.</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach var="counter" items="${counterList}">
						<tr>
							<td>${counter.counterId}</td>
							<td>
								<!-- 프론트엔드 코드 매핑 (0: 개, 1: 고양이) -->
								<c:choose>
									<c:when test="${counter.counterId == 0}">개</c:when>
									<c:when test="${counter.counterId == 1}">고양이</c:when>
									<c:otherwise>미지정 축종</c:otherwise>
								</c:choose>
							</td>
							<td><strong>${counter.currentCount} 마리</strong></td>
							<td><fmt:formatDate value="${counter.lastUpdate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>

	<!-- 페이징 버튼 영역 (기존 프로젝트 스타일 완벽 매핑) -->
	<div class="text-center">
	    <ul class="pagination" style="display: flex; list-style: none; padding-left: 0;">
	        <c:if test="${pageMaker.prev}">
	            <li style="margin-right: 5px;">
	            	<a href="counterList?page=${pageMaker.startPage - 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">&laquo; 이전</a>
	            </li>
	        </c:if>
	        
	        <c:forEach var="pageNum" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
	            <li class="${pageMaker.page == pageNum ? 'active' : ''}" style="margin-right: 5px;">
	                <c:choose>
	                    <c:when test="${pageMaker.page == pageNum}">
	                        <strong style="color: red;">${pageNum}</strong>
	                    </c:when>
	                    <c:otherwise>
	                        <a href="counterList?page=${pageNum}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">${pageNum}</a>
	                    </c:otherwise>
	                </c:choose>
	            </li>
	        </c:forEach>
	        
	        <c:if test="${pageMaker.next}">
	            <li style="margin-right: 5px;">
	            	<a href="counterList?page=${pageMaker.endPage + 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">다음 &raquo;</a>
	            </li>
	        </c:if>
	    </ul>
	</div>
	
	<!-- 검색 폼 영역 -->
	<form:form action="counterList" method="get">
	    <select name="searchType">
	        <option value="c" ${pageMaker.searchType == 'c' ? 'selected' : ''}>축종 코드</option>
	    </select>
	    <input type="text" name="keyword" value="${pageMaker.keyword}" placeholder="코드 번호 입력">
	    <button type="submit">검색</button>
	</form:form>
	<br>
	<a href="${pageContext.request.contextPath}/">메인으로</a>
</body>
</html>
