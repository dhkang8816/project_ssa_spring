<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>이상 객체 마스터 목록</title>
<style>
/* [1. 레이아웃 및 여백 규격] */
body {
    background-color: #0b0f19 !important; /* 깊은 사이버 다크 톤 강제 적용 */
    color: #e2e8f0 !important;
    font-family: 'Segoe UI', Roboto, 'Malgun Gothic', sans-serif;
    margin: 0;
    padding: 0;
    overflow-x: hidden;
}

/* 초슬림 사이드바 폭(150px)과 헤더 높이(80px)에 맞춰 정밀 좌측 밀착 정렬 */
.control-page-content {
    position: absolute !important;
    top: 80px !important;
    left: 150px !important;
    width: calc(100% - 150px) !important;
    padding: 30px 40px;
    box-sizing: border-box;
    z-index: 50 !important;
}

@media (max-width: 760px) {
    .control-page-content {
        left: 0 !important;
        width: 100% !important;
        padding: 20px 16px;
    }
}

/* [2. 타이틀 및 카드 프레임 스킨] */
.panel {
    background: rgba(20, 26, 42, 0.85) !important;
    border: 1px solid #1e293b !important;
    border-radius: 16px;
    padding: 28px !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
    backdrop-filter: blur(4px);
    width: 100%;
    box-sizing: border-box;
}

.panel h2 {
    color: #ffffff;
    margin: 0 0 24px 0 !important;
    font-size: 20px;
    font-weight: 700;
    letter-spacing: -0.02em;
    text-align: left;
}

/* 검색 상자 프레임 고도화 */
.search-box {
    margin: 20px 0;
    padding: 20px;
    background: rgba(17, 24, 39, 0.6) !important;
    border: 1px solid #1e293b !important;
    border-radius: 12px;
}

/* [3. 데이터 테이블(그리드) 마스크 정의] */
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
    background-color: #111827 !important; /* 다크 톤 일체화 */
    color: #38bdf8 !important; /* 브랜드 네온 블루 컬러 각인 */
    padding: 14px 16px !important;
    font-size: 13px;
    font-weight: 700;
    text-align: center !important; /* 전체 중앙 정렬 마스크 */
    border: 0 !important;
    border-bottom: 2px solid #1e293b !important;
}

td {
    padding: 14px 16px !important;
    background-color: transparent !important;
    color: #cbd5e1 !important;
    font-size: 13.5px;
    text-align: center !important; /* 가독성을 위한 전체 중앙 정렬 */
    border: 0 !important;
    border-bottom: 1px solid #1e293b !important;
}

/* 행 호버 인터랙션 (0초 피드백) */
tr {
    transition: background-color 0s ease;
}

tbody tr:hover td {
    background-color: rgba(30, 41, 59, 0.6) !important;
    color: #ffffff !important;
}

.no-data {
    padding: 60px !important;
    color: #64748b !important;
    font-size: 14px;
}

/* [4. 조작 버튼 및 입력 UI 콤포넌트 모던화] */
form {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    align-items: center;
    color: #cbd5e1;
    font-size: 13.5px;
}

input[type="text"], select {
    padding: 8px 12px;
    background: #111827 !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 6px;
    outline: none;
    font-size: 13.5px;
    transition: all 0.15s ease;
}

input[type="text"]:focus, select:focus {
    border-color: #0ea5e9 !important;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25);
}

/* 텍스트 링크 전용 튜닝 */
a.main-link {
    color: #38bdf8 !important;
    font-weight: 600;
    text-decoration: none;
    display: inline-block;
    margin-top: 20px;
    transition: color 0.15s ease;
}

a.main-link:hover {
    color: #7dd3fc !important;
    text-decoration: underline !important;
}

/* 액션 단추 규격 세팅 */
button {
    padding: 9px 16px;
    border: 0;
    border-radius: 8px !important;
    font-weight: 700;
    font-size: 13.5px;
    cursor: pointer;
    transition: all 0.15s ease;
}

/* 신규 등록 액션: 청량한 네온 그린 스킨 */
button.btn-register {
    background-color: #10b981 !important;
    color: #ffffff !important;
}
button.btn-register:hover {
    background-color: #059669 !important;
}

/* 검색 단추: 선명한 네온 블루 스킨 */
button.btn-search {
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
}
button.btn-search:hover {
    background-color: #0284c7 !important;
}

/* [5. 하단 페이징 내비게이션 표준 규격] */
.pagination {
    display: flex;
    list-style: none;
    gap: 6px;
    justify-content: center;
    padding: 0;
    margin: 0 !important;
}

.pagination li {
    margin: 0 !important;
}

.pagination a, .pagination strong {
    display: block;
    padding: 6px 12px;
    background: #111827 !important;
    color: #94a3b8 !important;
    border: 1px solid #1e293b;
    border-radius: 6px;
    text-decoration: none;
    font-size: 13px;
    font-weight: 600;
    transition: all 0.15s;
}

.pagination a:hover {
    color: #ffffff !important;
    background: #1f2937 !important;
    border-color: #334155;
}

/* 현재 활성화된 페이지 번호 강조색 변경 (기존의 red 스타일 영구 파쇄) */
.pagination li.active strong, .pagination strong {
    color: #38bdf8 !important;
    background: rgba(14, 165, 233, 0.15) !important;
    border-color: #0ea5e9 !important;
}

