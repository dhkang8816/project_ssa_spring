<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신규 이상 객체 등록</title>
</head>
<body>
	<h2>신규 이상 객체 마스터 등록</h2>

	<form:form action="${pageContext.request.contextPath}/danger/register"
		method="post">
		<table border="1">
			<tbody>
				<tr>
					<th style="padding: 5px 10px;">이상 객체 명칭</th>
					<td style="padding: 5px 10px;"><input type="text"
						name="dangerName" placeholder="예: 멧돼지, 고라니, 들개"
						required="required" style="width: 250px;" /></td>
				</tr>
			</tbody>
		</table>

		<br />
		<div>
			<button type="submit">등록 완료</button>
			<button type="button"
				onclick="location.href='${pageContext.request.contextPath}/danger/list'">취소</button>
		</div>
	</form:form>

	<br />
	<a href="${pageContext.request.contextPath}/">메인으로</a>
</body>
</html>
