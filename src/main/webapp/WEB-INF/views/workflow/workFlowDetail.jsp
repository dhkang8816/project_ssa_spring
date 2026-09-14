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
<title>전자결재</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 30px;
	background: #f6f7fb
}

.panel {
	max-width: 850px;
	background: #fff;
	padding: 24px;
	border: 1px solid #ddd;
	border-radius: 8px
}

.row {
	margin: 12px 0
}

.label {
	display: inline-block;
	width: 130px;
	font-weight: bold
}

.content {
	white-space: pre-wrap;
	background: #fafafa;
	border: 1px solid #ddd;
	padding: 12px
}

.actions {
	margin-top: 24px;
	border-top: 1px solid #ddd;
	padding-top: 20px
}

textarea {
	width: 100%;
	min-height: 80px
}

button {
	padding: 9px 14px;
	margin-right: 8px
}

.error {
	color: #b52b27
}

.message {
	color: #18753c
}
</style>
</head>
<body>
	<div class="panel">
		<h2>일일 관제 업무 전자결재</h2>
		<c:if test="${not empty message}">
			<p class="message">${message}</p>
		</c:if>
		<c:if test="${not empty error}">
			<p class="error">${error}</p>
		</c:if>
		<div class="row">
			<span class="label">결재 번호</span>${workflow.approvalId}</div>
		<div class="row">
			<span class="label">보고서 번호</span>${workflow.reportId}</div>
		<div class="row">
			<span class="label">기안자</span>${workflow.drafterName}
			(${workflow.drafterId})
		</div>
		<div class="row">
			<span class="label">결재자</span>${workflow.approverName}
			(${workflow.approverId})
		</div>
		<div class="row">
			<span class="label">요청일</span>
			<fmt:formatDate value="${workflow.requestDate}"
				pattern="yyyy-MM-dd HH:mm" />
		</div>
		<div class="row">
			<span class="label">결재 상태</span>
			<c:choose>
				<c:when test="${workflow.appStatus eq '0'}">승인 대기</c:when>
				<c:when test="${workflow.appStatus eq '1'}">승인 완료</c:when>
				<c:otherwise>반려</c:otherwise>
			</c:choose>
		</div>
		<div class="row">
			<div class="label">현장 조치 내역</div>
			<div class="content">${workflow.actionTaken}</div>
		</div>
		<div class="row">
			<div class="label">특이사항</div>
			<div class="content">${workflow.remark}</div>
		</div>
		<c:if test="${not empty workflow.rejectReason}">
			<div class="row">
				<div class="label">반려 사유</div>
				<div class="content">${workflow.rejectReason}</div>
			</div>
		</c:if>
		<c:if test="${workflow.appStatus eq '0'}">
			<div class="actions">
				<form:form action="${pageContext.request.contextPath}/workflow/approve"
					method="post" style="display: inline">
					<input type="hidden" name="approvalId"
						value="${workflow.approvalId}">
					<button type="submit">결재 승인</button>
				</form:form>
				<form:form action="${pageContext.request.contextPath}/workflow/reject"
					method="post">
					<input type="hidden" name="approvalId"
						value="${workflow.approvalId}"><label for="rejectReason">반려
						사유</label>
					<textarea id="rejectReason" name="rejectReason" required></textarea>
					<button type="submit">반려</button>
				</form:form>
			</div>
		</c:if>
		<p>
			<a href="${pageContext.request.contextPath}/workflow/list">목록으로</a>
		</p>
	</div>
</body>
</html>
