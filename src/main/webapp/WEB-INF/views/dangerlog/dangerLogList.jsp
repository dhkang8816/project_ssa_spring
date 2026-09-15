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
<title>실시간 이상 객체 탐지 이력</title>
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

/* 📌 이상객체 스냅샷 미니 썸네일 전용 스타일 리팩토링 */
.mini-snapshot {
    width: 70px;
    height: 45px;
    border-radius: 6px !important;
    border: 1px solid #334155 !important;
    object-fit: cover;
    vertical-align: middle;
    background-color: #111827;
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

/* 검색 버튼: 선명한 네온 블루 스킨 */
button {
    padding: 9px 16px;
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
    border: 0;
    border-radius: 8px !important;
    font-weight: 700;
    font-size: 13.5px;
    cursor: pointer;
    transition: all 0.15s ease;
}

button:hover {
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

/* 미확인: 반투명 레드 패널 핏 */
.badge-status.status-unverified {
    background-color: rgba(239, 68, 68, 0.15) !important;
    color: #ef4444 !important;
    border: 1px solid rgba(239, 68, 68, 0.3) !important;
}

/* 조치중: 반투명 오렌지 패널 핏 */
.badge-status.status-progress {
    background-color: rgba(245, 158, 11, 0.15) !important;
    color: #f59e0b !important;
    border: 1px solid rgba(245, 158, 11, 0.3) !important;
}

/* 조치완료: 반투명 그린 패널 핏 */
.badge-status.status-complete {
    background-color: rgba(16, 185, 129, 0.15) !important;
    color: #10b981 !important;
    border: 1px solid rgba(16, 185, 129, 0.3) !important;
}

/* 미배정 안내 그레이 스킨 배지 */
.badge-none {
    background-color: rgba(30, 41, 59, 0.5) !important;
    color: #64748b !important;
    border: 1px solid #1e293b !important;
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

/* 현재 활성화된 페이지 번호 강조색 변경 (기존의 red 스타일 파쇄) */
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
.panel { display:grid !important; grid-template-columns:minmax(180px,1fr) auto; grid-template-areas:"title search" "summary action" "table table" "pager pager"; gap:20px; padding:0 !important; background:transparent !important; border:0 !important; box-shadow:none !important; overflow-x:auto; }.panel > h2 { grid-area:title; margin:0 !important; padding:0 0 16px; border-bottom:1px solid #1e293b; color:#fff !important; font-size:22px !important; }.panel > br { display:none; }.panel > .staff-list-summary { grid-area:summary; color:#94a3b8; font-size:14px; font-weight:500; }.panel > .staff-list-summary strong { color:#38bdf8; background:rgba(56,189,248,.1); border-radius:4px; padding:2px 6px; }.panel > .search-box { grid-area:search; justify-self:end; margin:0 !important; }.panel > table { grid-area:table; min-width:850px; margin:0 !important; }.panel > table th,.panel > table td { white-space:nowrap; }.panel > div[style*="margin-top"] { grid-area:pager; justify-self:center; margin:0 !important; }@media(max-width:760px){.panel{grid-template-columns:1fr;grid-template-areas:"title" "search" "summary" "table" "pager"}.panel > .search-box{justify-self:stretch}}
</style>

</head>
<body>
<!-- 기존 시스템 컴포넌트 인클루드 보존 -->
<jsp:include page="/WEB-INF/views/menu.jsp" />
<jsp:include page="/WEB-INF/views/header.jsp" />

<!-- 메인 관제 페이지 레이아웃 컨테이너 영역 -->
<div class="control-page-content">
    <div class="panel">
        
        <h2>이상 객체 탐지 이력 목록</h2>
        
          <div class="staff-summary-bar"
		     style="display: flex !important; justify-content: space-between !important; align-items: center !important; width: 100% !important; box-sizing: border-box !important; grid-column: 1 / -1 !important; line-height: 1.2 !important; height: auto !important; margin-bottom: 5px !important;">
		     
		    <!-- 왼쪽: 건수 레이어 (부트스트랩 강제 폰트 크기 초기화) -->
		    <div class="staff-count" style="display: inline-block !important; color: #94a3b8 !important; font-size: 14px !important; font-weight: 500 !important; margin: 0 !important; padding: 0 !important;">
		        총 <strong>${pageMaker.totalCount}</strong>건
		    </div>
		    
		    <!-- 오른쪽: 버튼 묶음 상자 (부트스트랩의 마진/패딩 침범 원천 차단) -->
		    <div class="summary-action-group"
		         style="display: flex !important; gap: 8px !important; align-items: center !important; float: none !important; margin: 0 !important; padding: 0 !important; height: auto !important;">
		         
		        <!-- 🌟 CSV 버튼: 부트스트랩의 버튼 스타일 강제 초기화 및 네온 블루 강제 정착 -->
		        <button class="csv-download-btn neon-theme"
		                onclick="downloadTableAsCsv('#dangerLogTable', 'danger-log-list')"
		                style="float: none !important; margin: 0 !important; display: inline-flex !important; align-items: center !important; justify-content: center !important; white-space: nowrap !important; box-sizing: border-box !important; height: 36px !important; padding: 0 16px !important; line-height: 1 !important; border-radius: 6px !important;">
		            <i class="fa-solid fa-file-csv" style="font-size: 14px; margin: 0 !important; padding: 0 !important;"></i> CSV
		        </button>
		    </div>
		</div>
        
        <!-- 하이테크 스타일 규격 연동 그리드 데이터 테이블 -->
        <table id="dangerLogTable" data-csv-export data-csv-filename="danger-log-list">
            <thead>
                <tr>
                    <th style="width: 80px;">로그번호</th>
                    <th style="width: 90px;">스냅샷</th>
                    <th style="width: 120px;">드론 기체 ID</th>
                    <th style="width: 150px;">이상 객체</th>
                    <th style="width: 180px;">탐지 시각</th>
                    <th style="width: 100px;">조치 상태</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty dangerLogList}">
                        <tr>
                            <!-- 컬럼 확장에 맞게 colspan=6 매핑 유지 -->
                            <td colspan="6" class="no-data">포착된 실시간 이상 객체 탐지 이력이 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="log" items="${dangerLogList}">
                            <!-- 상세조회용 동적 검색 상태값 유지 및 기존 팝업 함수 기능 무결점 보존 -->
                            <tr style="cursor: pointer;"
                                onclick="return openDetailPopup('${pageContext.request.contextPath}/dangerlog/detail?danlogId=${log.danlogId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}', 'dangerLogDetail');">
                                
                                <!-- 1. 로그번호 -->
                                <td style="font-weight: bold;">${log.danlogId}</td>
                                
                                <!-- 2. 서블릿 연동 미니 썸네일 이상객체 스냅샷 출력 영역 -->
                                <td>
                                    <img src="${pageContext.request.contextPath}/dangerlog/getDangerSnapshot?danlogId=${log.danlogId}" 
                                         alt="탐지 스냅샷" 
                                         class="mini-snapshot"
                                         onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';" />
                                </td>
                                
                                <!-- 3. 드론 기체 ID 분기 -->
                                <td>
                                    <c:choose>
                                        <c:when test="${empty log.droneId}">
                                            <span class="badge-status badge-none">미배정</span>
                                        </c:when>
                                        <c:otherwise>${log.droneId}</c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <!-- 4. 이상 객체 코드 명칭 출력 셀 (멧돼지 텍스트 가시성 보정) -->
                                <td style="color: #ffffff; font-weight: bold;"><c:out value="${log.dangerName}" /></td>
                                
                                <!-- 5. 탐지 시각 포맷팅 -->
                                <td><fmt:formatDate value="${log.dangerTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                
                                <!-- 6. 조치 상태를 투박한 컬러 텍스트에서 모던 타원형 알약 배지로 전면 치환 -->
                                <td>
                <span class="badge-status badge-none"><c:out value="${empty actionStatusNames[log.dactionStatus] ? log.dactionStatus : actionStatusNames[log.dactionStatus]}" /></span>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
                <!-- 다조건 동적 검색 폼 영역 (t: 마스터코드, d: 드론ID, s: 조치상태 코드 연동 유지) -->
        <div class="search-box">
            <form:form action="list" method="get">
                <select name="searchType">
                    <option value="t" ${pageMaker.searchType == 't' ? 'selected' : ''}>이상 객체</option>
                    <option value="d" ${pageMaker.searchType == 'd' ? 'selected' : ''}>드론 기체 ID</option>
                    <option value="s" ${pageMaker.searchType == 's' ? 'selected' : ''}>조치 상태</option>
                </select>
                <select name="keyword" id="dangerActionStatusKeyword" ${pageMaker.searchType == 's' ? '' : 'disabled'}>
                    <option value="">전체 조치상태</option>
                    <c:forEach var="actionStatus" items="${actionStatusNames}">
                        <option value="${actionStatus.key}" ${pageMaker.keyword == actionStatus.key ? 'selected' : ''}>${actionStatus.value}</option>
                    </c:forEach>
                </select>
                <input type="text" name="keyword" id="dangerLogTextKeyword" value="${pageMaker.searchType == 's' ? '' : pageMaker.keyword}" placeholder="검색어 입력" ${pageMaker.searchType == 's' ? 'disabled' : ''}>
                <button type="submit" class="btn-search">검색</button>
            </form:form>
        </div>
        <!-- 하단 페이징 버튼 영역 (기존 프로젝트 가이드 및 수식 매핑 무결점 보존) -->
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
// 기존 현장 상황 조치 내역 업데이트 성공 알럿 메시지 제어 스크립트 완전 보존
var msg = "${msg}";
if (msg === "MODIFY_SUCCESS") {
    alert("현장 상황 조치 내역이 성공적으로 업데이트되었습니다.");
}

document.querySelector('.search-box select[name="searchType"]').addEventListener('change', function () {
    var isActionStatus = this.value === 's';
    document.getElementById('dangerActionStatusKeyword').disabled = !isActionStatus;
    document.getElementById('dangerLogTextKeyword').disabled = isActionStatus;
});
</script>
</html>
