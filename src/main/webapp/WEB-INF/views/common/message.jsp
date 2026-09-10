<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>안내 메시지</title>
</head>
<body>

</body>
<script>
    // 💡 백엔드 컨트롤러가 던져준 경고 메시지 출력
    var message = "${message}";
    if(message) {
        alert(message);
    }
    
    // 💡 백엔드가 지정해 준 복귀 주소로 이동 (없으면 이전 페이지로 back)
    var redirectUrl = "${redirectUrl}";
    if(redirectUrl) {
        location.href = "${pageContext.request.contextPath}" + redirectUrl;
    } else {
        history.back();
    }
</script>
</html>
