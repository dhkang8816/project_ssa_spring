<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공통코드 등록</title>
<style>
body {
	font-family: sans-serif;
	padding: 20px;
}

.form-group {
	margin-bottom: 15px;
}

label {
	display: inline-block;
	width: 100px;
	font-weight: bold;
}

input, select {
	padding: 6px;
	width: 250px;
}
</style>
</head>
<body>

	<h2>📝 신규 공통코드 등록</h2>

	<!-- 컨트롤러의 /commoncode/register (POST) 메서드로 데이터 전송 -->
	<form:form
		action="${pageContext.request.contextPath}/commoncode/register"
		method="post">
		<c:if test="${param.popup eq 'true'}"><input type="hidden" name="popup" value="true" /></c:if>
		<div class="form-group">
			<label>그룹코드:</label> <input type="text" name="grpCode" required
				placeholder="예: SYS_01" />
		</div>
		<div class="form-group">
			<label>상세코드:</label> <input type="text" name="code" required
				placeholder="예: 01" />
		</div>
		<div class="form-group">
			<label>코드명칭:</label> <input type="text" name="codeName" required
				placeholder="예: 사용정지" />
		</div>
		<div class="form-group">
			<label>정렬순서:</label> <input type="number" name="sortSeq" required
				value="1" />
		</div>
		<div class="form-group">
			<label>사용여부:</label> <select name="useYn">
				<option value="Y">사용 (Y)</option>
				<option value="N">미사용 (N)</option>
			</select>
		</div>

		<div style="margin-top: 20px;">
			<button type="submit">저장하기</button>
			<button type="button"
				onclick="location.href='${pageContext.request.contextPath}/commoncode/list'">취소</button>
		</div>
	</form:form>

</body>
</html>
