<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신규 드론 등록</title>
</head>
<body>
	<h2>신규 드론 기체 등록</h2>

	<form:form action="${pageContext.request.contextPath}/drone/register"
		method="post">
		<c:if test="${param.popup eq 'true'}"><input type="hidden" name="popup" value="true" /></c:if>
		<table border="1">
			<tbody>
				<tr>
					<th style="padding: 5px 10px;">드론 기체 ID</th>
					<td style="padding: 5px 10px;"><input type="text"
						name="droneId" placeholder="예: DRONE_01, DRONE_02"
						required="required" style="width: 250px;" /></td>
				</tr>
				<tr>
					<th style="padding: 5px 10px;">담당 관제원 배정</th>
					<td style="padding: 5px 10px;">
						<!-- 💡 텍스트 입력 창을 지우고 동적 select 목록으로 교체 --> <select
						name="memberId" style="width: 256px;">
							<option value="">-- 담당 관제원 선택 (미배정) --</option>
							<c:forEach var="member" items="${memberList}">
								<%-- value에는 실제 DB에 저장될 사번(MEMBER_ID)을 넣고, 화면에는 이름과 사번을 직관적으로 보여줍니다 --%>
								<option value="${member.memberId}">${member.name}
									(${member.memberId})</option>
							</c:forEach>
					</select>
					</td>
				</tr>
			</tbody>
		</table>

		<br />
		<div>
			<button type="submit">등록 완료</button>
			<button type="button"
				onclick="location.href='${pageContext.request.contextPath}/drone/list'">취소</button>
		</div>
	</form:form>

	<br />
	<a href="${pageContext.request.contextPath}/">메인으로</a>
</body>
</html>
