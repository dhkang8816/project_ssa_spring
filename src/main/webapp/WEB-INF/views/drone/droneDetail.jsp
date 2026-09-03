<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>드론 상세 정보</title>
</head>
<body>
	<h2>드론 상세 및 배정 수정 화면</h2>

	<form:form id="droneForm" method="post">
		<!-- 페이징/검색 데이터 유지 -->
		<input type="hidden" name="page" value="${pageMaker.page}" />
		<input type="hidden" name="searchType" value="${pageMaker.searchType}" />
		<input type="hidden" name="keyword" value="${pageMaker.keyword}" />

		<table border="1">
			<tbody>
				<tr>
					<th style="padding: 5px 10px;">드론 기체 ID</th>
					<td style="padding: 5px 10px;">
						<!-- 문자열 식별키(PK)이므로 수정을 방지하기 위해 readonly 처리 -->
						<input type="text" name="droneId" value="${drone.droneId}" readonly="readonly" style="background-color: #eee; width: 250px;" />
					</td>
				</tr>
				<tr>
					<th style="padding: 5px 10px;">담당 관제원 변경</th>
					<td style="padding: 5px 10px;">
						<!-- 💡 기존 배정된 사람을 자동으로 select 해주는 가변 목록 구조 -->
						<select name="memberId" style="width: 256px;">
							<option value="">-- 담당 관제원 선택 (미배정) --</option>
							<c:forEach var="member" items="${memberList}">
								<option value="${member.memberId}" ${drone.memberId == member.memberId ? 'selected="selected"' : ''}>
									${member.name} (${member.memberId})
								</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</tbody>
		</table>
		
		<br />
		<div>
			<button type="button" onclick="fn_submit('modify')">배정 수정</button>
			<button type="button" onclick="fn_submit('remove')" style="background-color: #f44336; color: white;">기체 삭제</button>
			<button type="button" onclick="fn_goList()">목록으로</button>
		</div>
	</form:form>
	
	<br />
	<a href="${pageContext.request.contextPath}/">메인으로</a>

<script>
	function fn_submit(mode) {
		var form = document.getElementById("droneForm");
		
		if(mode === 'modify') {
			if(!confirm("드론 배정 정보를 수정하시겠습니까?")) return;
			form.action = "${pageContext.request.contextPath}/drone/modify";
		} else if(mode === 'remove') {
			if(!confirm("정말로 이 드론 기체를 삭제하시겠습니까?")) return;
			form.action = "${pageContext.request.contextPath}/drone/remove";
		}
		form.submit();
	}

	function fn_goList() {
		location.href = "${pageContext.request.contextPath}/drone/list"
		              + "?page=${pageMaker.page}"
		              + "&searchType=${pageMaker.searchType}"
		              + "&keyword=${pageMaker.keyword}";
	}
</script>
</body>
</html>
