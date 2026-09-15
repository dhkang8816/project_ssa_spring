<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
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

/* 읽기 전용(readonly) 식별키 비활성화 입력 상자 마스크 재정의 */
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

/* 수정 완료 액션: 선명한 네온 블루 스킨 */
button.btn-modify {
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
}
button.btn-modify:hover {
    background-color: #0284c7 !important;
}

/* 동물 삭제 액션: 경고용 네온 레드 스킨 */
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

/* 메인 링크 튜닝 */
a.main-link {
    color: #38bdf8 !important;
    font-weight: 600;
    text-decoration: none;
    display: inline-block;
    margin-top: 20px;
    font-size: 13.5px;
    transition: color 0.15s ease;
}
a.main-link:hover {
    color: #7dd3fc !important;
    text-decoration: underline !important;
}
</style>

<meta charset="UTF-8">
<title>보호 동물 상세 정보</title>
</head>
<body>
<div class="panel">
    <h2>보호 동물 상세</h2>
    
    <!-- 수정 및 삭제 처리를 위한 폼 태그 백엔드 핵심 무결점 연동 -->
    <form:form id="detailForm" method="post">
        <input type="hidden" name="popup" value="true" />
        <!-- 컨트롤러의 PageMaker 바인딩을 위한 페이징/검색 데이터 유지 -->
        <input type="hidden" name="page" value="${pageMaker.page}" />
        <input type="hidden" name="searchType" value="${pageMaker.searchType}" />
        <input type="hidden" name="keyword" value="${pageMaker.keyword}" />
        
        <!-- 투박한 table 구조를 파쇄하고 구조적인 form-group 레이아웃 모델 적용 -->
        <div class="form-group">
            <label>동물 식별 번호</label>
            <input type="text" name="animalId" value="${animal.animalId}" readonly="readonly" />
        </div>
        
        <div class="form-group">
            <label>축종 구분</label>
            <!-- DB 목록을 뽑으면서 기존에 선택된 축종에 selected 자동 매핑 로직 보존 -->
            <select name="animalType">
                <c:forEach var="code" items="${animalTypeList}">
                    <option value="${code.code}" ${animal.animalType == code.code ? 'selected="selected"' : ''}>
                        ${code.codeName} (${code.code})
                    </option>
                </c:forEach>
            </select>
        </div>
        
        <div class="form-group">
            <label>품종</label>
            <input type="text" name="animalBreed" value="${animal.animalBreed}" required="required" />
        </div>
        
        <div class="form-group">
            <label>동물 이름</label>
            <input type="text" name="animalName" value="${animal.animalName}" required="required" />
        </div>
        
        <div class="form-group">
            <label>입소 날짜</label>
            <input type="text" value="<fmt:formatDate value="${animal.entranceDate}" pattern="yyyy-MM-dd HH:mm:ss"/>" readonly="readonly" />
        </div>
        
        <div class="form-group">
            <label>보호 상태</label>
            <!-- 교정한 보호상태 매핑 반영 (0: 보호중, 1: 입양, 2: 퇴소) -->
            <select name="animalStatus">
                <c:forEach var="animalStatus" items="${animalStatusList}">
                    <option value="${animalStatus.code}" ${animal.animalStatus == animalStatus.code ? 'selected="selected"' : ''}>${animalStatus.codeName}</option>
                </c:forEach>
            </select>
        </div>
        
        <!-- 하이테크 스타일 규격으로 통합 배치된 하단 조작 버튼 그룹 -->
        <div class="btn-group">
            <button type="button" class="btn-modify" onclick="fn_submit('modify')">수정 완료</button>
            <button type="button" class="btn-delete" onclick="fn_submit('remove')">동물 삭제</button>
            <button type="button" class="btn-list" onclick="fn_goList()">목록으로</button>
        </div>
    </form:form>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>

<script>
// 버튼 하나로 수정/삭제 주소를 동적으로 분기하는 레거시 표준 자바스크립트 함수 원본 100% 유지
function fn_submit(mode) {
    var form = document.getElementById("detailForm");
    if (mode === 'modify') {
        if (!confirm("동물 정보를 수정하시겠습니까?"))
            return;
        form.action = "${pageContext.request.contextPath}/animal/modify";
    } else if (mode === 'remove') {
        if (!confirm("정말로 이 동물 데이터를 삭제하시겠습니까?\n(삭제 시 개체수 대시보드에서 1마리가 자동 감소합니다.)"))
            return;
        form.action = "${pageContext.request.contextPath}/animal/remove";
    }
    form.submit();
}

// 기존 검색조건과 페이지 번호를 유지한 채 목록으로 안전하게 복귀시키는 함수
function fn_goList() {
    return closePopupAndRefreshParent("${pageContext.request.contextPath}/animal/list"
        + "?page=${pageMaker.page}"
        + "&searchType=${pageMaker.searchType}"
        + "&keyword=${pageMaker.keyword}");
}
</script>
</html>
