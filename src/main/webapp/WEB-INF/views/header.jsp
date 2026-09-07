<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>헤더</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
     <div class="main-wrapper">
        <header class="top-header">
                <h1 class="system-title">
                    <a href="${pageContext.request.contextPath}/">유기동물 관제시스템</a>
                </h1>
                
            <div id="util-box">
                <a href="login.html">로그인</a>
            </div>
        </header>
    </div> 

</body>
</html>