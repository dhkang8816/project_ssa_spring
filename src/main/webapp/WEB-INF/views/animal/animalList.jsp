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
<title>보호 동물 목록</title>
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
    display: grid !important;
    grid-template-columns: minmax(180px, 1fr) auto;
    /* grid-template-areas에서 action을 search 옆이나 우측 상단으로 배치하도록 조정합니다. */
    grid-template-areas: 
        "title action" 
        "summary search" 
        "table table" 
        "pager pager"; 
    gap: 20px; 
    padding: 0 !important;
    background: transparent !important; 
    border: 0 !important;
    box-shadow: none !important; 
    overflow-x: auto; 
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
    padding: 12px 16px !important;
    background-color: transparent !important;
    color: #cbd5e1 !important;
    font-size: 13.5px;
    text-align: center !important; /* 전체 중앙 정렬 */
    border: 0 !important;
    border-bottom: 1px solid #1e293b !important;
    vertical-align: middle !important;
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

/* 메인 링크 튜닝 */
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

/* 승인 / 저장 / 현황 조회 액션: 선명한 네온 블루 스킨 */
button.btn-info {
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
}
button.btn-info:hover {
    background-color: #0284c7 !important;
}

/* [5. 공통 알약 배지(Badge) 정의] */
.badge-status {
    padding: 4px 12px !important;
    border-radius: 20px !important;
    font-size: 11.5px !important;
    font-weight: 700 !important;
    display: inline-block;
}

/* 보호중 / 대기: 반투명 오렌지 패널 핏 */
.badge-status.status-progress {
    background-color: rgba(245, 158, 11, 0.15) !important;
    color: #f59e0b !important;
    border: 1px solid rgba(245, 158, 11, 0.3) !important;
}

/* 입양 / 성공 / 정상 완료: 반투명 그린 패널 핏 */
.badge-status.status-complete {
    background-color: rgba(16, 185, 129, 0.15) !important;
    color: #10b981 !important;
    border: 1px solid rgba(16, 185, 129, 0.3) !important;
}

/* 퇴소 / 실패 / 미정 상태: 반투명 그레이 패널 핏 */
.badge-status.status-none {
    background-color: rgba(148, 163, 184, 0.15) !important;
    color: #94a3b8 !important;
    border: 1px solid rgba(148, 163, 184, 0.3) !important;
}

/* [6. 하단 페이징 내비게이션 표준 규격] */
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

