<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<body>
    <h2>회원가입</h2>
    <form:form action="${pageContext.request.contextPath}/member/regist" method="post">
        
        <div>
            <label>아이디:</label>
            <input type="text" name="memberId" required> <!-- member_id -> memberId 로 변경 -->
        </div>
        <div>
            <label>비밀번호:</label>
            <input type="password" name="password" required>
        </div>
        <div>
            <label>이름:</label>
            <input type="text" name="name" required>
        </div>
        <div>
            <label>부서:</label>
            <input type="text" name="department">
        </div>
        <div>
            <label>전화번호:</label>
            <input type="text" name="phone">
        </div>
        <div>
            <label>이메일:</label>
            <input type="email" name="email">
        </div>
        <div>
            <button type="submit">가입하기</button>
        </div>
    </form:form>
</body>
</html>