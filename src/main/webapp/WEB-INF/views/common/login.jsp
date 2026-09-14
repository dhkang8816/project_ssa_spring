<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>로그인</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/style.css">
<style>
body.login-page {
	min-height: 100vh;
	display: flex;
	flex-direction: column;
	background: #28283a;
}

.login-wrapper {
	flex: 1;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 110px 20px 30px;
}

.login-container {
	width: 100%;
	max-width: 400px;
	padding: 40px;
	background: #323244;
	border-radius: 12px;
	box-shadow: 0 8px 24px rgba(0, 0, 0, .3);
}

.login-container h2 {
	margin: 0 0 28px;
	color: #fff;
	text-align: center;
	font-size: 24px;
}

.input-group {
	display: flex;
	flex-direction: column;
	margin-bottom: 20px;
}

.input-group label {
	margin-bottom: 8px;
	color: #b0b5c0;
	font-size: 14px;
	font-weight: 600;
}

.input-group input {
	width: 100%;
	padding: 12px 14px;
	background: #242434;
	color: #fff;
	border: 1px solid #48485e;
	border-radius: 6px;
	outline: none;
}

.input-group input:focus {
	border-color: #6366f1;
	box-shadow: 0 0 0 3px rgba(99, 102, 241, .2);
}

.login-btn {
	width: 100%;
	padding: 12px;
	border: 0;
	border-radius: 6px;
	background: #6366f1;
	color: #fff;
	font-size: 16px;
	font-weight: 600;
	cursor: pointer;
}

.login-btn:hover {
	background: #4f46e5;
}
</style>
</head>
<body class="login-page">
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div class="login-wrapper">
		<div class="login-container">
			<h2>로그인</h2>
			<!-- form:form 대신 일반 form 태그 사용 -->
			<form:form id="loginForm"
				action="${pageContext.request.contextPath}/login" method="post">
				<!-- CSRF 토큰 -->
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />

				<div class="input-group">
					<label for="username">사번(아이디)</label> <input type="text"
						id="username" name="memberId" placeholder="사번을 입력하세요" required>
				</div>
				<div class="input-group">
					<label for="password">비밀번호</label> <input type="password"
						id="password" name="password" placeholder="비밀번호를 입력하세요" required>
				</div>
				<button type="submit" class="login-btn">로그인</button>
			</form:form>
		</div>
	</div>
	<script>
        const contextPath = "${pageContext.request.contextPath}";
        fetch(contextPath + '/menu')
            .then(response => response.text())
            .then(data => {
                document.getElementById('menu-placeholder').innerHTML = data;
                document.dispatchEvent(new Event('menuLoaded'));
            })
            .catch(error => console.error('메뉴를 불러오는 중 오류 발생:', error));
    </script>
	<script
		src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
</body>
</html>