@media (max-width: 760px) {
    table {
        display: block;
        overflow-x: auto;
        white-space: nowrap;
    }
}
/* 직원관리 기준 목록 레이아웃 */
.panel { display:grid !important; grid-template-columns:minmax(180px,1fr) auto; grid-template-areas:"title search" "summary action" "table table" "pager pager"; gap:20px; padding:0 !important; background:transparent !important; border:0 !important; box-shadow:none !important; overflow-x:auto; }.panel > h2 { grid-area:title; margin:0 !important; padding:0 0 16px; border-bottom:1px solid #1e293b; color:#fff !important; font-size:22px !important; }.panel > br { display:none; }.panel > .staff-list-summary { grid-area:summary; color:#94a3b8; font-size:14px; font-weight:500; }.panel > .staff-list-summary strong { color:#38bdf8; background:rgba(56,189,248,.1); border-radius:4px; padding:2px 6px; }.panel > .search-box { grid-area:search; justify-self:end; margin:0 !important; }.panel > div[style*="margin-bottom"] { grid-area:action; justify-self:end; margin:0 !important; }.panel > table { grid-area:table; min-width:850px; margin:0 !important; }.panel > table th,.panel > table td { white-space:nowrap; }.panel > div[style*="margin-top"] { grid-area:pager; justify-self:center; margin:0 !important; }@media(max-width:760px){.panel{grid-template-columns:1fr;grid-template-areas:"title" "search" "summary" "action" "table" "pager"}.panel > .search-box,.panel > div[style*="margin-bottom"]{justify-self:stretch}}
</style>

</head>
<body>
<!-- 기존 상단/메뉴 인클루드 보존 -->
<jsp:include page="/WEB-INF/views/menu.jsp" />
<jsp:include page="/WEB-INF/views/header.jsp" />

<!-- 메인 관제 페이지 레이아웃 본문 래퍼 -->
<div class="control-page-content">
    <div class="panel">
        
        <h2>이상 객체 목록</h2>
        <div class="staff-list-summary">총 <strong>${pageMaker.totalCount}</strong>건</div>
        
        <!-- 신규 이상 객체 등록 페이지 이동 버튼 (네온 그린 스킨 클래스 배정) -->
        <div style="margin-bottom: 15px; text-align: left;">
            <button type="button" class="btn-register"
                    onclick="return openFormPopup('${pageContext.request.contextPath}/danger/register', 'dangerRegister');">
                신규 객체 등록
            </button>
        </div>
        
        <!-- 하이테크 스타일 규격 연동 마스터 그리드 -->
        <table data-csv-export data-csv-filename="danger-list">
            <thead>
                <tr>
                    <th style="width: 150px;">식별번호</th>
                    <th>이상 객체 이름</th>
                    <th style="width: 200px;">등록일자</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty dangerList}">
                        <tr>
                            <td colspan="3" class="no-data">등록된 이상 객체 종류가 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="danger" items="${dangerList}">
                            <!-- 기존 팝업 함수 연동 및 페이징/검색 파라미터 컨텍스트 홀딩 무결점 보존 -->
                            <tr style="cursor: pointer;"
                                onclick="return openDetailPopup('${pageContext.request.contextPath}/danger/detail?dangerId=${danger.dangerId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}', 'dangerDetail');">
                                <td style="font-weight: bold;">${danger.dangerId}</td>
                                <!-- 가독성을 고려하여 명칭 셀은 좌측 정렬 마감 처리 -->
                                <td style="text-align: left; padding-left: 20px !important;"><c:out value="${danger.dangerName}" /></td>
                                <td><fmt:formatDate value="${danger.dangerDate}" pattern="yyyy-MM-dd" /></td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
                <!-- 검색 폼 영역 (n: 이상객체이름 커스텀 매퍼 구조 보존) -->
        <div class="search-box">
            <form:form action="list" method="get">
                <select name="searchType">
                    <option value="n" ${pageMaker.searchType == 'n' ? 'selected' : ''}>이상 객체 이름</option>
                </select>
                <input type="text" name="keyword" value="${pageMaker.keyword}" placeholder="검색어 입력">
                <button type="submit" class="btn-search">검색</button>
            </form:form>
        </div>
        <!-- 하단 페이징 버튼 영역 (기존 수식 및 동적 바인딩 완전 보존) -->
        <div style="margin-top: 25px;">
            <ul class="pagination">
                <c:if test="${pageMaker.prev}">
                    <li>
                        <a href="list?page=${pageMaker.startPage - 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">&laquo; 이전</a>
                    </li>
                </c:if>
                <c:forEach var="pageNum" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                    <li class="${pageMaker.page == pageNum ? 'active' : ''}">
                        <c:choose>
                            <c:when test="${pageMaker.page == pageNum}">
                                <strong>${pageNum}</strong>
                            </c:when>
                            <c:otherwise>
                                <a href="list?page=${pageNum}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">${pageNum}</a>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </c:forEach>
                <c:if test="${pageMaker.next}">
                    <li>
                        <a href="list?page=${pageMaker.endPage + 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">다음 &raquo;</a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</div>
</body>

<script>
// 시스템 조치 알럿 조건 분기 로직 완전 보존
var msg = "${msg}";
if (msg === "REGISTER_SUCCESS") {
    alert("신규 이상 객체가 마스터에 등록되었습니다.");
}
if (msg === "MODIFY_SUCCESS") {
    alert("이상 객체 정보가 수정되었습니다.");
}
if (msg === "REMOVE_SUCCESS") {
    alert("이상 객체가 안전하게 삭제되었습니다.");
}
</script>
</html>
