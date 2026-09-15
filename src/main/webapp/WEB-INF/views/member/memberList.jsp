<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>직원관리</title>
<!-- 기존 프로젝트 공통 css 경로가 다를 경우 고쳐서 사용하세요 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/style.css">
<style>
/* [1. 글로벌 바디 최적화] */
body.login-page {
    background-color: #0b0f19 !important; /* 깊은 사이버 다크 톤으로 강제 통일 */
    color: #e2e8f0 !important;
    font-family: 'Segoe UI', Roboto, sans-serif;
    margin: 0;
    padding: 0;
    overflow-x: hidden;
}

/* [2. 구조 개량 - 150px 초슬림 사이드바 정밀 정렬 싱크] */
.main-container {
    display: block !important; /* flex 레이아웃으로 인한 꼬임 전면 파쇄 */
    margin-top: 0 !important;
}

/* 옛날 250px 폭의 유령 블록 엘리먼트 비활성화 청소 */
#menu-placeholder {
    display: none !important;
    width: 0 !important;
}

/* 실제 우측 본문 콘텐츠 영역을 150px 내비게이션 바로 옆에 자석 정렬 */
.content-area {
    position: absolute !important;
    top: 80px !important; /* 상단 고정 헤더 영역 확보 */
    left: 150px !important; /* 얇아진 150px 메뉴바 경계선에 완벽 밀착 */
    width: calc(100% - 150px) !important; /* 우측 남은 공간 100% 락 */
    padding: 30px 40px !important;
    background: transparent !important;
    box-sizing: border-box;
    z-index: 50 !important;
}

@media (max-width: 760px) {
    .content-area {
        left: 0 !important;
        width: 100% !important;
        padding: 20px 16px !important;
    }
}

/* [3. 상단 제어 바 및 검색 랙 정밀 위치 수정 마스크] */
.staff-top-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
    gap: 16px;
    width: 100%;
    border-bottom: 1px solid #1e293b;
    padding-bottom: 16px;
}

.staff-top-bar .page-title {
    margin: 0;
    color: #ffffff !important;
    font-size: 22px;
    font-weight: 700;
    letter-spacing: -0.02em;
}

.staff-summary-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    width: 100%;
}

/* 검색 셀렉트 박스 및 입력창 모던화 */
.search-group form {
    display: flex;
    gap: 6px;
    align-items: center;
}

.search-group select {
    padding: 9px 12px !important;
    background-color: #111827 !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 8px !important;
    font-size: 13.5px;
    outline: none;
    transition: border-color 0.15s ease;
}

.search-group .search-input {
    width: 240px !important; /* 콤팩트한 실무 폭으로 정돈 */
    padding: 9px 16px !important;
    background: #111827 !important;
    border: 1px solid #334155 !important;
    border-radius: 8px !important; /* 세련된 사각 주축 래핑 */
    color: #ffffff !important;
    font-size: 13.5px;
    outline: none;
    transition: all 0.15s ease;
}

.search-group .search-input:focus, .search-group select:focus {
    border-color: #0ea5e9 !important;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25);
}

/* [4. 서머리 정보 랙 텍스트 가독성 고도화] */
.staff-count {
    color: #94a3b8 !important;
    font-size: 14px;
    font-weight: 500;
}

.staff-count .count-num {
    color: #38bdf8 !important; /* 관제 브랜드 아이덴티티 네온 블루 */
    font-weight: 700;
    background: rgba(56, 189, 248, 0.1);
    padding: 2px 6px;
    border-radius: 4px;
}

/* [계정 등록] 청량한 네온 그린 액센트 단추 장착 */
.staff-register-btn {
    padding: 9px 18px !important;
    border: 0 !important;
    border-radius: 8px !important;
    background: #10b981 !important; /* 관제소 전용 네온 그린 스킨 */
    color: #ffffff !important;
    font-weight: 700;
    font-size: 13.5px;
    cursor: pointer;
    box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
    transition: all 0.15s ease;
}

.staff-register-btn:hover {
    background: #059669 !important;
    box-shadow: 0 4px 16px rgba(16, 185, 129, 0.4);
    transform: translateY(-1px);
}

