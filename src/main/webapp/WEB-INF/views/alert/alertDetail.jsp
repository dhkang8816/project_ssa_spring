<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>경보 이력 상세조회</title>
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
    max-width: 650px; /* 상세 조회 화면 최적화 너비 제한 */
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
    color: #38bdf8 !important; /* 브랜드 네온 블루 컬러 각인 */
    padding: 14px 16px !important;
    font-size: 13.5px;
    font-weight: 700;
    text-align: left !important; /* 수직 뷰 가독성을 위해 헤더 좌측 정렬 */
    width: 180px; /* 라벨 명칭 길이를 고려한 안정적 너비 확보 */
    border: 0 !important;
    border-bottom: 1px solid #1e293b !important;
    border-right: 1px solid #1e293b !important; /* 내부 세로 구분선 스킨 */
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

/* 취소/목록/메인 단순 조작 버튼: 차분한 무채색 다크 그레이 스킨 */
button.btn-control {
    background-color: #1e293b !important;
    color: #cbd5e1 !important;
    border: 1px solid #334155 !important;
}
button.btn-control:hover {
    background-color: #334155 !important;
    color: #ffffff !important;
}
</style>
</head>
<body>
<div class="panel">
    <h2>시스템 경보 이력</h2>
    
    <!-- 하이테크 스킨 구조화 상세 그리드 (기존 인라인 스타일 백업 제거 후 마스크 매핑) -->
    <table>
        <tbody>
            <tr>
                <th>경보번호</th>
                <td>${alert.alertId}</td>
            </tr>
            <tr>
                <th>경보대상구분</th>
                <td>${alert.alertType}</td>
            </tr>
            <tr>
                <th>경보알림메세지내용</th>
                <!-- pre-wrap 구조 속성이 유효하게 유지되도록 스타일 결합 -->
                <td style="white-space: pre-wrap !important;"><c:out value="${alert.alertMsg}" /></td>
            </tr>
            <tr>
                <th>전송성공여부</th>
                <td>${alert.sendStatus}</td>
            </tr>
            <tr>
                <th>탐지이력시퀀스</th>
                <td>${empty alert.dlogId ? '-' : alert.dlogId}</td>
            </tr>
            <tr>
                <th>이상객체탐지시퀀스</th>
                <td>${empty alert.danlogId ? '-' : alert.danlogId}</td>
            </tr>
            <tr>
                <th>최초경보시각</th>
                <td><fmt:formatDate value="${alert.firstSendTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
            </tr>
            <tr>
                <th>경보전송일시</th>
                <td><fmt:formatDate value="${alert.sendDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
            </tr>
        </tbody>
    </table>
    
    <!-- 하단 제어 버튼 영역 (기존 프로젝트 기능 및 히스토리 포워딩 복귀 로직 100% 무결점 보존) -->
    <div class="btn-group">
        <!-- 목록 돌아가기 버튼: 가장 안전하고 깔끔한 대안 방식 유지 -->
        <button type="button" class="btn-control" onclick="return closePopupAndRefreshParent('${pageContext.request.contextPath}/alert/list');">목록으로</button>
    </div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>
</html>
