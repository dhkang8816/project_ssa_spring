<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공통코드 상세 및 수정</title>
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

/* 읽기 전용(readonly) 비활성화 입력 상자 마스크 재정의 */
input[readonly] {
    background-color: rgba(30, 41, 59, 0.5) !important;
    color: #64748b !important;
    border: 1px solid #1e293b !important;
    cursor: not-allowed !important;
}

/* [4. 조작 버튼 UI 콤포넌트 규격화] */
.btn-group {
    margin-top: 28px;
    display: flex;
    gap: 8px;
    justify-content: flex-end;
}

button {
    padding: 10px 18px;
    border: 0;
    border-radius: 8px !important;
    font-weight: 700;
    font-size: 13.5px;
    cursor: pointer;
    transition: all 0.15s ease;
}

/* 정보 수정 액션: 선명한 네온 블루 스킨 */
button.btn-modify {
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
}
button.btn-modify:hover {
    background-color: #0284c7 !important;
}

/* 코드 삭제 액션: 경고용 네온 레드 스킨 */
button.btn-delete {
    background-color: #ef4444 !important;
    color: #ffffff !important;
}
button.btn-delete:hover {
    background-color: #dc2626 !important;
}

/* 목록으로 액션: 차분한 무채색 다크 그레이 스킨 */
button.btn-list {
    background-color: #1e293b !important;
    color: #cbd5e1 !important;
    border: 1px solid #334155 !important;
}
button.btn-list:hover {
    background-color: #334155 !important;
    color: #ffffff !important;
}
</style>
</head>
<body>
<div class="panel">
    <h2>시스템 코드 정보</h2>
    <form:form name="detailForm" method="post">
        <input type="hidden" name="popup" value="true" />
        
        <!-- 복합키 진입 영역 (수정 불가능 readonly 마스크 유지) -->
        <div class="form-group">
            <label>그룹코드:</label> 
            <input type="text" name="grpCode" value="${ccVO.grpCode}" readonly />
        </div>
        
        <div class="form-group">
            <label>상세코드:</label> 
            <input type="text" name="code" value="${ccVO.code}" readonly />
        </div>
        
        <!-- 수정 가능한 비즈니스 데이터 영역 -->
        <div class="form-group">
            <label>코드명칭:</label> 
            <input type="text" name="codeName" value="${ccVO.codeName}" required />
        </div>
        
        <div class="form-group">
            <label>정렬순서:</label> 
            <input type="number" name="sortSeq" value="${ccVO.sortSeq}" required />
        </div>
        
        <div class="form-group">
            <label>사용여부:</label> 
            <select name="useYn">
                <option value="Y" ${ccVO.useYn == 'Y' ? 'selected' : ''}>사용 (Y)</option>
                <option value="N" ${ccVO.useYn == 'N' ? 'selected' : ''}>미사용 (N)</option>
            </select>
        </div>
        
        <!-- 하이테크 스타일 규격으로 통합 배치된 하단 조작 버튼 그룹 -->
        <div class="btn-group">
            <!-- 정보 수정 완료 처리 -->
            <button type="submit" class="btn-modify"
                    onclick="this.form.action='${pageContext.request.contextPath}/commoncode/modify'">정보 수정</button>
            
            <!-- 삭제 안전 처리 검증 스크립트 연동 함수 호출 -->
            <button type="button" class="btn-delete" onclick="fnDelete();">코드 삭제</button>
            
            <!-- 단순 목록 이동 -->
            <button type="button" class="btn-list"
                    onclick="location.href='${pageContext.request.contextPath}/commoncode/list'">목록으로</button>
        </div>
        
    </form:form>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>

<script>
// 삭제 요청 시 안전 확인용 얼럿 팝업 제어 함수 (기본 폼 submit 서브밋 분기 완전 유지)
function fnDelete() {
    if (confirm("정말로 이 코드를 삭제하시겠습니까?")) {
        var form = document.detailForm;
        form.action = "${pageContext.request.contextPath}/commoncode/remove";
        form.submit();
    }
}
</script>
</html>

