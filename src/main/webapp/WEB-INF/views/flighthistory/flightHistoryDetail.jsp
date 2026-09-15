<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비행 이력 상세 정보</title>
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

/* [2. 메인 패널 프레임 스킨 및 타이틀] */
.panel {
    background: rgba(20, 26, 42, 0.85) !important;
    border: 1px solid #1e293b !important;
    border-radius: 16px;
    padding: 28px !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
    backdrop-filter: blur(4px);
    max-width: 600px; /* 상세 뷰 최적화 너비 제한 */
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
    color: #38bdf8 !important; /* 브랜드 네온 블루 컬러 각인 */
    padding: 14px 16px !important;
    font-size: 13.5px;
    font-weight: 700;
    text-align: left !important; /* 수직 뷰 가독성을 위해 헤더 좌측 정렬 */
    width: 160px;
    border: 0 !important;
    border-bottom: 1px solid #1e293b !important;
    border-right: 1px solid #1e293b !important; /* 구분선 스킨 추가 */
}

td {
    padding: 14px 16px !important;
    background-color: transparent !important;
    color: #cbd5e1 !important;
    font-size: 14px;
    text-align: left !important; /* 콘텐츠 좌측 정렬 */
    border: 0 !important;
    border-bottom: 1px solid #1e293b !important;
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

/* 이력 로그 삭제: 경고용 네온 레드 스킨 */
button.btn-delete {
    background-color: #ef4444 !important;
    color: #ffffff !important;
}
button.btn-delete:hover {
    background-color: #dc2626 !important;
}

/* 목록으로: 차분한 무채색 다크 그레이 스킨 */
button.btn-list {
    background-color: #1e293b !important;
    color: #cbd5e1 !important;
    border: 1px solid #334155 !important;
}
button.btn-list:hover {
    background-color: #334155 !important;
    color: #ffffff !important;
}

/* [5. 공통 알약 배지(Badge) 정의] */
.badge-status {
    padding: 4px 12px !important;
    border-radius: 20px !important;
    font-size: 11.5px !important;
    font-weight: 700 !important;
    display: inline-block;
}

/* 집계불가/정지: 반투명 레드 패널 핏 */
.badge-status.rejected {
    background-color: rgba(239, 68, 68, 0.15) !important;
    color: #ef4444 !important;
    border: 1px solid rgba(239, 68, 68, 0.3) !important;
}
</style>
</head>
<body>
<div class="panel">
    <h2>드론 상세 비행 세부 내역</h2>
    
    <form:form id="historyForm" method="post">
        <input type="hidden" name="popup" value="true" />
        <!-- 페이징/검색 데이터 유지를 위한 하이딩 파라미터 무결점 보존 -->
        <input type="hidden" name="page" value="${pageMaker.page}" />
        <input type="hidden" name="searchType" value="${pageMaker.searchType}" />
        <input type="hidden" name="keyword" value="${pageMaker.keyword}" />
        <input type="hidden" name="flightId" value="${flightHistory.flightId}" />
        
        <!-- 하이테크 스킨 구조화 상세 그리드 -->
        <table>
            <tbody>
                <tr>
                    <th>비행 이력 번호</th>
                    <td>${flightHistory.flightId}</td>
                </tr>
                <tr>
                    <th>드론 기체 고유 ID</th>
                    <td style="font-weight: bold; color: #ffffff;">${flightHistory.droneId}</td>
                </tr>
                <tr>
                    <th>비행 시작 시각</th>
                    <td><fmt:formatDate value="${flightHistory.startTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                </tr>
                <tr>
                    <th>비행 종료 시각</th>
                    <td><fmt:formatDate value="${flightHistory.endTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                </tr>
                <tr>
                    <th>총 누적 비행 시간</th>
                    <td>${flightHistory.flightDuration} 시간</td>
                </tr>
                <tr>
                    <th>배터리 총 소모량</th>
                    <td>
                        <c:choose>
                            <c:when test="${empty flightHistory.batteryConsumption}">
                                <!-- 기존 단순 텍스트를 시스템 규격 알약 배지로 전면 치환 -->
                                <span class="badge-status rejected">집계불가</span>
                            </c:when>
                            <c:otherwise>${flightHistory.batteryConsumption} %</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>관제 데이터 등록일</th>
                    <td><fmt:formatDate value="${flightHistory.flightDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                </tr>
            </tbody>
        </table>
        
        <!-- 하이테크 관제 단추 컴포넌트 정돈 마감 -->
        <div class="btn-group">
            <button type="button" class="btn-delete" onclick="fn_delete()">이력 로그 삭제</button>
            <button type="button" class="btn-list" onclick="fn_goList()">목록으로</button>
        </div>
    </form:form>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>

<script>
/* 비행 이력 안전 삭제 및 동적 컨텍스트 라우팅 스크립트 기능 100% 유지 */
function fn_delete() {
    if (!confirm("정말로 이 드론의 비행 이력 데이터를 시스템에서 영구 삭제하시겠습니까?")) {
        return;
    }
    var form = document.getElementById("historyForm");
    form.action = "${pageContext.request.contextPath}/flighthistory/remove";
    form.submit();
}

function fn_goList() {
    return closePopupAndRefreshParent("${pageContext.request.contextPath}/flighthistory/list"
        + "?page=${pageMaker.page}"
        + "&searchType=${pageMaker.searchType}"
        + "&keyword=${pageMaker.keyword}");
}
</script>
</html>
