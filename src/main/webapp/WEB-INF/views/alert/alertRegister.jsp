<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신규 경보 이력 등록</title>
<script>
	function validateForm() {
		var alertType = document.getElementById("alertType").value;
		var alertMsg = document.getElementById("alertMsg").value;
		
		if (!alertType) {
			alert("경보대상구분을 선택해주세요.");
			return false;
		}
		if (!alertMsg.trim()) {
			alert("경보 알림 메시지 내용을 입력해주세요.");
			document.getElementById("alertMsg").focus();
			return false;
		}
		return true;
	}
</script>
</head>
<body>
	<h2>신규 경보 이력 등록 화면</h2>

	<form:form action="${pageContext.request.contextPath}/alert/register" method="post" onsubmit="return validateForm();">
		<table border="1" style="width: 500px; border-collapse: collapse;">
			<colgroup>
				<col style="width: 30%; background-color: #f2f2f2;">
				<col style="width: 70%;">
			</colgroup>
			<tbody>
				<!-- 💡 [수정] 공통 코드 데이터를 동적으로 뿌려주는 셀렉트 박스 영역 -->
				<tr>
					<th style="padding: 8px; text-align: left;">경보대상구분 *</th>
					<td style="padding: 8px;">
						<select name="alertType" id="alertType" style="width: 100%;">
							<option value="">-- 선택 --</option>
							<!-- DB의 COMMON_CODE 테이블에서 가져온 리스트를 루프 태웁니다 -->
							<c:forEach var="code" items="${alertTypeCodeList}">
								<%-- value에는 실제 DB에 저장될 코드값(예: 'A01'), 보여지는 텍스트는 코드명(예: '드론경보') 매핑 --%>
								<option value="${code.code}"><c:out value="${code.codeName}" /></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<!-- 알림 메시지 내용 (명세서의 VARCHAR2(200) 글자수 한도 반영) -->
				<tr>
					<th style="padding: 8px; text-align: left;">알림 메시지 내용 *</th>
					<td style="padding: 8px;">
						<textarea name="alertMsg" id="alertMsg" rows="5" style="width: 97%; resize: none;" maxlength="200" placeholder="경보 내용을 입력하세요. (최대 200자)"></textarea>
					</td>
				</tr>
				<!-- 전송성공여부 (명세서상 DEFAULT '실패' 반영하여 실패에 체크) -->
				<tr>
					<th style="padding: 8px; text-align: left;">전송성공여부</th>
					<td style="padding: 8px;">
						<label><input type="radio" name="sendStatus" value="성공"> 성공</label>
						<label style="margin-left: 10px;"><input type="radio" name="sendStatus" value="실패" checked> 실패</label>
					</td>
				</tr>
				<!-- 탐지이력시퀀스 -->
				<tr>
					<th style="padding: 8px; text-align: left;">탐지이력시퀀스</th>
					<td style="padding: 8px;">
						<input type="number" name="dlogId" style="width: 95%;" placeholder="부모 탐지 ID (선택사항)">
					</td>
				</tr>
				<!-- 이상객체탐지시퀀스 -->
				<tr>
					<th style="padding: 8px; text-align: left;">이상객체탐지시퀀스</th>
					<td style="padding: 8px;">
						<input type="number" name="danlogId" style="width: 95%;" placeholder="부모 이상객체 ID (선택사항)">
					</td>
				</tr>
			</tbody>
		</table>

		<br>
		
		<div>
			<button type="submit">등록</button>
			<button type="button" style="margin-left: 5px;" 
				onclick="location.href='${pageContext.request.contextPath}/alert/list'">취소</button>
		</div>
	</form:form>

</body>
</html>
