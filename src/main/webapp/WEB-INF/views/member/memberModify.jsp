<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 정보 수정</title>
</head>
<body>
	<h2>직원 정보 수정</h2>

	<form:form modelAttribute="member"
		action="${pageContext.request.contextPath}/member/modify"
		method="post">
		<table border="1">
			<tr>
				<th>사번</th>
				<td>
					<!-- 사번은 수정하면 안 되므로 화면에 보여주되 hidden으로도 전송 --> ${member.memberId} <input
					type="hidden" name="memberId" value="${member.memberId}">
				</td>
			</tr>
			<tr>
				<th>이름</th>
				<td><input type="text" name="name" value="${member.name}"
					required></td>
			</tr>
			<tr>
				<th>부서</th>
				<td><input type="text" name="department"
					value="${member.department}"></td>
			</tr>
			<tr>
				<th>연락처</th>
				<td><input type="text" name="phone" value="${member.phone}">
				</td>
			</tr>
			<tr>
				<th>이메일</th>
				<td><input type="email" name="email" value="${member.email}">
				</td>
			</tr>
			<tr>
				<th>권한</th>
				<td><form:select path="role">
						<form:options items="${roleList}" itemValue="code"
							itemLabel="codeName" />
					</form:select></td>
			</tr>
			<tr>
				<th>계정 상태</th>
				<td>
					<!-- 💡 path="status"를 지정하면 member.status 값과 일치하는 옵션이 자동 selected 됩니다 -->
					<form:select path="status">
						<form:options items="${statusList}" itemValue="code"
							itemLabel="codeName" />
					</form:select>
				</td>
			</tr>
		</table>

		<br>

		<div>
			<button type="submit">저장</button>
			<button type="button"
				onclick="location.href='${pageContext.request.contextPath}/member/detail?memberId=${member.memberId}'">취소</button>
		</div>
	</form:form>
</body>
</html>