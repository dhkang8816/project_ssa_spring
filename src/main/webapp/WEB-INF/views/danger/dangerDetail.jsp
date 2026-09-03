<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이상 객체 상세 정보</title>
</head>
<body>
	<h2>이상 객체 상세 및 수정 화면</h2>

	<form:form id="dangerForm" method="post">
		<!-- 페이징/검색 데이터 유지 -->
		<input type="hidden" name="page" value="${pageMaker.page}" />
		<input type="hidden" name="searchType" value="${pageMaker.searchType}" />
		<input type="hidden" name="keyword" value="${pageMaker.keyword}" />

		<table border="1">
			<tbody>
				<tr>
					<th style="padding: 5px 10px;">마스터 식별 번호</th>
					<td style="padding: 5px 10px;">
						<input type="text" name="dangerId" value="${danger.dangerId}" readonly="readonly" style="background-color: #eee; width: 250px;" />
					</td>
				</tr>
				<tr>
					<th style="padding: 5px 10px;">이상 객체 명칭</th>
					<td style="padding: 5px 10px;">
						<input type="text" name="dangerName" value="${danger.dangerName}" required="required" style="width: 250px;" />
					</td>
				</tr>
				<tr>
					<th style="padding: 5px 10px;">마스터 등록 일자</th>
					<td style="padding: 5px 10px;">
						<input type="text" value="<fmt:formatDate value="${danger.dangerDate}" pattern="yyyy-MM-dd HH:mm:ss"/>" readonly="readonly" style="background-color: #eee; width: 250px;" />
					</td>
				</tr>
			</tbody>
		</table>
		
		<br />
		<div>
			<button type="button" onclick="fn_submit('modify')">수정 완료</button>
			<button type="button" onclick="fn_submit('remove')" style="background-color: #f44336; color: white;">객체 삭제</button>
			<button type="button" onclick="fn_goList()">목록으로</button>
		</div>
	</form:form>
	
	<br />
	<a href="${pageContext.request.contextPath}/">메인으로</a>

<script>
	function fn_submit(mode) {
		var form = document.getElementById("dangerForm");
		
		if(mode === 'modify') {
			if(!confirm("이상 객체 명칭을 수정하시겠습니까?")) return;
			form.action = "${pageContext.request.contextPath}/danger/modify";
		} else if(mode === 'remove') {
			if(!confirm("정말로 이 객체를 마스터에서 영구 삭제하시겠습니까?")) return;
			form.action = "${pageContext.request.contextPath}/danger/remove";
		}
		form.submit();
	}

	function fn_goList() {
		location.href = "${pageContext.request.contextPath}/danger/list"
		              + "?page=${pageMaker.page}"
		              + "&searchType=${pageMaker.searchType}"
		              + "&keyword=${pageMaker.keyword}";
	}
</script>
</body>
</html>
