<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>실시간 개체수 현황</title>
</head>
<style>
/* [1. 레이아웃 및 여백 규격] */
body {
    background-color: #0b0f19 !important; /* 깊은 사이버 다크 톤 강제 적용 */
    color: #e2e8f0 !important;
    font-family: 'Segoe UI', Roboto, 'Malgun Gothic', sans-serif;
    margin: 0;
    padding: 0;
    overflow-x: hidden;
    display: flex !important;
    justify-content: center !important;
    align-items: center !important;
    min-height: 100vh !important;
    box-sizing: border-box;
}

/* 초슬림 사이드바 폭(150px)과 헤더 높이(80px)에 맞춰 정밀 좌측 밀착 정렬 */
.control-page-content {
    position: relative !important;
    top: 0 !important;
    left: 0 !important;
    width: 100% !important;
    max-width: 850px !important; /* 현황판 테이블 가시성에 최적화된 가로 폭 락 */
    padding: 20px !important;
    box-sizing: border-box;
    z-index: 50 !important;
}


@media (max-width: 760px) {
    .control-page-content {
        max-width: 100% !important;
        padding: 16px !important;
    }
}

/* [2. 타이틀 및 카드 프레임 스킨] */
.panel {
    background: rgba(20, 26, 42, 0.85) !important;
    border: 1px solid #1e293b !important;
    border-radius: 16px;
    padding: 32px !important; /* 내부 밀도 보정 고도화 */
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.5);
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

/* 단순 목록 조작 단추: 차분한 무채색 다크 그레이 스킨 */
button {
    padding: 10px 18px;
    background-color: #1e293b !important;
    color: #cbd5e1 !important;
    border: 1px solid #334155 !important;
    border-radius: 8px !important;
    font-weight: 700;
    font-size: 13.5px;
    cursor: pointer;
    transition: all 0.15s ease;
}

button:hover {
    background-color: #334155 !important;
    color: #ffffff !important;
    border-color: #0ea5e9 !important;
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
</style>

<body>

<!-- 메인 관제 페이지 레이아웃 본문 래퍼 -->
<div class="control-page-content">
    <div class="panel">
        
        <h2>개체수 현황</h2>
        
        <!-- 동물관리 리스트 복귀 액션 단추 (사각 마감 스타일 동기화) -->
        <div style="width: 100% !important; display: flex !important; justify-content: flex-end !important; margin-bottom: 15px !important; box-sizing: border-box;">
            <button type="button" onclick="return closePopupAndRefreshParent('${pageContext.request.contextPath}/animal/list');">
                동물 관리 목록
            </button>
        </div>
        
        <!-- 하이테크 스타일 규격 연동 현황 테이블 그리드 -->
        <table>
            <thead>
                <tr>
                    <th>축종 코드 (ID)</th>
                    <th>축종 명칭</th>
                    <th>현재 보호 개체수</th>
                    <th>최종 갱신 일시</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty counterList}">
                        <tr>
                            <td colspan="4" class="no-data">등록된 현황판 데이터가 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="counter" items="${counterList}">
                            <tr>
                                <td>${counter.counterId}</td>
                                <td style="font-weight: bold; color: #ffffff;">
                                    <!-- 프론트엔드 코드 매핑 축종 분석 조건문 무결점 보존 -->
                                    <c:choose>
                                        <c:when test="${counter.counterId == 0}">개</c:when>
                                        <c:when test="${counter.counterId == 1}">고양이</c:when>
                                        <c:otherwise>미지정 축종</c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="color: #38bdf8; font-weight: bold;">${counter.currentCount} 마리</td>
                                <td><fmt:formatDate value="${counter.lastUpdate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
        <!-- 검색 폼 영역 (AnimalDetailMapper 동적 조건 검색 랙 보존) -->
        <div class="search-box">
            <form:form action="counterList" method="get">
                <select name="searchType">
                    <option value="c" ${pageMaker.searchType == 'c' ? 'selected' : ''}>축종 코드</option>
                </select>
                <input type="text" name="keyword" value="${pageMaker.keyword}" placeholder="코드 번호 입력">
                <button type="submit">검색</button>
            </form:form>
        </div>
        <!-- 하단 페이징 버튼 영역 (기존 프로젝트 가이드 및 수식 매핑 무결점 보존) -->
        <div style="margin-top: 25px;">
            <ul class="pagination">
                <c:if test="${pageMaker.prev}">
                    <li>
                        <a href="counterList?page=${pageMaker.startPage - 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">&laquo; 이전</a>
                    </li>
                </c:if>
                <c:forEach var="pageNum" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                    <li class="${pageMaker.page == pageNum ? 'active' : ''}">
                        <c:choose>
                            <c:when test="${pageMaker.page == pageNum}">
                                <strong>${pageNum}</strong>
                            </c:when>
                            <c:otherwise>
                                <a href="counterList?page=${pageNum}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">${pageNum}</a>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </c:forEach>
                <c:if test="${pageMaker.next}">
                    <li>
                        <a href="counterList?page=${pageMaker.endPage + 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">다음 &raquo;</a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>
</html>
