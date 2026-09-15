<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
/* [1. 글로벌 바디 및 하이테크 레이아웃 - 정중앙 균형 배치 마스크] */
body {
    background-color: #0b0f19 !important; /* 메인 시스템과 일치하는 깊은 사이버 다크 톤 강제 적용 */
    color: #cbd5e1 !important;
    font-family: 'Segoe UI', Roboto, 'Malgun Gothic', sans-serif;
    margin: 0;
    padding: 20px;
    box-sizing: border-box;
    
    /* 팝업 창 내부에서 완벽한 정중앙 대칭을 이루도록 플렉스 레이아웃 선언 */
    display: flex !important;
    justify-content: center !important;
    align-items: center !important;
    min-height: 100vh !important;
}

/* [2. 타이틀 및 카드 프레임 스킨] */
.panel {
    background: rgba(20, 26, 42, 0.85) !important; /* 반투명 글래스모피즘 마스크 */
    border: 1px solid #1e293b !important;
    border-radius: 16px !important;
    padding: 32px !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.5) !important;
    backdrop-filter: blur(4px);
    width: 100%;
    max-width: 480px; /* 안내 및 경고 팝업 최적화 너비 제한 락 */
    box-sizing: border-box;
    text-align: center;
}

.panel h2 {
    color: #ffffff !important;
    margin: 0 0 16px 0 !important;
    font-size: 19px !important;
    font-weight: 700 !important;
    letter-spacing: -0.02em;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
}

.panel p {
    color: #94a3b8 !important; /* 가독성을 위한 연한 회색 보정 */
    font-size: 14px;
    line-height: 1.6;
    margin: 0 0 28px 0;
    word-break: keep-all;
}

/* [4. 조작 버튼 UI 콤포넌트 모던화] */
.btn-container {
    display: flex;
    justify-content: center;
    width: 100%;
}

/* 🛠 요구사항 피드백: 창을 닫아주는 목록으로 제어 단추 표준 사양 (차분한 무채색 다크 그레이 스킨) */
button.btn-list {
    padding: 10px 24px !important;
    background-color: #1e293b !important;
    color: #cbd5e1 !important;
    border: 1px solid #334155 !important;
    border-radius: 8px !important;
    font-size: 13.5px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.15s ease;
}

button.btn-list:hover {
    background-color: #334155 !important;
    color: #ffffff !important;
    border-color: #0ea5e9 !important;
}
</style>

<title>승인 대기 중</title>
</head>
<body>
<!-- 하이테크 스타일 규격 연동 인착 판넬 -->
<div class="panel">
    
    <h2>⚠ 관리자 승인 대기 중입니다.</h2>
    
    <p>
        현재 계정은 승인 대기 상태입니다.<br>
        관리자 승인 후 시스템 관제 서비스를 이용하실 수 있습니다.
    </p>
    
    <!-- 🛠 피드백 반영: 함수명을 일치시킴 -->
    <div class="btn-container">
        <button type="button" class="btn-list" onclick="fn_goBackHistory();">
            뒤로가기
        </button>
    </div>
    
</div>
</body>

<script>
/**
 * 🛠 피드백 반영: 목록으로 버튼 선택 시 하드코딩된 특정 URL 주소 대신,
 * 사용자의 브라우저 세션 세그먼트를 역추적하여 직전 페이지(이전에 있던 곳)로 안전하게 되돌려 보내는 함수
 */
function fn_goBackHistory() {
    if (document.referrer) {
        // 직전 페이지의 도메인/주소 컨텍스트 정보가 남아있을 경우 리다이렉트 처리
        location.href = document.referrer;
    } else {
        // 브라우저 탭 기록을 통한 복귀 (Fallback 히스토리 제어 백업)
        history.back();
    }
}
</script>
</html>