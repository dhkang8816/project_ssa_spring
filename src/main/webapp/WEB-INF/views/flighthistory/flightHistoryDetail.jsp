<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비행 이력 상세 정보</title>
</head>
<body>
	<h2>🔍 드론 상세 비행 세부 내역</h2>

	<form:form id="historyForm" method="post">
		<!-- 페이징/검색 데이터 유지를 위한 하이딩 파라미터 -->
		<input type="hidden" name="page" value="${pageMaker.page}" />
		<input type="hidden" name="searchType" value="${pageMaker.searchType}" />
		<input type="hidden" name="keyword" value="${pageMaker.keyword}" />
		<input type="hidden" name="flightId" value="${flightHistory.flightId}" />

		<table border="1" style="border-collapse: collapse;">
			<tbody>
				<tr>
					<th style="padding: 6px 12px; background-color: #f9f9f9; width: 160px;">비행 이력 번호</th>
					<td style="padding: 6px 12px; width: 300px;">${flightHistory.flightId}</td>
				</tr>
				<tr>
					<th style="padding: 6px 12px; background-color: #f9f9f9;">드론 기체 고유 ID</th>
					<td style="padding: 6px 12px; font-weight: bold;">${flightHistory.droneId}</td>
				</tr>
				<tr>
					<th style="padding: 6px 12px; background-color: #f9f9f9;">비행 시작 시각</th>
					<td style="padding: 6px 12px;">
						<fmt:formatDate value="${flightHistory.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
				<tr>
					<th style="padding: 6px 12px; background-color: #f9f9f9;">비행 종료 시각</th>
					<td style="padding: 6px 12px;">
						<fmt:formatDate value="${flightHistory.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
				<tr>
					<th style="padding: 6px 12px; background-color: #f9f9f9;">총 누적 비행 시간</th>
					<td style="padding: 6px 12px;">${flightHistory.flightDuration} 시간</td>
				</tr>
				<tr>
					<th style="padding: 6px 12px; background-color: #f9f9f9;">배터리 총 소모량</th>
					<td style="padding: 6px 12px;">
						<c:choose>
							<c:when test="${empty flightHistory.batteryConsumption}"><span style="color: gray;">집계불가</span></c:when>
							<c:otherwise>${flightHistory.batteryConsumption} %</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th style="padding: 6px 12px; background-color: #f9f9f9;">관제 데이터 등록일</th>
					<td style="padding: 6px 12px;">
						<fmt:formatDate value="${flightHistory.flightDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
			</tbody>
		</table>
		
		<br />
		<div>
			<button type="button" onclick="fn_delete()" style="background-color: #f44336; color: white;">이력 로그 삭제</button>
			<button type="button" onclick="fn_goList()">목록으로</button>
		</div>
	</form:form>

</body>
<script>
	function fn_delete() {
		if(!confirm("정말로 이 드론의 비행 이력 데이터를 시스템에서 영구 삭제하시겠습니까?")) return;
		var form = document.getElementById("historyForm");
		form.action = "${pageContext.request.contextPath}/flighthistory/remove";
		form.submit();
	}

	function fn_goList() {
		location.href = "${pageContext.request.contextPath}/flighthistory/list"
		              + "?page=${pageMaker.page}"
		              + "&searchType=${pageMaker.searchType}"
		              + "&keyword=${pageMaker.keyword}";
	}
</script>
</html>
