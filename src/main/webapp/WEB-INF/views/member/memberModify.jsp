<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 정보 수정</title>
<style>
    .profile-upload-wrapper {
        margin-bottom: 20px;
        padding: 5px;
    }
    .preview-box {
        width: 150px;
        height: 180px;
        border: 1px solid #ccc;
        object-fit: cover;
        background-color: #f0f0f0;
        display: block;
        margin-bottom: 8px;
    }
    .btn-photo-action {
        margin-top: 5px;
    }
</style>
<script>
    // 새로운 사진 파일 선택 시 실시간 미리보기 스크립트
    function previewImage(input) {
        var preview = document.getElementById('imagePreview');
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
            }
            reader.readAsDataURL(input.files[0]);
            
            // 사진이 새로 업로드되면 삭제 요청 플래그를 취소함
            document.getElementById('deleteFlag').value = "false";
        }
    }

    // 기존 사진 초기화(삭제) 요청 단추 제어 스크립트
    function removeSelectedImage() {
        var preview = document.getElementById('imagePreview');
        var fileInput = document.getElementById('fileInput');
        
        fileInput.value = ""; 
        preview.src = "${pageContext.request.contextPath}/resources/images/member/noImage.jpg";
        
        // 컨트롤러에게 기존 물리 파일을 지우고 noImage.jpg 로 변경하라는 신호 송신
        document.getElementById('deleteFlag').value = "true";
    }
</script>
</head>
<body>
	<h2>직원 정보 수정</h2>

	<!-- 💡 form:form 태그가 CSRF 토큰을 자동으로 주입하므로 수동 hidden 토큰 태그는 삭제 조치했습니다. -->
	<form:form modelAttribute="member"
		action="${pageContext.request.contextPath}/member/modify"
		method="post" enctype="multipart/form-data">
		
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
		
        <!-- 사진 삭제 트리거 신호 히든 필드 -->
        <input type="hidden" name="deleteOldPicture" id="deleteFlag" value="false">
        
        <!-- 상단 기존 프로필 로딩 및 이미지 스트림 연동 수정 영역 -->
        <div class="profile-upload-wrapper">
            <label style="display: block; margin-bottom: 5px; font-weight: bold;">프로필 사진 변경</label>
            
            <!-- 백엔드의 getPicture 맵핑 주소를 직통 호출하여 안전하게 렌더링 -->
            <img id="imagePreview" src="${pageContext.request.contextPath}/member/getPicture?id=${member.memberId}" 
                 alt="현재 사진" class="preview-box" 
                 onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';" />
            
            <input type="file" name="pictureFile" id="fileInput" accept="image/*" onchange="previewImage(this);" />
            <button type="button" class="btn-photo-action" onclick="removeSelectedImage();">사진 삭제</button>
        </div>
        
        <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">

		<table border="1">
			<tr>
				<th>사번</th>
				<td>
					<strong>${member.memberId}</strong>
                    <!-- 💡 form:hidden 을 사용하여 memberAttribute 와 정확히 바인딩되도록 통일 -->
                    <form:hidden path="memberId" />
				</td>
			</tr>
			<tr>
				<th>이름</th>
				<td><form:input path="name" required="required" /></td>
			</tr>
			<tr>
				<th>부서</th>
				<td><form:input path="department" /></td>
			</tr>
			<tr>
				<th>연락처</th>
				<td><form:input path="phone" /></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td><form:input path="email" type="email" /></td>
			</tr>
			<tr>
				<th>권한</th>
				<td>
                    <form:select path="role">
						<form:options items="${roleList}" itemValue="code" itemLabel="codeName" />
					</form:select>
                </td>
			</tr>
			<tr>
				<th>계정 상태</th>
				<td>
					<form:select path="status">
						<form:options items="${statusList}" itemValue="code" itemLabel="codeName" />
					</form:select>
				</td>
			</tr>
		</table>

		<br>

		<div>
			<button type="submit">저장</button>
			<button type="button"
				onclick="location.href='${pageContext.request.contextPath}/member/detail?memberId=${member.memberId}'">취소</button>
		</div>
	</form:form>
</body>
</html>
