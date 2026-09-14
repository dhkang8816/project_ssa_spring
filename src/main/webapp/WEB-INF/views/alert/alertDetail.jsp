<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>경보 이력 상세조회</title>
</head>
<body>
	<h2>시스템 경보 이력 상세 화면</h2>

	<!-- 데이터 단건 상세 내역 테이블 -->
	<table border="1" style="width: 600px; border-collapse: collapse;">
		<colgroup>
			<col style="width: 30%; background-color: #f2f2f2;">
			<col style="width: 70%;">
		</colgroup>
		<tbody>
			<tr>
				<th style="padding: 8px; text-align: left;">경보번호</th>
				<td style="padding: 8px;">${alert.alertId}</td>
			</tr>
			<tr>
				<th style="padding: 8px; text-align: left;">경보대상구분</th>
				<td style="padding: 8px;">${alert.alertType}</td>
			</tr>
			<tr>
				<th style="padding: 8px; text-align: left;">경보알림메세지내용</th>
				<td style="padding: 8px; white-space: pre-wrap;"><c:out
						value="${alert.alertMsg}" /></td>
			</tr>
			<tr>
				<th style="padding: 8px; text-align: left;">전송성공여부</th>
				<td style="padding: 8px;">${alert.sendStatus}</td>
			</tr>
			<tr>
				<th style="padding: 8px; text-align: left;">탐지이력시퀀스</th>
				<td style="padding: 8px;">${empty alert.dlogId ? '-' : alert.dlogId}</td>
			</tr>
			<tr>
				<th style="padding: 8px; text-align: left;">이상객체탐지시퀀스</th>
				<td style="padding: 8px;">${empty alert.danlogId ? '-' : alert.danlogId}</td>
			</tr>
			<tr>
				<th style="padding: 8px; text-align: left;">최초경보시각</th>
				<td style="padding: 8px;"><fmt:formatDate
						value="${alert.firstSendTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
			</tr>
			<tr>
				<th style="padding: 8px; text-align: left;">경보전송일시</th>
				<td style="padding: 8px;"><fmt:formatDate
						value="${alert.sendDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
			</tr>
		</tbody>
	</table>

	<br>

	<!-- 하단 제어 버튼 영역 (보던 페이지 상태 파라미터 복귀 연동) -->
	<div>
		<!-- 💡 목록 돌아가기 버튼: 클릭 시 보던 페이지 번호, 검색어, 검색 타입을 쿼리스트링으로 바인딩하여 복귀 -->
		<!-- 가장 안전하고 깔끔한 대안 방식 -->
		<button type="button" onclick="javascript:history.back();">
			목록으로</button>

		<button type="button" style="margin-left: 5px;"
			onclick="location.href='${pageContext.request.contextPath}/'">
			메인으로</button>
	</div>

</body>
</html>
