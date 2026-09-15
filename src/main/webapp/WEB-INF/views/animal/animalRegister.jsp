<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신규 동물 등록</title>
</head>
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

/* [3. 폼 입력 콤포넌트 구조화 (모던 UI 래핑 마스크)] */
.form-group {
    margin-bottom: 20px;
    display: flex;
    flex-direction: column;
    gap: 8px;
}

label {
    display: inline-block;
    color: #38bdf8 !important; /* 브랜드 네온 블루 라벨 처리 */
    font-size: 13.5px;
    font-weight: 700;
}

/* 다크 암청색 고도화 및 클릭 시 가이드 라이트 링 장착 */
input[type="text"], select {
    padding: 10px 12px !important;
    background: #111827 !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 6px !important;
    outline: none;
    font-size: 14px;
    width: 100% !important; /* 프레임 맞춤 너비 100% 자동 확장 */
    box-sizing: border-box;
    transition: all 0.15s ease;
}

input[type="text"]:focus, select:focus {
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
    padding: 10px 22px;
    border: 0;
    border-radius: 8px !important;
    font-weight: 700;
    font-size: 13.5px;
    cursor: pointer;
    transition: all 0.15s ease;
}

/* 등록 액션: 선명한 네온 블루 스킨 */
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

<body>
<div class="panel">
    <h2>신규 동물 등록</h2>
    
    <!-- 스프링 폼 태그를 활용한 데이터 전송 (POST) 백엔드 핵심 무결점 연동 -->
    <form:form action="${pageContext.request.contextPath}/animal/register" method="post">
        <c:if test="${param.popup eq 'true'}">
            <input type="hidden" name="popup" value="true" />
        </c:if>
        
        <!-- 투박한 table 구조를 바쇄하고 대시보드 form-group 레이아웃으로 변경 -->
        <div class="form-group">
            <label>축종 구분</label>
            <!-- DB 공통코드 테이블 가변 동적 연동 목록 루프 완벽 보존 -->
            <select name="animalType">
                <c:forEach var="code" items="${animalTypeList}">
                    <option value="${code.code}">${code.codeName} (${code.code})</option>
                </c:forEach>
            </select>
        </div>
        
        <div class="form-group">
            <label>품종</label>
            <input type="text" name="animalBreed" placeholder="예: 말티즈, 진돗개" required="required" />
        </div>
        
        <div class="form-group">
            <label>동물 이름</label>
            <input type="text" name="animalName" placeholder="동물 이름을 입력하세요" required="required" />
        </div>
        
        <div class="form-group">
            <label>보호 상태</label>
            <!-- 프론트엔드 코드 매핑 데이터 구조 유지 -->
            <select name="animalStatus">
                <c:forEach var="animalStatus" items="${animalStatusList}">
                    <option value="${animalStatus.code}">${animalStatus.codeName}</option>
                </c:forEach>
            </select>
        </div>
        
        <!-- 하이테크 스타일 규격 단추 마감 -->
        <div class="btn-group">
            <button type="submit">등록</button>
            <button type="button" class="btn-cancel" 
                    onclick="return closePopupAndRefreshParent('${pageContext.request.contextPath}/animal/list');">취소</button>
        </div>
    </form:form>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>
</html>
