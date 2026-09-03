<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 상세 정보</title>
</head>
<body>
    <h2>직원 상세 정보</h2>
    <div>
        <p><strong>사번:</strong> ${member.memberId}</p>
        <p><strong>이름:</strong> ${member.name}</p>
        <p><strong>부서:</strong> ${member.department}</p>
        <p><strong>연락처:</strong> ${member.phone}</p>
        <p><strong>이메일:</strong> ${member.email}</p>
        <p>
        <strong>상태:</strong> 						
		<!-- 💡 상태 값 출력 (코드값 또는 한글 명칭) --> 
		<c:choose>
			<c:when test="${member.status == '0'}">정상</c:when>
			<c:when test="${member.status == '1'}">정지</c:when>
			<c:when test="${member.status == '2'}">휴면</c:when>
			<c:otherwise>${member.status}</c:otherwise>
		</c:choose>
		</p>
        <p><strong>로그인 실패 횟수:</strong> ${member.failCount}</p>
        <p><strong>가입일:</strong> ${member.regDate}</p>
        <p><strong>최종 로그인:</strong> ${member.lastLongDate}</p>
    </div>
    <br>
    <a href="${pageContext.request.contextPath}/member/list">목록으로</a>
    <a href="${pageContext.request.contextPath}/">메인으로</a>
    
    <!-- 💡 수정 페이지로 이동하는 버튼 추가 -->
    <div style="margin-top: 10px;">
        <button type="button" onclick="location.href='${pageContext.request.contextPath}/member/modifyForm?memberId=${member.memberId}'">수정</button>
        <button type="button" onclick="location.href='${pageContext.request.contextPath}/member/list'">목록으로</button>
    </div>
</body>
</html>