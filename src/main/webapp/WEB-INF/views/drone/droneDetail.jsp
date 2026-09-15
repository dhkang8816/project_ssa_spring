<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>드론 상세 정보</title>
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
    max-width: 500px; /* 입력 및 상세 폼 최적화 너비 제한 */
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

/* [3. 폼 입력 콤포넌트 구조화 (모던 UI 래핑)] */
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

/* 배정 수정 액션: 선명한 네온 블루 스킨 */
button.btn-modify {
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
}
button.btn-modify:hover {
    background-color: #0284c7 !important;
}

/* 기체 삭제 액션: 경고용 네온 레드 스킨 */
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
</head>
<body>
<div class="panel">
    <h2>드론 상세</h2>
    
    <form:form id="droneForm" method="post">
        <input type="hidden" name="popup" value="true" />
        <!-- 페이징/검색 데이터 유지 파라미터 무결점 보존 -->
        <input type="hidden" name="page" value="${pageMaker.page}" />
        <input type="hidden" name="searchType" value="${pageMaker.searchType}" />
        <input type="hidden" name="keyword" value="${pageMaker.keyword}" />
        
        <!-- 구조적인 form-group 레이아웃 모델 적용 마감 -->
        <div class="form-group">
            <label>드론 기체 ID</label>
            <!-- 문자열 식별키(PK) 수정을 방지하는 readonly 마스크 스킨 바인딩 -->
            <input type="text" name="droneId" value="${drone.droneId}" readonly="readonly" />
        </div>
        
        <div class="form-group">
            <label>담당 관제원 변경</label>
            <!-- 기존 배정된 사람을 자동으로 select 해주는 가변 목록 구조 연동 보존 -->
            <select name="memberId">
                <option value="">-- 담당 관제원 선택 (미배정) --</option>
                <c:forEach var="member" items="${memberList}">
                    <option value="${member.memberId}" ${drone.memberId == member.memberId ? 'selected="selected"' : ''}>
                        ${member.name} (${member.memberId})
                    </option>
                </c:forEach>
            </select>
        </div>
        
        <!-- 관제 센터 대시보드 버튼 셋 배치 -->
        <div class="btn-group">
            <button type="button" class="btn-modify" onclick="fn_submit('modify')">배정 수정</button>
            <button type="button" class="btn-delete" onclick="fn_submit('remove')">기체 삭제</button>
            <button type="button" class="btn-list" onclick="fn_goList()">목록으로</button>
        </div>
    </form:form>
    
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>

<script>
/* 모드별 안전 확인 및 동적 액션 Submit 처리 함수 원본 기능 100% 유지 */
function fn_submit(mode) {
    var form = document.getElementById("droneForm");
    if (mode === 'modify') {
        if (!confirm("드론 배정 정보를 수정하시겠습니까?"))
            return;
        form.action = "${pageContext.request.contextPath}/drone/modify";
    } else if (mode === 'remove') {
        if (!confirm("정말로 이 드론 기체를 삭제하시겠습니까?"))
            return;
        form.action = "${pageContext.request.contextPath}/drone/remove";
    }
    form.submit();
}

function fn_goList() {
    return closePopupAndRefreshParent("${pageContext.request.contextPath}/drone/list"
        + "?page=${pageMaker.page}"
        + "&searchType=${pageMaker.searchType}"
        + "&keyword=${pageMaker.keyword}");
}
</script>
</html>
