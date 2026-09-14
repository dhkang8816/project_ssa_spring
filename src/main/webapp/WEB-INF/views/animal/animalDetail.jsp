<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>보호 동물 상세 정보</title>
</head>
<body>
	<h2>보호 동물 상세 및 수정 화면</h2>

	<!-- 수정 및 삭제 처리를 위한 폼 태그 -->
	<form:form id="detailForm" method="post">
		<!-- 컨트롤러의 PageMaker 바인딩을 위한 페이징/검색 데이터 유지 -->
		<input type="hidden" name="page" value="${pageMaker.page}" />
		<input type="hidden" name="searchType" value="${pageMaker.searchType}" />
		<input type="hidden" name="keyword" value="${pageMaker.keyword}" />

		<table border="1">
			<tbody>
				<tr>
					<th>동물 식별 번호</th>
					<td><input type="text" name="animalId"
						value="${animal.animalId}" readonly="readonly"
						style="background-color: #eee;" /></td>
				</tr>
				<tr>
					<th>축종 구분</th>
					<td>
						<!-- 💡 DB 목록을 뽑으면서 기존에 선택된 축종에 selected 자동 매핑 --> <select
						name="animalType" style="width: 256px;">
							<c:forEach var="code" items="${animalTypeList}">
								<option value="${code.code}"
									${animal.animalType == code.code ? 'selected="selected"' : ''}>
									${code.codeName} (${code.code})</option>
							</c:forEach>
					</select>
					</td>
				</tr>
				<tr>
					<th>품종</th>
					<td><input type="text" name="animalBreed"
						value="${animal.animalBreed}" required="required"
						style="width: 250px;" /></td>
				</tr>
				<tr>
					<th>동물 이름</th>
					<td><input type="text" name="animalName"
						value="${animal.animalName}" required="required"
						style="width: 250px;" /></td>
				</tr>
				<tr>
					<th>입소 날짜</th>
					<td><input type="text"
						value="<fmt:formatDate value="${animal.entranceDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
						readonly="readonly" style="background-color: #eee; width: 250px;" />
					</td>
				</tr>
				<tr>
					<th>보호 상태</th>
					<td>
						<!-- 💡 교정한 보호상태 매핑 반영 (0: 보호중, 1: 입양, 2: 퇴소) --> <select
						name="animalStatus" style="width: 256px;">
							<option value="0"
								${animal.animalStatus == '0' ? 'selected="selected"' : ''}>보호중
								(0)</option>
							<option value="1"
								${animal.animalStatus == '1' ? 'selected="selected"' : ''}>입양
								(1)</option>
							<option value="2"
								${animal.animalStatus == '2' ? 'selected="selected"' : ''}>퇴소
								(2)</option>
					</select>
					</td>
				</tr>
			</tbody>
		</table>

		<br />
		<!-- 기존 프로젝트 스타일의 조작 버튼 영역 -->
		<div>
			<button type="button" onclick="fn_submit('modify')">수정 완료</button>
			<button type="button" onclick="fn_submit('remove')"
				style="background-color: #f44336; color: white;">동물 삭제</button>
			<button type="button" onclick="fn_goList()">목록으로</button>
		</div>
	</form:form>

	<br />
	<a href="${pageContext.request.contextPath}/">메인으로</a>

</body>
<script>
	// 💡 버튼 하나로 수정/삭제 주소를 동적으로 분기하는 레거시 표준 자바스크립트 함수
	function fn_submit(mode) {
		var form = document.getElementById("detailForm");

		if (mode === 'modify') {
			if (!confirm("동물 정보를 수정하시겠습니까?"))
				return;
			form.action = "${pageContext.request.contextPath}/animal/modify";
		} else if (mode === 'remove') {
			if (!confirm("정말로 이 동물 데이터를 삭제하시겠습니까?\n(삭제 시 개체수 대시보드에서 1마리가 자동 감소합니다.)"))
				return;
			form.action = "${pageContext.request.contextPath}/animal/remove";
		}

		form.submit();
	}

	// 기존 검색조건과 페이지 번호를 유지한 채 목록으로 안전하게 튕겨주는 함수
	function fn_goList() {
		location.href = "${pageContext.request.contextPath}/animal/list"
				+ "?page=${pageMaker.page}"
				+ "&searchType=${pageMaker.searchType}"
				+ "&keyword=${pageMaker.keyword}";
	}
</script>
</html>
