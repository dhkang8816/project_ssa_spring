<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 상세 정보</title>
<style>
/* 1. 글로벌 바디 및 레이아웃 정의 */
body {
    background-color: #0b0f19 !important; /* 메인 시스템과 일치하는 다크 테마 */
    color: #e2e8f0 !important;
    font-family: 'Segoe UI', Roboto, sans-serif;
    margin: 0;
    padding: 24px;
    box-sizing: border-box;
}

/* 2. 글래스모피즘 스타일의 메인 판넬 */
.detail-panel {
    width: 100%;
    max-width: 520px; /* ⭕ 상하 수직 배치를 위해 전체 폭을 슬림하게 조정해 균형감 확보 */
    margin: 0 auto;
    background: rgba(20, 26, 42, 0.85) !important;
    border: 1px solid #1e293b !important;
    border-radius: 14px !important;
    padding: 32px !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.5) !important;
    backdrop-filter: blur(4px);
    box-sizing: border-box;
}

.detail-panel h2 {
    color: #ffffff !important;
    font-size: 20px;
    font-weight: 700;
    margin-top: 0;
    margin-bottom: 24px;
    letter-spacing: -0.02em;
    border-bottom: 1px solid #1e293b;
    padding-bottom: 16px;
    text-align: center; /* 타이틀 중앙 정렬 */
}

/* 3. [구조 대개편] 사진을 맨 상단 중앙에 고정하는 프로필 섹션 */
.profile-top-section {
    display: flex;
    flex-direction: column;
    align-items: center; /* ⭕ 중앙 정렬 강제 고정 */
    width: 100%;
    margin-bottom: 30px;
}

/* 프로필 이미지 액자 프레임 하이테크 스타일 튜닝 */
.profile-img-box {
    padding: 6px;
    background: #111827;
    border: 2px solid #0ea5e9; /* ⭕ 네온 블루 테두리로 시선 집중 효과 */
    box-shadow: 0 0 20px rgba(14, 165, 233, 0.2);
    border-radius: 12px;
    flex-shrink: 0;
    margin-bottom: 10px; /* 사진 하단 여백 */
}
.profile-img-box img {
    width: 150px; /* ⭕ 상단 배치를 고려하여 사진 크기를 살짝 더 확장 */
    height: 185px;
    border-radius: 6px;
    object-fit: cover;
    display: block;
}

/* 4. 사진 하단에 깔끔하게 흐르는 데이터 그리드 랙 */
.info-grid {
    width: 100%;
    display: flex;
    flex-direction: column;
    background: rgba(17, 24, 39, 0.5); /* 은은한 내부 음영 처리 */
    border: 1px solid #1e293b;
    border-radius: 10px;
    padding: 10px 20px;
    box-sizing: border-box;
}

.info-row {
    display: flex;
    align-items: center;
    justify-content: space-between; /* ⭕ 라벨과 값을 좌우 끝으로 벌려 가독성 극대화 */
    padding: 12px 0;
    font-size: 14px;
    border-bottom: 1px solid rgba(30, 41, 59, 0.5);
}
.info-row:last-child {
    border-bottom: none; /* 마지막 하단 선 제거 */
}

.info-label {
    color: #94a3b8 !important; /* 슬레이트 그레이 서브 타이틀 */
    font-weight: 600;
}

.info-value {
    color: #cbd5e1;
    font-weight: 500;
    text-align: right;
}

