<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인 페이지</title>
</head>
<body>
	<h1>프로젝트 메인 화면</h1>
	<p>환영합니다!</p>
	
	<!-- 💡 직원 목록 및 공통 코드 목록 이동 버튼 추가 -->
    <div style="margin: 20px 0;">
        <button type="button" onclick="location.href='${pageContext.request.contextPath}/member/list'">직원 목록</button>
        <button type="button" onclick="location.href='${pageContext.request.contextPath}/commoncode/list'">공통 코드 목록</button>
        <button type="button" onclick="location.href='${pageContext.request.contextPath}/animal/list'">동물 목록</button>
        <button type="button" onclick="location.href='${pageContext.request.contextPath}/danger/list'">이상 객체 목록</button> 
        <button type="button" onclick="location.href='${pageContext.request.contextPath}/drone/list'">드론 목록</button><br/> 
        <button type="button" onclick="location.href='${pageContext.request.contextPath}/flighthistory/list'">비행 이력 목록</button>              
    	<button type="button" onclick="location.href='${pageContext.request.contextPath}/detection/list'">탐지 이력 목록</button>
    	<button type="button" onclick="location.href='${pageContext.request.contextPath}/dangerlog/list'">이상 개체 탐지 이력 목록</button>
    </div>

	<!-- 세션에 Spring Security 인증 Context가 있는지 여부로 판단 -->
	<c:choose>
		<%-- 로그인된 상태 --%>
		<c:when test="${not empty sessionScope.SPRING_SECURITY_CONTEXT}">
			<p><strong>접속 중</strong>님 환영합니다!</p>
			<form action="${pageContext.request.contextPath}/logout" method="post">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				<button type="submit">로그아웃</button>
			</form>
		</c:when>
		
		<%-- 비로그인 상태 --%>
		<c:otherwise>
			<form action="${pageContext.request.contextPath}/login" method="get">
				<button type="submit">로그인 하러 가기</button>
			</form>
		</c:otherwise>
	</c:choose>
</body>
</html>