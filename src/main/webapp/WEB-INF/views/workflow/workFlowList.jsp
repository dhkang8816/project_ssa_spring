<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>결재 관리</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 30px;
	background: #f6f7fb
}

.panel {
	background: #fff;
	padding: 24px;
	border: 1px solid #ddd;
	border-radius: 8px
}

.status {
	font-weight: bold
}

.pending {
	color: #d99000
}

.approved {
	color: #16803c
}

.rejected {
	color: #c42d2d
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 16px
}

th, td {
	padding: 11px;
	border-bottom: 1px solid #ddd;
	text-align: left
}

a {
	color: #1769aa;
	text-decoration: none
}

.pager {
	margin-top: 20px;
	display: flex;
	gap: 10px;
	justify-content: center
}
</style>
<style>
body {
	margin: 0;
	padding: 32px;
	background: #28283a;
	color: #fff;
	font-family: 'Malgun Gothic', sans-serif
}

h2 {
	margin: 0 0 24px;
	font-size: 26px;
	color: #fff
}

table {
	width: 100%;
	border-collapse: collapse;
	margin: 18px 0;
	background: #323244;
	box-shadow: 0 8px 24px rgba(0, 0, 0, .22)
}

th {
	padding: 15px 16px;
	background: #242434 !important;
	color: #b0b5c0;
	border: 0 !important;
	border-bottom: 2px solid #48485e !important;
	text-align: left
}

td {
	padding: 14px 16px;
	background: #323244;
	color: #fff;
	border: 0 !important;
	border-bottom: 1px solid #48485e !important
}

tr:hover td {
	background: #3a3a51
}

a {
	color: #68d6de;
	text-decoration: none
}

button {
	padding: 9px 16px;
	background: #6366f1;
	color: #fff;
	border: 0;
	border-radius: 6px;
	font-weight: 700;
	cursor: pointer
}

button:hover {
	background: #4f46e5
}

form {
	margin-top: 18px;
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
	align-items: center
}

input, select {
	padding: 8px 10px;
	background: #242434;
	color: #fff;
	border: 1px solid #48485e;
	border-radius: 5px
}

.pagination {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
	justify-content: center;
	margin: 22px 0 !important;
	padding: 0 !important
}

.pagination li {
	margin: 0 !important
}

.pagination a, .pagination strong {
	display: block;
	padding: 6px 10px;
	background: #242434;
	border-radius: 5px
}

.pagination .active strong {
	color: #00f0ff !important
}

@media ( max-width :760px) {
	body {
		padding: 20px
	}
	h2 {
		font-size: 22px
	}
	table {
		display: block;
		overflow-x: auto;
		white-space: nowrap
	}
}
</style>
<style>
body {
	padding: 100px 32px 32px 282px;
}

@media ( max-width : 760px) {
	body {
		padding: 84px 20px 20px 230px;
	}
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/menu.jsp" />
	<jsp:include page="/WEB-INF/views/header.jsp" />
	<div class="panel">
		<h2>결재 관리</h2>
		<p>내게 지정된 일일 관제 업무 보고서입니다.</p>
		<table>
			<thead>
				<tr>
					<th>결재 번호</th>
					<th>보고서</th>
					<th>기안자</th>
					<th>요청일</th>
					<th>상태</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${empty workflowList}">
						<tr>
							<td colspan="6">배정된 결재 문서가 없습니다.</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="workflow" items="${workflowList}">
							<tr>
								<td>${workflow.approvalId}</td>
								<td><a
									href="${pageContext.request.contextPath}/patrolreport/detail/${workflow.reportId}">#${workflow.reportId}</a></td>
								<td>${workflow.drafterName}(${workflow.drafterId})</td>
								<td><fmt:formatDate value="${workflow.requestDate}"
										pattern="yyyy-MM-dd HH:mm" /></td>
								<td
									class="status ${workflow.appStatus eq '0' ? 'pending' : (workflow.appStatus eq '1' ? 'approved' : 'rejected')}"><c:choose>
										<c:when test="${workflow.appStatus eq '0'}">승인 대기</c:when>
										<c:when test="${workflow.appStatus eq '1'}">승인 완료</c:when>
										<c:otherwise>반려</c:otherwise>
									</c:choose></td>
								<td><a
									href="${pageContext.request.contextPath}/workflow/detail/${workflow.approvalId}">상세/처리</a></td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
		<c:if test="${pageMaker.totalCount gt 0}">
			<div class="pager pagination">
				<c:if test="${pageMaker.prev}">
					<a href="${pageContext.request.contextPath}/workflow/list?page=${pageMaker.startPage - 1}">이전</a>
				</c:if>
				<c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}"
					var="num">
					<c:choose>
						<c:when test="${pageMaker.page eq num}"><strong>${num}</strong></c:when>
						<c:otherwise><a href="${pageContext.request.contextPath}/workflow/list?page=${num}">${num}</a></c:otherwise>
					</c:choose>
				</c:forEach>
				<c:if test="${pageMaker.next}">
					<a href="${pageContext.request.contextPath}/workflow/list?page=${pageMaker.endPage + 1}">다음</a>
				</c:if>
			</div>
		</c:if>
	</div>
</body>
</html>
