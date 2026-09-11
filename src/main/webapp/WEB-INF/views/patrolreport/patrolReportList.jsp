<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
 <meta charset="UTF-8">
 <title>일일 업무 보고서 관제 인프라</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background-color: #161920; color: #ffffff; font-family: 'Pretendard', sans-serif; margin: 0; padding: 20px; }
    .main-panel { background: linear-gradient(135deg, #222733 0%, #1a1e29 100%); border: 1px solid #2c313d; border-radius: 12px; padding: 25px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5); }
    .table-zone { width: 100%; border-collapse: collapse; margin-top: 20px; }
    .table-zone th { background-color: #242434; color: #5ddcff; padding: 12px; border: 1px solid #2c313d; font-size: 14px; }
    .table-zone td { padding: 12px; border: 1px solid #2c313d; text-align: center; color: #e1e4ea; font-size: 14px; }
    .table-zone tr:hover { background-color: #2c313d; cursor: pointer; }
    .btn-create { background-color: #2ecc71; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: bold; }
    
    /* 🔴 🟡 🟢 목록 화면 전용 신호등 배지 스타일 */
    .badge-status { padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; display: inline-block; }
    .badge-0 { background-color: rgba(241, 196, 15, 0.2); color: #f1c40f; border: 1px solid #f1c40f; } /* 승인 대기 */
    .badge-1 { background-color: rgba(46, 204, 113, 0.2); color: #2ecc71; border: 1px solid #2ecc71; }  /* 승인 완료 */
    .badge-2 { background-color: rgba(231, 76, 60, 0.2); color: #e74c3c; border: 1px solid #e74c3c; }   /* 반려 */
 </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/menu.jsp" />
    <jsp:include page="/WEB-INF/views/header.jsp" />
 <div style="margin-left: 260px; padding: 10px 20px;">
    <div class="main-panel">
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #2c313d; padding-bottom: 15px;">
            <h2 style="color: #5ddcff; margin: 0; font-weight: bold;">📋 일일 관제 업무 보고서 목록</h2>
            <button type="button" class="btn-create" onclick="location.href='${pageContext.request.contextPath}/patrolreport/register'">⚡ 새 보고서 작성</button>
        </div>

        <table class="table-zone">
            <thead>
                <tr>
                    <th>보고서 번호</th>
                    <th>업무 일자</th>
                    <th>작성 사번</th>
                    <th>비행시간</th>
                    <th>탐지건수</th>
                    <th>조치완료율</th>
                    <th>확정 여부</th> <!-- 🔥 [요구사항 3] 컬럼 신규 장착 완료 -->
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty reportList}">
                        <tr><td colspan="7" style="color: #aaa; padding: 50px; font-size: 14px;">생성된 일일 업무 보고서 레코드가 존재하지 않습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="report" items="${reportList}">
                            <tr onclick="location.href='${pageContext.request.contextPath}/patrolreport/detail/${report.reportId}'">
                                <td><strong>${report.reportId}</strong></td>
                                <td><fmt:formatDate value="${report.reportDate}" pattern="yyyy-MM-dd"/></td>
                                <td><span style="color: #ffae19; font-weight: bold;">${report.memberId}</span></td>
                                <td>${report.totalFlightTime} 시간</td>
                                <td>${report.totalDetectCount} 건</td>
                                <td>${report.completionRate} %</td>
                                <td>
                                    <!-- 🔴 🟡 🟢 [요구사항 3] 실시간 확정 상태별 알약 라벨 렌더링 엔진 -->
                                    <c:choose>
                                        <c:when test="${report.confirmStatus eq '0'}"><span class="badge-status badge-0">승인 대기</span></c:when>
                                        <c:when test="${report.confirmStatus eq '1'}"><span class="badge-status badge-1">승인 완료</span></c:when>
                                        <c:when test="${report.confirmStatus eq '2'}"><span class="badge-status badge-2">반려</span></c:when>
                                        <c:otherwise><span class="badge-status" style="background:#555;">미정</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
 </div>
</body>
</html>
