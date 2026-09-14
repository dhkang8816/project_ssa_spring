<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
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

</head>
<body>
	<h2>회원가입</h2>

	<form:form action="${pageContext.request.contextPath}/member/regist"
		method="post" enctype="multipart/form-data">

		<!-- 스프링 시큐리티 POST 필수 토큰 -->
		<input type="hidden" name="${_csrf.parameterName}"
			value="${_csrf.token}" />

		<!-- 💡 최상단 프로필 사진 등록 및 실시간 미리보기 영역 -->
		<div class="profile-upload-wrapper">
			<label style="display: block; margin-bottom: 5px; font-weight: bold;">프로필
				사진 등록</label> <img id="imagePreview"
				src="${pageContext.request.contextPath}/resources/images/member/noImage.jpg"
				alt="미리보기" class="preview-box" />

			<!-- ⚠️ name 속성은 컨트롤러의 MultipartFile 수신 변수명인 pictureFile 과 무조건 일치해야 합니다 -->
			<input type="file" name="pictureFile" id="fileInput" accept="image/*"
				onchange="previewImage(this);" />
			<button type="button" class="btn-photo-action"
				onclick="removeSelectedImage();">사진 삭제</button>
		</div>

		<hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">

		<div>
			<label>아이디:</label> <input type="text" name="memberId" required>
		</div>
		<div>
			<label>비밀번호:</label> <input type="password" name="password" required>
		</div>
		<div>
			<label>이름:</label> <input type="text" name="name" required>
		</div>
		<div>
			<label>부서:</label> <input type="text" name="department">
		</div>
		<div>
			<label>전화번호:</label> <input type="text" name="phone">
		</div>
		<div>
			<label>이메일:</label> <input type="email" name="email">
		</div>
		<div style="margin-top: 15px;">
			<button type="submit">가입하기</button>
			<button type="button"
				onclick="location.href='${pageContext.request.contextPath}/member/list'">취소</button>
		</div>
	</form:form>
</body>
<script>
	// 💡 선택한 사진 파일 실시간 미리보기 스크립트
	function previewImage(input) {
		var preview = document.getElementById('imagePreview');
		if (input.files && input.files[0]) {
			var reader = new FileReader();
			reader.onload = function(e) {
				preview.src = e.target.result;
			}
			reader.readAsDataURL(input.files[0]);
		}
	}

	// 💡 사진 선택 취소 및 기본 이미지 복구 스크립트
	function removeSelectedImage() {
		var preview = document.getElementById('imagePreview');
		var fileInput = document.getElementById('fileInput');
		fileInput.value = "";
		preview.src = "${pageContext.request.contextPath}/resources/images/member/noImage.jpg";
	}
</script>
</html>
