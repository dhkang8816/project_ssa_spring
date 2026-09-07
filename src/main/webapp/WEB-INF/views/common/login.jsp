<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css"> 
</head>
<body class="login-page"> 
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <div class="login-wrapper">
        <div class="login-container">
            <h2>로그인</h2>
            <!-- form:form 대신 일반 form 태그 사용 -->
            <form:form id="loginForm" action="${pageContext.request.contextPath}/login" method="post">
                <!-- CSRF 토큰 -->
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                
                <div class="input-group">
                    <label for="username">사번(아이디)</label>
                    <input type="text" id="username" name="memberId" placeholder="사번을 입력하세요" required>
                </div>
                <div class="input-group">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
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
    <script src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script> 
    <script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
</body>
</html>