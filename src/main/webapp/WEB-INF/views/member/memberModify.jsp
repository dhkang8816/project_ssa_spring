<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 정보 수정</title>
<style>
/* 1. 글로벌 바디 및 레이아웃 정의 */
body {
    background-color: #0b0f19 !important; /* 메인 관제소와 일치하는 다크 테마 */
    color: #e2e8f0 !important;
    font-family: 'Segoe UI', Roboto, sans-serif;
    margin: 0;
    padding: 24px;
    box-sizing: border-box;
}

/* 2. 글래스모피즘 스타일의 메인 입력 판넬 */
.form-panel {
    width: 100%;
    max-width: 520px; /* 상세 정보창과 싱크를 맞춘 슬림 수직 구조 */
    margin: 0 auto;
    background: rgba(20, 26, 42, 0.85) !important;
    border: 1px solid #1e293b !important;
    border-radius: 14px !important;
    padding: 32px !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.5) !important;
    backdrop-filter: blur(4px);
    box-sizing: border-box;
}

.form-panel h2 {
    color: #ffffff !important;
    font-size: 20px;
    font-weight: 700;
    margin-top: 0;
    margin-bottom: 24px;
    letter-spacing: -0.02em;
    border-bottom: 1px solid #1e293b;
    padding-bottom: 16px;
    text-align: center;
}

/* 3. 상단 파일 업로드 및 이미지 프리뷰 레이아웃 */
.profile-upload-wrapper {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 100%;
    margin-bottom: 24px;
    box-sizing: border-box;
}

.profile-upload-wrapper label {
    margin-bottom: 10px;
    color: #94a3b8 !important;
    font-size: 13.5px;
    font-weight: 600;
}

/* 프리뷰 상자 네온 블루 튜닝 */
.preview-box {
    width: 150px;
    height: 185px;
    border: 2px solid #0ea5e9;
    box-shadow: 0 0 20px rgba(14, 165, 233, 0.2);
    border-radius: 12px;
    object-fit: cover;
    background-color: #111827;
    display: block;
    margin-bottom: 12px;
}

/* 파일 업로드 쌩 input 컴포넌트 텍스트 보정 */
#fileInput {
    font-size: 12px;
    color: #94a3b8;
    margin-bottom: 8px;
}

/* 4. 투박한 테이블을 파쇄하고 구조화한 명세 폼 카드 랙 */
.form-grid-card {
    width: 100%;
    display: flex;
    flex-direction: column;
    background: rgba(17, 24, 39, 0.5);
    border: 1px solid #1e293b;
    border-radius: 10px;
    padding: 10px 20px;
    box-sizing: border-box;
    margin-bottom: 24px;
}

.form-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 12px 0;
    font-size: 14px;
    border-bottom: 1px solid rgba(30, 41, 59, 0.5);
}
.form-row:last-child {
    border-bottom: none;
}

.form-label {
    color: #94a3b8 !important;
    font-weight: 600;
    width: 100px;
    flex-shrink: 0;
}

.form-value-slot {
    flex: 1;
    text-align: right;
    display: flex;
    justify-content: flex-end;
}

/* 5. Spring 전용 커스텀 입력 상자 및 셀렉트 박스 다크 고도화 */
.form-grid-card input[type="text"], 
.form-grid-card input[type="email"], 
.form-grid-card select {
    width: 220px !important; /* 적정 입력폭 고정 */
    background: #111827 !important;
    padding: 8px 12px !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 6px !important;
    outline: none;
    font-size: 13.5px;
    box-sizing: border-box;
    transition: all 0.15s ease-in-out;
    text-align: left;
}

.form-grid-card input:focus, 
.form-grid-card select:focus {
    border-color: #0ea5e9 !important;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25) !important;
}

/* 6. 조작 버튼 세부 마감 */
button, input[type="submit"] {
    padding: 9px 18px;
    font-size: 13.5px;
    font-weight: 700;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.15s ease;
    border: none;
}

/* 사진 조작 및 취소 단추용 차분한 무채색 스킨 */
.btn-photo-action, .btn-back {
    background-color: #1e293b !important;
    color: #cbd5e1 !important;
    border: 1px solid #334155 !important;
    font-size: 12px;
    padding: 6px 14px;
}
.btn-photo-action:hover, .btn-back:hover {
    background-color: #334155 !important;
    color: #ffffff !important;
}

