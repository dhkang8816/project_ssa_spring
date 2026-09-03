<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 - 관제 시스템</title>
<style>
body {
	font-family: 'Noto Sans KR', sans-serif;
	background-color: #f4f6f9;
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
	margin: 0;
}

.login-container {
	width: 360px;
	padding: 40px;
	background: #ffffff;
	border-radius: 8px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.login-title {
	text-align: center;
	margin-bottom: 24px;
	font-size: 22px;
	font-weight: bold;
	color: #333;
}

.form-group {
	margin-bottom: 16px;
}

.form-group label {
	display: block;
	font-size: 14px;
	margin-bottom: 6px;
	color: #666;
}

.form-group input {
	width: 100%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
	box-sizing: border-box;
}

.btn-login {
	width: 100%;
	padding: 12px;
	background-color: #007bff;
	color: white;
	border: none;
	border-radius: 4px;
	font-size: 16px;
	font-weight: bold;
	cursor: pointer;
	margin-top: 10px;
}

.btn-login:hover {
	background-color: #0056b3;
}

.alert-message {
	padding: 10px;
	margin-bottom: 16px;
	border-radius: 4px;
	font-size: 13px;
	text-align: center;
}

.alert-danger {
	background-color: #f8d7da;
	color: #721c24;
}

.alert-info {
	background-color: #d1ecf1;
	color: #0c5460;
}
</style>
</head>
<body>

	<div class="login-container">
		<div class="login-title">시스템 로그인</div>

		<!-- Spring Security 로그인 실패 메시지 출력 -->
		<c:if test="${param.error ne null}">
			<div class="alert-message alert-danger">
				아이디 또는 비밀번호가 일치하지 않습니다.<br>
				<c:if test="${not empty sessionScope.ERROR_MSG}">
					<small>(${sessionScope.ERROR_MSG})</small>
				</c:if>
			</div>

			<!-- 💡 자바스크립트 팝업 알럿을 원하신다면 아래 스크립트 추가 -->
			<script>
				alert("${sessionScope.ERROR_MSG}");
			</script>
		</c:if>

		<!-- 로그아웃 성공 메시지 출력 -->
		<c:if test="${param.logout ne null}">
			<div class="alert-message alert-info">성공적으로 로그아웃 되었습니다.</div>
		</c:if>

		<!-- Spring Security 인증 처리 URL로 POST 전송 -->
		<form:form action="${pageContext.request.contextPath}/login"
			method="post">
			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}" />

			<div class="form-group">
				<label>사번</label> <input type="text" name="memberId" required />
			</div>

			<div class="form-group">
				<label>비밀번호</label> <input type="password" name="password" required />
			</div>

			<button type="submit" class="btn-login">로그인</button>
		</form:form>
	</div>
</body>
</html>