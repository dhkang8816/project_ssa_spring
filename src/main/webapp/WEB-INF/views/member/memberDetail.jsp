<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 상세 정보</title>
</head>
<body>
    <h2>직원 상세 정보</h2>
    
    <!-- 💡 [수정] 컨트롤러의 getPicture 스트림을 호출하여 외부 저장소 이미지를 노출하는 무결성 영역 -->
    <div style="margin-bottom: 20px; padding: 5px;">
        <%-- 유저가 보던 화면 레이아웃과 조건 분기 속성은 그대로 보존하되, src 주소만 스트림 매핑 주소로 최적화했습니다. --%>
        <img src="${pageContext.request.contextPath}/member/getPicture?id=${member.memberId}" 
             alt="직원 사진" 
             style="width: 150px; height: 180px; border: 1px solid #ccc; object-fit: cover;" 
             onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';" />
    </div>
    
    <div>
        <p><strong>사번:</strong> ${member.memberId}</p>
        <p><strong>이름:</strong> ${member.name}</p>
        <p><strong>부서:</strong> ${member.department}</p>
        <p><strong>연락처:</strong> ${member.phone}</p>
        <p><strong>이메일:</strong> ${member.email}</p>
        <p>
        <strong>상태:</strong> 						
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
    
    <div style="margin-top: 10px;">
        <button type="button" onclick="location.href='${pageContext.request.contextPath}/member/modifyForm?memberId=${member.memberId}'">수정</button>
        <button type="button" onclick="location.href='${pageContext.request.contextPath}/member/list'">목록으로</button>
    </div>
</body>
</html>
