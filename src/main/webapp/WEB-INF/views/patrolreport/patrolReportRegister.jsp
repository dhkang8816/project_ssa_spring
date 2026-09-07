<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>순찰 리포트 등록</title>
</head>
<body>

    <div class="container mt-5" style="max-width: 600px;">
        <h2 class="mb-4">순찰 리포트 등록</h2>
        <form:form action="${pageContext.request.contextPath}/report/register" method="post">
            <div class="form:form-group">
                <label>리포트 기준일자</label>
                <input type="date" name="reportDate" class="form:form-control" required>
            </div>
            <div class="form:form-group">
                <label>당일 드론 총 비행시간</label>
                <input type="number" step="0.01" name="totalFlightTime" class="form:form-control" placeholder="예: 2.5">
            </div>
            <div class="form:form-group">
                <label>당일 탐지 총 건수</label>
                <input type="number" name="totalDetectCount" class="form:form-control" required>
            </div>
            <div class="form:form-group">
                <label>당일 조치 완료율 (%)</label>
                <input type="number" step="0.01" name="completionRate" class="form:form-control" required>
            </div>
            <div class="form:form-group">
                <label>관제원 확정 여부</label>
                <select name="confirmStatus" class="form:form-control">
                    <c:forEach var="status" items="${statusList}">
                        <option value="${status.code}">${status.codeName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form:form-group">
                <label>사번</label>
                <input type="text" name="memberId" class="form:form-control" required>
            </div>
            <div class="text-right mt-4">
                <button type="submit" class="btn btn-success">저장</button>
                <button type="button" class="btn btn-secondary" onclick="location.href='${pageContext.request.contextPath}/report/list'">취소</button>
            </div>
        </form:form>
    </div>
</body>
</html>
