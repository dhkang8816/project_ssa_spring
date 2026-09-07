<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>순찰 리포트 목록</title>
    <!-- 💡 부트스트랩 CSS CDN 주소를 올바르게 수정했습니다 -->
</head>
<body>
    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>순찰 리포트 목록</h2>
            <button class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/report/register'">리포트 등록</button>
        </div>

        <table class="table table-bordered table-hover text-center">
            <thead class="thead-dark">
                <tr>
                    <th>순번</th>
                    <th>기준일자</th>
                    <th>총 비행시간</th>
                    <th>총 탐지건수</th>
                    <th>조치 완료율</th>
                    <th>확정 상태</th>
                    <th>사번</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <%-- 💡 'class="empty"' 속성을 완벽히 제거하여 컴파일 에러를 해결했습니다 --%>
                    <c:when test="${empty reportList}">
                        <tr>
                            <td colspan="7" class="text-muted py-4">등록된 순찰 리포트가 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="report" items="${reportList}">
                            <tr onclick="location.href='${pageContext.request.contextPath}/report/detail/${report.reportId}'" style="cursor:pointer;">
                                <td>${report.reportId}</td>
                                <td><fmt:formatDate value="${report.reportDate}" pattern="yyyy-MM-dd"/></td>
                                <td>${report.totalFlightTime}</td>
                                <td>${report.totalDetectCount}건</td>
                                <td>${report.completionRate}%</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${report.confirmStatus eq '0'}"><span class="badge badge-warning">승인 대기</span></c:when>
                                        <c:when test="${report.confirmStatus eq '1'}"><span class="badge badge-success">승인 완료</span></c:when>
                                        <c:when test="${report.confirmStatus eq '2'}"><span class="badge badge-danger">반려</span></c:when>
                                        <c:otherwise><span class="badge badge-secondary">미정</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${report.memberId}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</body>
</html>
