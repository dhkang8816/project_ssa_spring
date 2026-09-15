<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공통코드 등록</title>
<style>
/* [1. 글로벌 바디 및 하이테크 레이아웃] */
body {
    background-color: #0b0f19 !important; /* 깊은 사이버 다크 톤 강제 적용 */
    color: #e2e8f0 !important;
    font-family: 'Segoe UI', Roboto, 'Malgun Gothic', sans-serif;
    padding: 32px !important;
    margin: 0;
}

/* [2. 메인 카드 프레임 스킨 및 타이틀] */
.panel {
    background: rgba(20, 26, 42, 0.85) !important;
    border: 1px solid #1e293b !important;
    border-radius: 16px;
    padding: 28px !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
    backdrop-filter: blur(4px);
    max-width: 500px; /* 입력 폼 최적화 너비 제한 */
    margin: 0 auto;
}

h2 {
    color: #ffffff !important;
    margin: 0 0 24px 0 !important;
    font-size: 20px !important;
    font-weight: 700 !important;
    letter-spacing: -0.02em;
    text-align: left;
    border-bottom: 1px solid #1e293b;
    padding-bottom: 12px;
}

/* [3. 폼 입력 콤포넌트 구조화] */
.form-group {
    margin-bottom: 20px;
    display: flex;
    flex-direction: column;
    gap: 8px;
}

label {
    display: inline-block;
    color: #38bdf8 !important; /* 네온 블루 라벨 처리 */
    font-size: 13.5px;
    font-weight: 700;
}

/* 다크 암청색 고도화 및 가이드 라이트 링 장착 */
input[type="text"], input[type="number"], select {
    padding: 10px 12px !important;
    background: #111827 !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 6px !important;
    outline: none;
    font-size: 14px;
    width: 100% !important; /* 프레임 맞춤 너비 자동 확장 */
    box-sizing: border-box;
    transition: all 0.15s ease;
}

input[type="text"]:focus, input[type="number"]:focus, select:focus {
    border-color: #0ea5e9 !important;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25) !important;
}

/* [4. 조작 버튼 UI 콤포넌트 규격화] */
.btn-group {
    margin-top: 28px;
    display: flex;
    gap: 8px;
    justify-content: flex-end;
}

button {
    padding: 10px 20px;
    border: 0;
    border-radius: 8px !important;
    font-weight: 700;
    font-size: 13.5px;
    cursor: pointer;
    transition: all 0.15s ease;
}

/* 저장하기 액션: 선명한 네온 블루 스킨 */
button[type="submit"] {
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
}
button[type="submit"]:hover {
    background-color: #0284c7 !important;
}

/* 취소 액션: 차분한 무채색 다크 그레이 스킨 */
button.btn-cancel {
    background-color: #1e293b !important;
    color: #cbd5e1 !important;
    border: 1px solid #334155 !important;
}
button.btn-cancel:hover {
    background-color: #334155 !important;
    color: #ffffff !important;
}
</style>
</head>
<body>
<div class="panel">
    <h2>시스템 코드 등록</h2>
    
    <!-- 컨트롤러의 /commoncode/register (POST) 메서드로 데이터 전송 (기본 Spring Form 무결점 유지) -->
    <form:form action="${pageContext.request.contextPath}/commoncode/register" method="post">
        <c:if test="${param.popup eq 'true'}"><input type="hidden" name="popup" value="true" /></c:if>
        
        <div class="form-group">
            <label>그룹코드:</label> 
            <input type="text" name="grpCode" required placeholder="예: SYS_01" />
        </div>
        
        <div class="form-group">
            <label>상세코드:</label> 
            <input type="text" name="code" required placeholder="예: 01" />
        </div>
        
        <div class="form-group">
            <label>코드명칭:</label> 
            <input type="text" name="codeName" required placeholder="예: 사용정지" />
        </div>
        
        <div class="form-group">
            <label>정렬순서:</label> 
            <input type="number" name="sortSeq" required value="1" />
        </div>
        
        <div class="form-group">
            <label>사용여부:</label> 
            <select name="useYn">
                <option value="Y">사용 (Y)</option>
                <option value="N">미사용 (N)</option>
            </select>
        </div>
        
        <!-- 하이테크 스타일로 정돈된 버튼 그룹 디자인 마감 -->
        <div class="btn-group">
            <button type="submit">저장하기</button>
            <button type="button" class="btn-cancel"
                    onclick="return closePopupAndRefreshParent('${pageContext.request.contextPath}/commoncode/list');">취소</button>
        </div>
    </form:form>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>

</html>