/* [5. 와이드 관제 데이터 그리드 프레임 테마] */
.staff-table-wrapper {
    overflow-x: auto;
    overflow-y: hidden;
    border-radius: 12px !important;
    background: rgba(20, 26, 42, 0.85) !important; /* 반투명 글래스 패널 */
    border: 1px solid #1e293b !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4) !important;
    width: 100%;
}

.staff-table {
    width: 100%;
    min-width: 850px;
    border-collapse: separate !important;
    border-spacing: 0 !important;
}

.staff-table th {
    white-space: nowrap;
    padding: 14px 16px !important;
    background: #111827 !important; /* 묵직한 다크 인프라 행 적용 */
    border-bottom: 2px solid #1e293b !important;
    color: #38bdf8 !important; /* 네온 블루 레이블 각인 */
    font-size: 13px;
    font-weight: 700;
    text-align: center !important; /* 전체 중앙 고정 마스크 */
}

.staff-table td {
    padding: 12px 16px !important;
    background: transparent !important;
    border-bottom: 1px solid #1e293b !important;
    color: #cbd5e1 !important;
    font-size: 13.5px;
    text-align: center !important;
    vertical-align: middle !important;
    white-space: nowrap;
}

/* 리스트 행 스캔 모션 피드백 */
.staff-table tbody tr {
    cursor: pointer;
    transition: background-color 0s ease;
}

.staff-table tbody tr:hover td {
    background-color: rgba(30, 41, 59, 0.6) !important;
    color: #ffffff !important;
}

/* [6. 상태 배지 신호등 알약 마감 처리] */
.badge-status {
    padding: 4px 12px !important;
    border-radius: 20px !important; /* 완벽한 타원 알약 핏 */
    font-size: 11.5px !important;
    font-weight: 700 !important;
    display: inline-block;
}

.status-online {
    background-color: rgba(16, 185, 129, 0.15) !important;
    color: #10b981 !important;
    border: 1px solid rgba(16, 185, 129, 0.3) !important;
} /* 정상 */

.status-stop {
    background-color: rgba(239, 68, 68, 0.15) !important;
    color: #ef4444 !important;
    border: 1px solid rgba(239, 68, 68, 0.3) !important;
} /* 정지 */

.status-dormant {
    background-color: rgba(148, 163, 184, 0.15) !important;
    color: #94a3b8 !important;
    border: 1px solid rgba(148, 163, 184, 0.3) !important;
} /* 휴면 */

/* [7. 하단 페이징 내비게이션 랙] */
.pagination {
    display: flex;
    list-style: none;
    padding-left: 0;
    gap: 6px;
    margin: 0;
}

