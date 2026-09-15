<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관제 탐지 상황 상세정보</title>
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
    max-width: 750px; /* 상세 정보 및 대형 스냅샷 배치용 최적 너비 */
    margin: 0 auto;
}

.panel h2 {
    color: #ffffff !important;
    margin: 0 0 24px 0 !important;
    font-size: 20px !important;
    font-weight: 700 !important;
    letter-spacing: -0.02em;
    text-align: left;
    border-bottom: 1px solid #1e293b;
    padding-bottom: 12px;
}

/* [3. 상세 데이터 테이블(그리드) 마스크 정의] */
table {
    width: 100%;
    border-collapse: separate !important;
    border-spacing: 0 !important;
    margin-top: 16px;
    background-color: transparent !important;
    box-shadow: none !important;
    border: 1px solid #1e293b !important;
    border-radius: 8px;
    overflow: hidden;
}

th {
    background-color: #111827 !important; /* 사이드바와 일치하는 다크 톤 */
    color: #38bdf8 !important; /* 브랜드 정체성 네온 블루 컬러 각인 */
    padding: 14px 16px !important;
    font-size: 13.5px;
    font-weight: 700;
    text-align: left !important; /* 수직 뷰 가독성을 위해 헤더 좌측 정렬 */
    width: 160px;
    border: 0 !important;
    border-bottom: 1px solid #1e293b !important;
    border-right: 1px solid #1e293b !important; /* 내부 세로 구분선 마감 */
}

td {
    padding: 14px 16px !important;
    background-color: transparent !important;
    color: #cbd5e1 !important;
    font-size: 14px;
    text-align: left !important; /* 콘텐츠 좌측 정렬 */
    border: 0 !important;
    border-bottom: 1px solid #1e293b !important;
    vertical-align: middle !important;
}

/* 마지막 행 하단 선 보정 마감 */
tr:last-child th, tr:last-child td {
    border-bottom: 0 !important;
}

/* 행 호버 인터랙션 (0초 피드백) */
tbody tr:hover td {
    background-color: rgba(30, 41, 59, 0.4) !important;
    color: #ffffff !important;
}
tbody tr:hover th {
    background-color: rgba(17, 24, 39, 0.8) !important;
}

/* 📌 상세화면 전용 대형 스냅샷 대시보드 맞춤 커스텀 스킨 */
.detail-snapshot {
    max-width: 600px;
    width: 100%;
    height: auto;
    border: 1px solid #334155 !important;
    border-radius: 8px !important;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5) !important;
    background-color: #111827;
}

/* [4. 조작 버튼 및 입력 UI 콤포넌트 모던화] */
select, textarea {
    padding: 10px 12px !important;
    background: #111827 !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 6px !important;
    outline: none;
    font-size: 14px;
    box-sizing: border-box;
    transition: all 0.15s ease;
}

select {
    width: 220px !important;
}

textarea {
    width: 100% !important; /* 컨테이너 맞춤 너비 자동 확장 */
    resize: vertical;
}

select:focus, textarea:focus {
    border-color: #0ea5e9 !important;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25) !important;
}

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

/* 조치 내용 저장 액션: 선명한 네온 블루 스킨 */
button[type="submit"] {
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
}
button[type="submit"]:hover {
    background-color: #0284c7 !important;
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
    <h2>탐지 상황 상세 내용 및 현장 조치</h2>
    
    <form:form action="${pageContext.request.contextPath}/detection/modify" method="post">
        <!-- 페이징/검색 데이터 유지를 위한 하이딩 파라미터 무결점 보존 -->
        <input type="hidden" name="page" value="${pageMaker.page}" />
        <input type="hidden" name="searchType" value="${pageMaker.searchType}" />
        <input type="hidden" name="keyword" value="${pageMaker.keyword}" />
        <input type="hidden" name="popup" value="true" />
        <input type="hidden" name="dlogId" value="${detection.dlogId}" />
        
        <!-- 하이테크 스킨 구조화 상세 그리드 -->
        <table>
            <tbody>
                <tr>
                    <th>로그 번호</th>
                    <td>${detection.dlogId}</td>
                </tr>
                <tr>
                    <th>드론 기체 ID</th>
                    <td style="font-weight: bold; color: #ffffff;">${detection.droneId}</td>
                </tr>
                <tr>
                    <th>포착 객체 (축종)</th>
                    <td style="font-weight: bold; color: #ffffff;">
                        ${detection.animalType} (${detection.detectCount} 마리)
                    </td>
                </tr>
                <tr>
                    <th>최초 감지 시각</th>
                    <td><fmt:formatDate value="${detection.detectTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                </tr>
                <tr>
                    <th>드론 스냅샷 영상</th>
                    <td>
                        <!-- 스트림 가상 경로 독립 연동 유지 및 썸네일 대형 마스크 바인딩 -->
                        <img src="${pageContext.request.contextPath}/detection/getSnapshot?dlogId=${detection.dlogId}" 
                             alt="드론 포착 스냅샷" 
                             class="detail-snapshot"
                             onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';" />
                    </td>
                </tr>
                <tr>
                    <th>관제원 현장 조치</th>
                    <td>
                        <!-- 기존 가변 데이터 바인딩 셀렉트 구조 유지 -->
        <select name="actionStatus">
            <c:forEach var="actionStatus" items="${actionStatusList}">
                <option value="${actionStatus.code}" ${detection.actionStatus == actionStatus.code ? 'selected' : ''}>${actionStatus.codeName}</option>
            </c:forEach>
        </select>
                    </td>
                </tr>
                <tr>
                    <th>현장 조치 사유/내용</th>
                    <td>
                        <!-- c:out 변수 출력 매핑 무결점 유지 -->
                        <textarea name="actionReason" rows="5" placeholder="출동 요청, 상황 전파 등 구체적인 조치 이력을 기록하세요." required="required"><c:out value="${detection.actionReason}" /></textarea>
                    </td>
                </tr>
            </tbody>
        </table>
        
        <!-- 하이테크 스타일 규격으로 다듬어진 버튼 그룹 -->
        <div class="btn-group">
            <button type="submit">조치 내용 저장</button>
            <button type="button" class="btn-list" onclick="fn_goList()">목록으로</button>
        </div>
    </form:form>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>

<script>
/* 보던 페이지 컨텍스트 복귀 스크립트 기능 원본 100% 보존 */
function fn_goList() {
    return closePopupAndRefreshParent("${pageContext.request.contextPath}/detection/list"
        + "?page=${pageMaker.page}"
        + "&searchType=${pageMaker.searchType}"
        + "&keyword=${pageMaker.keyword}");
}
</script>
</html>