/* 현재 활성화된 페이지 번호 강조색 (기존의 red 스타일 파쇄) */
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
.panel { display:grid !important; grid-template-columns:minmax(180px,1fr) auto; grid-template-areas:"title search" "summary action" "table table" "pager pager"; gap:20px; padding:0 !important; background:transparent !important; border:0 !important; box-shadow:none !important; overflow-x:auto; }.panel > h2 { grid-area:title; margin:0 !important; padding:0 0 16px; border-bottom:1px solid #1e293b; color:#fff !important; font-size:22px !important; }.panel > br { display:none; }.panel > .staff-list-summary { grid-area:summary; color:#94a3b8; font-size:14px; font-weight:500; }.panel > .staff-list-summary strong { color:#38bdf8; background:rgba(56,189,248,.1); border-radius:4px; padding:2px 6px; }.panel > .search-box { grid-area:search; justify-self:end; margin:0 !important; }.panel > .btn-register { grid-area:action; justify-self:end; margin:0 !important; }.panel > table { grid-area:table; min-width:850px; margin:0 !important; }.panel > table th,.panel > table td { white-space:nowrap; }.panel > div[style*="margin-top"] { grid-area:pager; justify-self:center; margin:0 !important; }@media(max-width:760px){.panel{grid-template-columns:1fr;grid-template-areas:"title" "search" "summary" "action" "table" "pager"}.panel > .search-box,.panel > .btn-register{justify-self:stretch}}
</style>

</head>
<body>
<!-- 기존 시스템 컴포넌트 레이아웃 인클루드 보존 -->
<jsp:include page="/WEB-INF/views/menu.jsp" />
<jsp:include page="/WEB-INF/views/header.jsp" />

<!-- 메인 관제 페이지 레이아웃 본문 래퍼 -->
<div class="control-page-content">
    <div class="panel">
        
        <h2>보호 동물 목록</h2>
        <div class="staff-list-summary">총 <strong>${pageMaker.totalCount}</strong>건</div>
        
        <!-- 조작 버튼 콤포넌트 라인 (정의된 그린/블루 사각 마감 세팅) -->
		<div class="action-buttons-group" style="grid-area: action; justify-self: end; display: flex; gap: 6px; margin: 0 !important;">
		    <button type="button" class="btn-register" 
		        onclick="return openFormPopup('${pageContext.request.contextPath}/animal/register', 'animalRegister')">
		        신규 동물 등록
		    </button>
		    <button type="button" class="btn-info" 
		        onclick="return openDetailPopup('${pageContext.request.contextPath}/animal/counterList', 'animalCounterList');">
		        개체수 현황 조회
		    </button>
		</div>
        
        <!-- 하이테크 스타일 규격 데이터 테이블 그리드 -->
        <table data-csv-export data-csv-filename="animal-list">
            <thead>
                <tr>
                    <th>식별번호</th>
                    <th>축종</th>
                    <th>품종</th>
                    <th>동물이름</th>
                    <th>입소일자</th>
                    <th>보호상태</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty animalList}">
                        <tr>
                            <td colspan="6" class="no-data">등록된 보호 동물이 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="animal" items="${animalList}">
                            <!-- 상세조회용 동적 컨텍스트 파라미터 매핑 무결점 홀딩 보존 -->
                            <tr style="cursor: pointer;"
                                onclick="return openDetailPopup('${pageContext.request.contextPath}/animal/detail?animalId=${animal.animalId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}', 'animalDetail');">
                                <td style="font-weight: bold;">${animal.animalId}</td>
                                <td>
                                    <c:set var="animalTypeName" value="${animal.animalType}" />
                                    <c:forEach var="animalType" items="${animalTypeList}">
                                        <c:if test="${animalType.code == animal.animalType}">
                                            <c:set var="animalTypeName" value="${animalType.codeName}" />
                                        </c:if>
                                    </c:forEach>
                                    <c:out value="${animalTypeName}" />
                                </td>
                                <td>${animal.animalBreed}</td>
                                <td style="color: #ffffff; font-weight: bold;">${animal.animalName}</td>
                                <td><fmt:formatDate value="${animal.entranceDate}" pattern="yyyy-MM-dd" /></td>
                                <td>
                                    <!-- 상태 표시 분기를 모던 타원형 알약 배지로 전면 치환 마감 -->
                                    <c:set var="animalStatusName" value="${animal.animalStatus}" />
                                    <c:forEach var="animalStatus" items="${animalStatusList}">
                                        <c:if test="${animalStatus.code == animal.animalStatus}">
                                            <c:set var="animalStatusName" value="${animalStatus.codeName}" />
                                        </c:if>
                                    </c:forEach>
                                    <span class="badge-status status-none"><c:out value="${animalStatusName}" /></span>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
                <!-- 검색 폼 영역 (AnimalDetailMapper 명세 바인딩 조건식 유지) -->
        <div class="search-box">
            <form:form action="list" method="get">
                <select name="searchType">
                    <option value="t" ${pageMaker.searchType == 't' ? 'selected' : ''}>축종구분</option>
                    <option value="b" ${pageMaker.searchType == 'b' ? 'selected' : ''}>품종</option>
                    <option value="n" ${pageMaker.searchType == 'n' ? 'selected' : ''}>동물이름</option>
                    <option value="s" ${pageMaker.searchType == 's' ? 'selected' : ''}>보호상태</option>
                </select>
                <select name="keyword" id="animalTypeKeyword" ${pageMaker.searchType == 't' ? '' : 'disabled'}>
                    <option value="">전체 축종</option>
                    <c:forEach var="animalType" items="${animalTypeList}">
                        <option value="${animalType.code}" ${pageMaker.keyword == animalType.code ? 'selected' : ''}>${animalType.codeName}</option>
                    </c:forEach>
                </select>
                <select name="keyword" id="animalStatusKeyword" ${pageMaker.searchType == 's' ? '' : 'disabled'}>
                    <option value="">전체 보호상태</option>
                    <c:forEach var="animalStatus" items="${animalStatusList}">
                        <option value="${animalStatus.code}" ${pageMaker.keyword == animalStatus.code ? 'selected' : ''}>${animalStatus.codeName}</option>
                    </c:forEach>
                </select>
                <input type="text" name="keyword" id="animalTextKeyword" value="${pageMaker.searchType == 't' or pageMaker.searchType == 's' ? '' : pageMaker.keyword}" placeholder="검색어 입력" ${pageMaker.searchType == 't' or pageMaker.searchType == 's' ? 'disabled' : ''}>
                <button type="submit" class="btn-info">검색</button>
            </form:form>
        </div>
        <!-- 하단 페이징 내비게이션 랙 영역 (강조색 수식 스킨 바인딩 보존) -->
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
document.querySelector('.search-box select[name="searchType"]').addEventListener('change', function () {
    var isAnimalType = this.value === 't';
    var isAnimalStatus = this.value === 's';
    document.getElementById('animalTypeKeyword').disabled = !isAnimalType;
    document.getElementById('animalStatusKeyword').disabled = !isAnimalStatus;
    document.getElementById('animalTextKeyword').disabled = isAnimalType || isAnimalStatus;
});
</script>
</html>