/* [저장] 실행 버튼 사양 */
.btn-submit {
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
    box-shadow: 0 4px 12px rgba(14, 165, 233, 0.2);
}
.btn-submit:hover {
    background-color: #0284c7 !important;
    box-shadow: 0 4px 16px rgba(14, 165, 233, 0.35);
    transform: translateY(-1px);
}

.action-bar {
    display: flex;
    justify-content: center;
    gap: 12px;
    width: 100%;
}
button:active { transform: translateY(0); }
</style>
</head>
<body>

<div class="form-panel">
    <h2>⚙ 직원 정보 수정 설정</h2>
    
    <!-- 오리지널 멀티파트 서브밋 포맷 100% 보존선 -->
    <form:form modelAttribute="member" action="${pageContext.request.contextPath}/member/modify" method="post" enctype="multipart/form-data">
        
        <!-- 팝업 파라미터 및 보안 가동 가이드라인 유지 -->
        <c:if test="${param.popup eq 'true'}"><input type="hidden" name="popup" value="true" /></c:if>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="deleteOldPicture" id="deleteFlag" value="false">
        
        <!-- 상단 파일 업로드 컴포넌트 레이어 -->
        <div class="profile-upload-wrapper">
            <label>프로필 사진 변경 레이더</label>
            <img id="imagePreview" src="${pageContext.request.contextPath}/member/getPicture?id=${member.memberId}" alt="현재 사진" class="preview-box"
                 onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';" />
            
            <div style="display: flex; flex-direction: column; align-items: center; gap: 4px;">
                <input type="file" name="pictureFile" id="fileInput" accept="image/*" onchange="previewImage(this);" />
                <button type="button" class="btn-photo-action" onclick="removeSelectedImage();">❌ 사진 초기화</button>
            </div>
        </div>
        
        <!-- 내부 입력 필드 전용 그리드 카드 복원 및 결합 -->
        <div class="form-grid-card">
            <!-- 사번 (읽기 전용 고정) -->
            <div class="form-row">
                <span class="form-label">사원번호</span>
                <div class="form-value-slot">
                    <strong style="color: #38bdf8; font-size: 15px; padding-right: 6px;">${member.memberId}</strong>
                    <form:hidden path="memberId" />
                </div>
            </div>
            
            <!-- 이름 -->
            <div class="form-row">
                <span class="form-label">이름</span>
                <div class="form-value-slot">
                    <form:input path="name" required="required" placeholder="이름을 입력하세요" />
                </div>
            </div>
            
            <!-- 부서 -->
            <div class="form-row">
                <span class="form-label">소속 부서</span>
                <div class="form-value-slot">
                    <form:input path="department" placeholder="부서명 입력" />
                </div>
            </div>
            
            <!-- 연락처 -->
            <div class="form-row">
                <span class="form-label">연락처</span>
                <div class="form-value-slot">
                    <form:input path="phone" placeholder="ex) 010-0000-0000" />
                </div>
            </div>
            
            <!-- 이메일 -->
            <div class="form-row">
                <span class="form-label">이메일 주소</span>
                <div class="form-value-slot">
                    <form:input path="email" type="email" placeholder="example@domain.com" />
                </div>
            </div>
            
            <!-- 권한 권한 코드 옵션 바인딩 -->
            <div class="form-row">
                <span class="form-label">보안 권한</span>
                <div class="form-value-slot">
                    <form:select path="role">
                        <form:options items="${roleList}" itemValue="code" itemLabel="codeName" />
                    </form:select>
                </div>
            </div>
            
            <!-- 계정 상태 옵션 바인딩 -->
            <div class="form-row">
                <span class="form-label">계정 상태</span>
                <div class="form-value-slot">
                    <form:select path="status">
                        <form:options items="${statusList}" itemValue="code" itemLabel="codeName" />
                    </form:select>
                </div>
            </div>
        </div> <!-- .form-grid-card END -->
        
        <!-- 하단 실행 제어바 -->
        <div class="action-bar">
            <button type="submit" class="btn-submit">💾 변경사항 저장</button>
            <button type="button" class="btn-back" onclick="location.href='${pageContext.request.contextPath}/member/detail?memberId=${member.memberId}'">취소</button>
        </div>
        
    </form:form>
</div> <!-- .form-panel END -->
</body>
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
</html>
