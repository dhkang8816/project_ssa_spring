<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신규 동물 등록</title>
</head>
<body>
	<h2>신규 동물 등록 화면</h2>

	<!-- 스프링 폼 태그를 활용한 데이터 전송 (POST) -->
	<form:form action="${pageContext.request.contextPath}/animal/register"
		method="post">
		<table border="1">
			<tbody>
				<tr>
					<th>축종 구분</th>
					<td>
						<!-- 💡 DB 공통코드 테이블에서 실시간으로 목록을 가져와 추가함 --> <select
						name="animalType" style="width: 256px;">
							<c:forEach var="code" items="${animalTypeList}">
								<option value="${code.code}">${code.codeName}
									(${code.code})</option>
							</c:forEach>
					</select>
					</td>
				</tr>
				<tr>
					<th>품종</th>
					<td><input type="text" name="animalBreed"
						placeholder="예: 말티즈, 진돗개" required="required"
						style="width: 250px;" /></td>
				</tr>
				<tr>
					<th>동물 이름</th>
					<td><input type="text" name="animalName"
						placeholder="동물 이름을 입력하세요" required="required"
						style="width: 250px;" /></td>
				</tr>
				<tr>
					<th>보호 상태</th>
					<td>
						<!-- 프론트엔드 코드 매핑 기준 전달 (0: 미확인, 1: 포획, 2: 인계) --> <select
						name="animalStatus" style="width: 256px;">
							<option value="0">보호중 (0)</option>
							<option value="1">입양 (1)</option>
							<option value="2">퇴소 (2)</option>
					</select>
					</td>
				</tr>
			</tbody>
		</table>

		<br />
		<!-- 버튼 영역 -->
		<div>
			<button type="submit">등록</button>
			<button type="button"
				onclick="location.href='${pageContext.request.contextPath}/animal/list'">취소</button>
		</div>
	</form:form>

	<br />
	<a href="${pageContext.request.contextPath}/">메인으로</a>
</body>
</html>
