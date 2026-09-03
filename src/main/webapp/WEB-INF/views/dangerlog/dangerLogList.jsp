<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>실시간 이상 객체 탐지 이력</title>
</head>
<body>
	<h2>🛸 실시간 이상 객체 탐지 이력 목록</h2>
	<br>
	
	<table border="1" style="border-collapse: collapse; text-align: center;">
		<thead>
			<tr style="background-color: #f2f2f2;">
				<th style="width: 80px; padding: 8px;">로그번호</th>
				<th style="width: 120px; padding: 8px;">드론 기체 ID</th>
				<th style="width: 150px; padding: 8px;">이상 객체 코드</th>
				<th style="width: 180px; padding: 8px;">탐지 시각</th>
				<th style="width: 100px; padding: 8px;">조치 상태</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${empty dangerLogList}">
					<tr>
						<td colspan="5" style="padding: 20px; color: gray;">포착된 실시간 이상 객체 탐지 이력이 없습니다.</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach var="log" items="${dangerLogList}">
						<tr>
							<td style="padding: 8px;">
								<!-- 상세 보기 및 현장 조치 화면 이동 링크 -->
								<a href="${pageContext.request.contextPath}/dangerlog/detail?danlogId=${log.danlogId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">
									${log.danlogId}
								</a>
							</td>
							<td style="padding: 8px;">
								<c:choose>
									<c:when test="${empty log.droneId}"><span style="color: gray;">미배정</span></c:when>
									<c:otherwise>${log.droneId}</c:otherwise>
								</c:choose>
							</td>
							<td style="padding: 8px; font-weight: bold;">
							    <c:out value="${log.dangerName}" /> <!-- 💡 이제 숫자가 아닌 '멧돼지' 텍스트가 바로 출력됩니다. -->
							</td>
							<td style="padding: 8px;">
								<fmt:formatDate value="${log.dangerTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td style="padding: 8px;">
								<!-- 조치 상태 코드 매핑 (0: 미확인, 1: 조치중, 2: 조치완료) -->
								<c:choose>
									<c:when test="${log.dactionStatus == '0'}"><span style="color: red; font-weight: bold;">미확인</span></c:when>
									<c:when test="${log.dactionStatus == '1'}"><span style="color: orange; font-weight: bold;">조치중</span></c:when>
									<c:when test="${log.dactionStatus == '2'}"><span style="color: green; font-weight: bold;">조치완료</span></c:when>
									<c:otherwise>${log.dactionStatus}</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>

	<!-- 페이징 버튼 영역 (기존 프로젝트 스타일 완벽 매핑) -->
	<div style="margin-top: 15px;">
	    <ul class="pagination" style="display: flex; list-style: none; padding-left: 0;">
	        <c:if test="${pageMaker.prev}">
	            <li style="margin-right: 5px;">
	            	<a href="list?page=${pageMaker.startPage - 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">&laquo; 이전</a>
	            </li>
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
	            <li style="margin-right: 5px;">
	            	<a href="list?page=${pageMaker.endPage + 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">다음 &raquo;</a>
	            </li>
	        </c:if>
	    </ul>
	</div>
	
	<!-- 다조건 동적 검색 폼 영역 (t: 마스터코드, d: 드론ID, s: 조치상태) -->
	<form:form action="list" method="get">
	    <select name="searchType">
	        <option value="t" ${pageMaker.searchType == 't' ? 'selected' : ''}>이상 객체 코드</option>
	        <option value="d" ${pageMaker.searchType == 'd' ? 'selected' : ''}>드론 기체 ID</option>
	        <option value="s" ${pageMaker.searchType == 's' ? 'selected' : ''}>조치 상태 (코드)</option>
	    </select>
	    <input type="text" name="keyword" value="${pageMaker.keyword}" placeholder="검색어 입력">
	    <button type="submit">검색</button>
	</form:form>
	<br>
	<a href="${pageContext.request.contextPath}/">메인으로</a>

	<script>
	    var msg = "${msg}";
	    if(msg === "MODIFY_SUCCESS") alert("현장 상황 조치 내역이 성공적으로 업데이트되었습니다.");
	</script>
</body>
</html>
