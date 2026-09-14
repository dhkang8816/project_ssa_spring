<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관제 탐지 상황 상세정보</title>
<style>
/* 💡 상세화면 전용 대형 스냅샷 스타일 */
.detail-snapshot {
	max-width: 600px;
	width: 100%;
	height: auto;
	border: 1px solid #ccc;
	border-radius: 6px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}
</style>
</head>
<body>
	<h2>🔍 탐지 상황 상세 내용 및 현장 조치</h2>

	<form:form action="${pageContext.request.contextPath}/detection/modify"
		method="post">
		<!-- 페이징/검색 데이터 유지를 위한 하이딩 파라미터 -->
		<input type="hidden" name="page" value="${pageMaker.page}" />
		<input type="hidden" name="searchType" value="${pageMaker.searchType}" />
		<input type="hidden" name="keyword" value="${pageMaker.keyword}" />
		<input type="hidden" name="dlogId" value="${detection.dlogId}" />

		<table border="1" style="border-collapse: collapse;">
			<tbody>
				<tr>
					<th
						style="padding: 6px 12px; background-color: #f9f9f9; width: 150px;">로그
						번호</th>
					<td style="padding: 6px 12px;">${detection.dlogId}</td>
				</tr>
				<tr>
					<th style="padding: 6px 12px; background-color: #f9f9f9;">드론
						기체 ID</th>
					<td style="padding: 6px 12px;">${detection.droneId}</td>
				</tr>
				<tr>
					<th style="padding: 6px 12px; background-color: #f9f9f9;">포착
						객체 (축종)</th>
					<td style="padding: 6px 12px; font-weight: bold;">${detection.animalType}
						(${detection.detectCount} 마리)</td>
				</tr>
				<tr>
					<th style="padding: 6px 12px; background-color: #f9f9f9;">최초
						감지 시각</th>
					<td style="padding: 6px 12px;"><fmt:formatDate
							value="${detection.detectTime}" pattern="yyyy-MM-dd HH:mm:ss" />
					</td>
				</tr>
				<tr>
					<th style="padding: 6px 12px; background-color: #f9f9f9;">드론
						스냅샷 영상</th>
					<td style="padding: 12px;">
						<!-- 💡 [수정] 컨트롤러의 getSnapshot 스트림 가상 경로를 호출하여 C드라이브 물리 파일과 독립 연동 완료 -->
						<img
						src="${pageContext.request.contextPath}/detection/getSnapshot?dlogId=${detection.dlogId}"
						alt="드론 포착 스냅샷" class="detail-snapshot"
						onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';" />
					</td>
				</tr>
				<tr>
					<th style="padding: 6px 12px; background-color: #eef7ff;">관제원
						현장 조치</th>
					<td style="padding: 12px;"><select name="actionStatus"
						style="width: 200px; padding: 3px;">
							<option value="0"
								${detection.actionStatus == '0' ? 'selected' : ''}>미확인
								(0)</option>
							<option value="1"
								${detection.actionStatus == '1' ? 'selected' : ''}>조치중
								(1)</option>
							<option value="2"
								${detection.actionStatus == '2' ? 'selected' : ''}>조치완료
								(2)</option>
					</select></td>
				</tr>
				<tr>
					<th style="padding: 6px 12px; background-color: #eef7ff;">현장
						조치 사유/내용</th>
					<td style="padding: 12px;"><textarea name="actionReason"
							rows="5" cols="60"
							placeholder="출동 요청, 상황 전파 등 구체적인 조치 이력을 기록하세요."
							required="required"><c:out
								value="${detection.actionReason}" /></textarea></td>
				</tr>
			</tbody>
		</table>

		<br />
		<div>
			<button type="submit">조치 내용 저장</button>
			<button type="button" onclick="fn_goList()">목록으로</button>
		</div>
	</form:form>

</body>

<script>
	function fn_goList() {
		location.href = "${pageContext.request.contextPath}/detection/list"
				+ "?page=${pageMaker.page}"
				+ "&searchType=${pageMaker.searchType}"
				+ "&keyword=${pageMaker.keyword}";
	}
</script>
</html>
