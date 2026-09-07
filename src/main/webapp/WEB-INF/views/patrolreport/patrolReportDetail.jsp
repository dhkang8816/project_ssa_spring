<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>순찰 리포트 상세조회</title>
</head>
<body>

    <div class="container mt-5" style="max-width: 700px;">
        <h2 class="mb-4">순찰 리포트 상세조회</h2>
        <table class="table table-bordered">
            <tr>
                <th class="table-active" style="width: 30%;">리포트 시퀀스</th>
                <td>${report.reportId}</td>
            </tr>
            <tr>
                <th class="table-active">리포트 기준일자</th>
                <td><fmt:formatDate value="${report.reportDate}" pattern="yyyy-MM-dd"/></td>
            </tr>
            <tr>
                <th class="table-active">당일 드론 총 비행시간</th>
                <td>${report.totalFlightTime} 시간</td>
            </tr>
            <tr>
                <th class="table-active">당일 탐지 총 건수</th>
                <td>${report.totalDetectCount} 건</td>
            </tr>
            <tr>
                <th class="table-active">당일 조치 완료율</th>
                <td>${report.completionRate} %</td>
            </tr>
            <tr>
                <th class="table-active">관제원 확정 여부</th>
                <td>
                    <c:choose>
                        <c:when test="${report.confirmStatus eq '0'}">승인 대기</c:when>
                        <c:when test="${report.confirmStatus eq '1'}">승인 완료</c:when>
                        <c:when test="${report.confirmStatus eq '2'}">반려</c:when>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th class="table-active">최초 수집 일시</th>
                <td><fmt:formatDate value="${report.patrolDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            </tr>
            <tr>
                <th class="table-active">수동 강제 재실행 일시</th>
                <td><fmt:formatDate value="${report.modDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            </tr>
            <tr>
                <th class="table-active">사번</th>
                <td>${report.memberId}</td>
            </tr>
        </table>

        <div class="text-right mt-4">
            <button class="btn btn-warning" onclick="location.href='${pageContext.request.contextPath}/report/modify/${report.reportId}'">수정</button>
            <form:form action="${pageContext.request.contextPath}/report/delete" method="post" style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                <input type="hidden" name="reportId" value="${report.reportId}">
                <button type="submit" class="btn btn-danger">삭제</button>
            </form:form>
            <button class="btn btn-secondary" onclick="location.href='${pageContext.request.contextPath}/report/list'">목록으로</button>
        </div>
    </div>
</body>
</html>