.pagination li a, .pagination li strong {
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

.pagination li a:hover {
    color: #ffffff !important;
    background: #1f2937 !important;
    border-color: #334155;
}

/* 페이징 활성화 버튼 네온 하이라이팅 각인 */
.pagination li.active strong {
    color: #38bdf8 !important;
    background: rgba(14, 165, 233, 0.15) !important;
    border-color: #0ea5e9 !important;
}
</style>

</head>
<body class="login-page">

<!-- 1. 가장 상단 공통 헤더 로드 -->
<jsp:include page="/WEB-INF/views/header.jsp" />

<div class="main-container">
    <!-- 2. 본문 컨테이너 시작 직후 좌측 슬림 메뉴 조립 -->
    <jsp:include page="/WEB-INF/views/menu.jsp" />
    
    <!-- 3. 우측 본문 콘텐츠 영역 정위치 인착 -->
    <main class="content-area">
        
        <!-- 상단 타이틀 및 검색 바 바인딩 랙 -->
        <div class="staff-top-bar">
            <h2 class="page-title">직원관리</h2>
            
            <div class="search-group">
                <form action="list" method="get" id="searchForm">
                    <select name="searchType">
                        <option value="t" ${pageMaker.searchType == 't' ? 'selected' : ''}>이름</option>
                        <option value="c" ${pageMaker.searchType == 'c' ? 'selected' : ''}>사번</option>
                    </select> 
                    <input type="text" name="keyword" class="search-input" value="${pageMaker.keyword}" placeholder="검색어 입력 후 엔터">
                </form>
            </div>
        </div>
        
        <!-- 서머리 정보 바 (총원 출력 및 등록 버튼) -->
		<!-- [수정 후] -->
		<div class="staff-summary-bar" style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
		    <div class="staff-count">
		        총 직원수: <span class="count-num">${empty memberList ? 0 : memberList.size()}</span>명
		    </div>
		    <!-- ⭕ [계정 등록]과 [CSV 다운로드] 버튼을 감싸서 우측에 나란히 배치하는 그룹 -->
		    <div class="summary-action-group" style="display: flex; gap: 8px; align-items: center;">
   	 		<button class="csv-download-btn neon-theme" onclick="downloadTableAsCsv('#memberTable', 'member-list')">
			        <i class="fa-solid fa-file-csv" style="font-size: 14px;"></i>
			        CSV
			    </button>
		        <button type="button" class="staff-register-btn" onclick="return openFormPopup('${pageContext.request.contextPath}/member/registForm', 'memberRegister');">계정 등록</button>
		    </div>
		</div>
        <!-- 메인 데이터 테이블 프레임 랙 -->
        <div class="staff-table-wrapper">
            <table id="memberTable" class="staff-table" data-csv-export data-csv-filename="member-list">
                <thead>
                    <tr>
                        <th style="width: 80px;">사진</th>
                        <th>사원번호</th>
                        <th>이름</th>
                        <th>소속(부서)</th>
                        <th>이메일 주소</th>
                        <th>휴대전화 번호</th> <!-- ⭕ "휴дзен화" 오타를 "휴대전화"로 정밀 수정 완료 -->
                        <th>가입일</th>
                        <th style="width: 110px;">상태</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty memberList}">
                            <tr>
                                <td colspan="8" style="color: #64748b; padding: 60px; font-size: 14px;">등록된 직원이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="member" items="${memberList}">
                                <tr onclick="return openDetailPopup('${pageContext.request.contextPath}/member/detail?memberId=${member.memberId}', 'memberDetail');">
                                    <!-- 미니 프로필 이미지 출력 랙 -->
                                    <td style="padding: 6px;">
                                        <img src="${pageContext.request.contextPath}/member/getPicture?id=${member.memberId}" alt="미니프로필" class="mini-profile"
                                             onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';"
                                             style="width: 35px; height: 35px; border-radius: 50%; border: 1px solid #1e293b; object-fit: cover; vertical-align: middle;" />
                                    </td>
                                    <!-- 데이터 매핑 필드 바인딩 -->
                                    <td style="color: #38bdf8; font-weight: 600;">${member.memberId}</td>
                                    <td><strong>${member.name}</strong></td>
                                    <td>${member.department}</td>
                                    <td>${member.email}</td>
                                    <td>${member.phone}</td>
                                    <td><fmt:formatDate value="${member.regDate}" pattern="yyyy-MM-dd" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${member.status == '0'}">
                                                <span class="badge-status status-online">정상</span>
                                            </c:when>
                                            <c:when test="${member.status == '1'}">
                                                <span class="badge-status status-stop">정지</span>
                                            </c:when>
                                            <c:when test="${member.status == '2'}">
                                                <span class="badge-status status-dormant">휴면</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-status" style="background: #334155; color: #94a3b8;">${member.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
        
        <!-- 하단 페이징 내비게이션 영역 -->
        <div class="text-center" style="margin-top: 25px; display: flex; justify-content: center; width: 100%;">
            <ul class="pagination">
                <c:if test="${pageMaker.prev}">
                    <li><a href="list?page=${pageMaker.startPage - 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">&laquo; 이전</a></li>
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
                    <li><a href="list?page=${pageMaker.endPage + 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">다음 &raquo;</a></li>
                </c:if>
            </ul>
        </div>
        
    </main>
</div>

<!-- 공통 레이아웃 호출 스크립트 (기존 제공 소스 유지) -->
<script>
 const contextPath = '<%=request.getContextPath()%>';
</script>
<script src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
</body>
</html>

