<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>직원관리</title>
    <!-- 기존 프로젝트 공통 css 경로가 다를 경우 고쳐서 사용하세요 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css"> 
    <style>
        /* 페이징 활성화 버튼 강조 커스텀 스타일 */
        .pagination li.active strong {
            color: #00f0ff !important;
            font-weight: bold;
            border-bottom: 2px solid #00f0ff;
        }
        .pagination li a:hover {
            color: #00f0ff;
        }
    </style>
</head>
<!-- ... (생략: page 지정 및 head 태그 선언부) ... -->
<body class="login-page">

    <!-- 💡 1. 가장 상단에 헤더를 먼저 조립합니다 -->
    <jsp:include page="/WEB-INF/views/header.jsp" />
    
    <div class="main-container">
        <!-- 💡 2. 본문 컨테이너 시작 직후 좌측 메뉴를 조립합니다 -->
        <jsp:include page="/WEB-INF/views/menu.jsp" />
        
        <!-- 💡 3. 그 다음 우측 본문(콘텐츠) 영역이 이어집니다 -->
        <main class="content-area">
            <div class="staff-top-bar">
                <h2 class="page-title">직원관리</h2>
                <!-- ... 이하 기존 본문 내용 동일 ... -->

                <div class="search-group">
                    <form action="list" method="get" id="searchForm">
                        <select name="searchType" style="padding: 8px; background-color: #242434; color: white; border: 1px solid #48485e; border-radius: 4px; vertical-align: middle;">
                            <option value="t" ${pageMaker.searchType == 't' ? 'selected' : ''}>이름</option>
                            <option value="c" ${pageMaker.searchType == 'c' ? 'selected' : ''}>사번</option>
                        </select>
                        <input type="text" name="keyword" class="search-input" value="${pageMaker.keyword}" placeholder="검색어 입력 후 엔터">
                    </form>
                </div>
            </div>

            <!-- 서머리 바 영역 (총원 표시 및 계정 등록 버튼) -->
            <div class="staff-summary-bar"> 
                <div class="staff-count">
                    <!-- 리스트 사이즈를 활용해 총 직원수 자동 바인딩 -->
                    총 직원수: <span class="count-num">${empty memberList ? 0 : memberList.size()}</span>명
                </div>
                <button type="button" class="staff-register-btn" onclick="location.href='${pageContext.request.contextPath}/member/registForm'">계정 등록</button>
            </div>

            <!-- 메인 테이블 영역 -->
            <div class="staff-table-wrapper">
                <table class="staff-table">
                    <thead>
                        <tr>
                            <th style="text-align: center; width: 80px;">사진</th>
                            <th>사원번호</th>
                            <th>이름</th>
                            <th>소속(부서)</th>
                            <th>이메일 주소</th>
                            <th>휴대전화 번호</th>
                            <th>가입일</th>
                            <th style="text-align: center; width: 100px;">상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty memberList}">
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 30px; color: #b0b5c0;">등록된 직원이 없습니다.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="member" items="${memberList}">
                                    <tr>
                                        <!-- 프로필 이미지 스트림 처리 -->
                                        <td style="text-align: center; padding: 5px;">
                                            <img src="${pageContext.request.contextPath}/member/getPicture?id=${member.memberId}" 
                                                 alt="미니프로필" class="mini-profile" 
                                                 onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';" 
                                                 style="width: 35px; height: 35px; border-radius: 50%; border: 1px solid #ddd; object-fit: cover; vertical-align: middle;"/>
                                        </td>
                                        <!-- 사번 링크 클릭 시 상세페이지 이동 -->
                                        <td>
                                            <a href="${pageContext.request.contextPath}/member/detail?memberId=${member.memberId}" style="color: #6366f1; font-weight: bold; display: inline;">
                                                ${member.memberId}
                                            </a>
                                        </td>
                                        <td>${member.name}</td>
                                        <td>${member.department}</td>
                                        <td>${member.email}</td>
                                        <td>${member.phone}</td>
                                        <td>${member.regDate}</td>
                                        <!-- 계정 상태 코드별 텍스트 분기 분치 -->
                                        <td style="text-align: center;">
                                            <c:choose>
                                                <c:when test="${member.status == '0'}"><span class="status-online">정상</span></c:when>
                                                <c:when test="${member.status == '1'}"><span style="color: #ff4d4d;">정지</span></c:when>
                                                <c:when test="${member.status == '2'}"><span style="color: #9aa5b9;">휴면</span></c:when>
                                                <c:otherwise>${member.status}</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- 하단 페이징 네비게이션 영역 -->
            <div class="text-center" style="margin-top: 25px; display: flex; justify-content: center;">
                <ul class="pagination" style="display: flex; list-style: none; padding-left: 0; gap: 15px;">
                    <!-- [이전] 버튼 -->
                    <c:if test="${pageMaker.prev}">
                        <li>
                            <a href="list?page=${pageMaker.startPage - 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}" style="color: #9aa5b9;">&laquo; 이전</a>
                        </li>
                    </c:if>
                    
                    <!-- 페이지 번호 루프 -->
                    <c:forEach var="pageNum" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                        <li class="${pageMaker.page == pageNum ? 'active' : ''}">
                            <c:choose>
                                <c:when test="${pageMaker.page == pageNum}">
                                    <strong style="color: #00f0ff;">${pageNum}</strong>
                                </c:when>
                                <c:otherwise>
                                    <a href="list?page=${pageNum}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}" style="color: #9aa5b9;">${pageNum}</a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </c:forEach>
                    
                    <!-- [다음] 버튼 -->
                    <c:if test="${pageMaker.next}">
                        <li>
                            <a href="list?page=${pageMaker.endPage + 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}" style="color: #9aa5b9;">다음 &raquo;</a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </main>
    </div>

    <!-- 공통 레이아웃 호출 스크립트 (기존 제공 소스 유지) -->
    <script>
        const contextPath = '<%= request.getContextPath() %>';
        
    </script> 
    <script src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script> 
    <script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
</body>
</html>