/* 5. 상태 표시 알약 배지 스킨 */
.badge-status {
    padding: 3px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 700;
    display: inline-block;
}
.status-0 { background: rgba(16, 185, 129, 0.15); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.3); } /* 정상 */
.status-1 { background: rgba(239, 68, 68, 0.15); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); } /* 정지 */
.status-2 { background: rgba(148, 163, 184, 0.15); color: #94a3b8; border: 1px solid rgba(148, 163, 184, 0.3); } /* 휴면 */

/* 6. 하단 조작 컨트롤 버튼 바 */
.action-bar {
    margin-top: 24px;
    display: flex;
    justify-content: center; /* 버튼도 하단 중앙에 배치해 수직 밸런스 유지 */
    gap: 12px;
    width: 100%;
}

button {
    padding: 10px 24px;
    font-size: 13.5px;
    font-weight: 700;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.15s ease;
    border: none;
}

/* [수정] 네온 블루 버튼 사양 */
.btn-modify {
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
    box-shadow: 0 4px 12px rgba(14, 165, 233, 0.2);
}
.btn-modify:hover {
    background-color: #0284c7 !important;
    box-shadow: 0 4px 16px rgba(14, 165, 233, 0.35);
    transform: translateY(-1px);
}

/* [목록으로] 차분한 다크 그레이 단추 사양 */
.btn-back {
    background-color: #1e293b !important;
    color: #cbd5e1 !important;
    border: 1px solid #334155 !important;
}
.btn-back:hover {
    background-color: #334155 !important;
    color: #ffffff !important;
}
button:active { transform: translateY(0); }
</style>
</head>
<body>

<div class="detail-panel">
    <h2>📋 관제소 보안 직원 상세 정보</h2>
    
    <!-- ⭕ 요청 전면 반영: 사진이 상단 중앙에 먼저 배치되는 통합 레이아웃 구조 -->
    <div class="profile-top-section">
        <!-- 상단 중앙 프로필 사진 프레임 박스 -->
        <div class="profile-img-box">
            <img src="${pageContext.request.contextPath}/member/getPicture?id=${member.memberId}" alt="직원 사진" 
                 onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';" />
        </div>
    </div>
    
    <!-- 하단 데이터 명세 스택 그리드 랙 -->
    <div class="info-grid">
        <div class="info-row">
            <span class="info-label">사원번호</span>
            <span class="info-value" style="color: #38bdf8; font-weight: 700;">${member.memberId}</span>
        </div>
        <div class="info-row">
            <span class="info-label">이름</span>
            <span class="info-value" style="color: #ffffff; font-weight: 600;">${member.name}</span>
        </div>
        <div class="info-row">
            <span class="info-label">소속 부서</span>
            <span class="info-value">${member.department}</span>
        </div>
        <div class="info-row">
            <span class="info-label">연락처</span>
            <span class="info-value">${member.phone}</span>
        </div>
        <div class="info-row">
            <span class="info-label">이메일</span>
            <span class="info-value">${member.email}</span>
        </div>
        <div class="info-row">
            <span class="info-label">계정 상태</span>
            <c:choose>
                <c:when test="${member.status == '0'}"><span class="badge-status status-0">정상</span></c:when>
                <c:when test="${member.status == '1'}"><span class="badge-status status-1">정지</span></c:when>
                <c:when test="${member.status == '2'}"><span class="badge-status status-2">휴면</span></c:when>
                <c:otherwise><span class="badge-status" style="background: #334155; color: #94a3b8;">${member.status}</span></c:otherwise>
            </c:choose>
        </div>
        <div class="info-row">
            <span class="info-label">비밀번호 실패</span>
            <span class="info-value" style="${member.failCount >= 5 ? 'color: #ef4444; font-weight: 700;' : ''}">${member.failCount} 회</span>
        </div>
        <div class="info-row">
            <span class="info-label">인프라 등록일</span>
            <span class="info-value" style="color: #94a3b8;"><fmt:formatDate value="${member.regDate}" pattern="yyyy-MM-dd" /></span>
        </div>
        <div class="info-row">
            <span class="info-label">최종 로그인</span>
            <span class="info-value" style="color: #94a3b8;"><fmt:formatDate value="${member.lastLongDate}" pattern="yyyy-MM-dd HH:mm" /></span>
        </div>
    </div>
    
    <!-- 하단 제어 조작 버튼 바 (수직 구조에 맞춘 중앙 정렬 보정) -->
    <div class="action-bar">
        <button type="button" class="btn-modify" onclick="return openMemberModifyPopup();">⚡ 정보 수정</button>
        <button type="button" class="btn-back" onclick="return closePopupAndRefreshParent('${pageContext.request.contextPath}/member/list');">목록으로</button>
    </div>
    
</div> <!-- .detail-panel END -->
<!-- ⚠️ 원본 자바스크립트 팝업 엔진 (100% 무결점 보존선) -->
<script>
function openMemberModifyPopup() {
    location.href = '${pageContext.request.contextPath}/member/modifyForm?memberId=${member.memberId}';
    return false;
}
</script>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>
</html>
