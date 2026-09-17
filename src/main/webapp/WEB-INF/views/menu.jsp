<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>메뉴</title>
<link rel="icon" href="./favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="<c:url value='/resources/css/style.css'/>">

<style>
nav {
    position: fixed !important;
    top: 80px !important; 
    left: 0 !important;
    width: 200px !important; 
    height: calc(100vh - 80px) !important;
    background-color: #111827 !important; 
    border-right: 1px solid #1e293b;
    box-shadow: 4px 0 20px rgba(0, 0, 0, 0.25);
    box-sizing: border-box;
    overflow-y: auto;
    z-index: 900 !important;
    display: flex;
    flex-direction: column;
}

/* ─── 메뉴 상단 미니 관제 영역 ─── */
.mini-control-box {
    padding: 10px;
    background-color: #0f172a;
    border-bottom: 1px solid #1e293b;
    box-sizing: border-box;
}

/* 미니 비디오 화면 스타일 */
.mini-video-display {
    position: relative;
    width: 100%;
    aspect-ratio: 16 / 9;
    background-color: #000000;
    border-radius: 6px;
    border: 1px solid #334155;
    overflow: hidden;
    box-sizing: border-box;
    cursor: pointer;
}

.mini-streaming-frame {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}

.mini-video-display.stream-off .mini-streaming-frame,
.mini-video-display.stream-error .mini-streaming-frame {
    visibility: hidden;
}

.mini-video-display.stream-off::after {
    content: "탐지 중지";
    position: absolute;
    top: 0; left: 0; right: 0; bottom: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #64748b;
    font-size: 11px;
    font-weight: 700;
}

/* 영상 내부 하단 푸터 (드론 이름 + 토글 스위치) */
.mini-video-footer {
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    padding: 4px 8px;
    background: rgba(0, 0, 0, 0.6);
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-sizing: border-box;
    z-index: 2;
}

.mini-channel-title {
    font-size: 10px;
    font-weight: 700;
    color: #38bdf8;
}

/* 미니 토글 스위치 */
.mini-switch-item {
    display: flex;
    align-items: center;
    gap: 4px;
    cursor: pointer;
}

.mini-switch-item input {
    display: none;
}

.mini-slider {
    position: relative;
    width: 28px;
    height: 14px;
    background-color: #475569;
    border-radius: 14px;
    transition: background-color 0.2s ease;
}

.mini-slider::before {
    content: "";
    position: absolute;
    top: 1px;
    left: 1px;
    width: 12px;
    height: 12px;
    background-color: #ffffff;
    border-radius: 50%;
    transition: transform 0.2s ease;
}

.mini-switch-item input:checked + .mini-slider {
    background-color: #06b6d4; 
}

.mini-switch-item input:checked + .mini-slider::before {
    transform: translateX(14px);
}

.mini-switch-label {
    font-size: 9px;
    font-weight: 700;
    color: #94a3b8;
}

.mini-switch-item input:checked ~ .mini-switch-label {
    color: #06b6d4;
}

/* 영상 아래로 내려간 채널 전환 버튼 그리드 */
.mini-drone-buttons {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 4px;
    margin-top: 8px;
}

.btn-mini-tab {
    background-color: #1e293b;
    color: #94a3b8;
    border: 1px solid #334155;
    padding: 4px 0;
    border-radius: 4px;
    font-size: 10px;
    font-weight: 600;
    cursor: pointer;
    text-align: center;
    transition: all 0.2s ease;
}

.btn-mini-tab:hover {
    background-color: #334155;
    color: #ffffff;
}

.btn-mini-tab.active {
    background-color: #0ea5e9;
    color: #ffffff;
    border-color: #38bdf8;
}
/* ───────────────────────────── */

.sidebar-list {
    list-style: none !important;
    padding: 6px 0 !important; 
    margin: 0 !important;
    width: 100%;
    flex-grow: 1;
}

.sidebar-list > li {
    padding: 0 !important;
    margin: 0 !important;
    position: relative; 
    width: 100%;
}

.sidebar-list > li > a {
    display: block;
    padding: 12px 14px; 
    font-size: 13px;
    font-weight: 600;
    color: #94a3b8 !important; 
    text-decoration: none !important;
    border-left: 4px solid transparent; 
    box-sizing: border-box;
    cursor: pointer;
}

.sidebar-list > li:hover > a {
    color: #38bdf8 !important; 
    background: linear-gradient(90deg, rgba(14, 165, 233, 0.15) 0%, rgba(14, 165, 233, 0) 100%); 
    border-left: 4px solid #38bdf8; 
}

.submenu {
    display: none; 
    position: absolute;
    top: 0;
    left: 199px; 
    width: 160px; 
    background-color: #1e293b !important; 
    border: 1px solid #334155;
    border-radius: 0 8px 8px 0; 
    box-shadow: 6px 6px 20px rgba(0, 0, 0, 0.4);
    list-style: none !important;
    padding: 6px 0 !important;
    margin: 0 !important;
    z-index: 9999 !important;
}

.sidebar-list > li:hover .submenu {
    display: block !important;
}

.submenu li {
    padding: 0 !important;
    margin: 0 !important;
}

.submenu li a {
    display: block;
    padding: 10px 16px;
    font-size: 13px;
    font-weight: 500;
    color: #cbd5e1 !important;
    text-decoration: none !important;
    box-sizing: border-box;
}

.submenu li a:hover {
    color: #ffffff !important;
    background-color: #0ea5e9 !important; 
    border-radius: 4px; 
}

.control-content-wrapper {
    left: 200px !important; 
    width: calc(100% - 200px) !important;
}
</style>
</head>
<body>
<main>
    <nav>
		<div class="mini-control-box">
            <div class="mini-video-display stream-off" id="mini_videoBox">
                <img id="mini_droneVideo" class="mini-streaming-frame" alt="미니 관제 화면" />
                <div class="mini-video-footer">
                    <span class="mini-channel-title" id="mini_sourceTitle">DRONE1</span>
                </div>
            </div>
            
            <!-- 채널 전환 버튼 -->
            <div class="mini-drone-buttons">
                <button type="button" class="btn-mini-tab active" data-channel="video_1" onclick="switchMiniChannel('video_1')">D1</button>
                <button type="button" class="btn-mini-tab" data-channel="video_2" onclick="switchMiniChannel('video_2')">D2</button>
                <button type="button" class="btn-mini-tab" data-channel="video_3" onclick="switchMiniChannel('video_3')">D3</button>
                <button type="button" class="btn-mini-tab" data-channel="esp32" onclick="switchMiniChannel('esp32')">D4</button>
            </div>
        </div>

        <!-- 기존 메뉴 리스트 -->
        <ul class="sidebar-list">
            <li>
                <a href="#">관리자 메뉴</a>
                <ul class="submenu">
                    <li><a href="<c:url value='/workflow/list'/>">보고서 결재 관리</a></li>
                    <li><a href="<c:url value='/member/list'/>">직원 관리</a></li>
                    <li><a href="<c:url value='/loginlog/list'/>">로그인 이력</a></li>
                    <li><a href="<c:url value='/commoncode/list'/>">시스템 코드</a></li>
                </ul>
            </li>
            
            <li>
                <a href="#">보고서 등록</a>
                <ul class="submenu">
                    <li><a href="<c:url value='/patrolreport/list'/>">업무일지 목록</a></li>
                </ul>
            </li>
            
            <li>
                <a href="#">드론관리</a>
                <ul class="submenu">
                    <li><a href="<c:url value='/flighthistory/list'/>">비행 이력</a></li>
                    <li><a href="<c:url value='/drone/list'/>">드론 관리</a></li>
                </ul>
            </li>
            
            <li>
                <a href="#">이상관리</a>
                <ul class="submenu">
                    <li><a href="<c:url value='/alert/list'/>">경보 이력</a></li>
                    <li><a href="<c:url value='/detection/list'/>">탐지 이력</a></li>
                    <li><a href="<c:url value='/dangerlog/list'/>">이상객체 탐지 이력</a></li>
                    <li><a href="<c:url value='/dashboard/main'/>">통계 대시보드</a></li>
                </ul>
            </li>
            
            <li>
                <a href="#">동물관리</a>
                <ul class="submenu">
                    <li><a href="<c:url value='/animal/list'/>">유기동물 관리</a></li>
                    <li><a href="<c:url value='/danger/list'/>">이상객체 관리</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <div class="control-content-wrapper">
        <!-- 본문 콘텐츠 영역 -->
    </div>
</main>

<script src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
<script>
let miniChannelKey = 'video_1';
const menuContextPath = "${pageContext.request.contextPath}";

$(document).ready(function() {
    checkMiniStatus();
    setInterval(checkMiniStatus, 2000);
});

$('#mini_videoBox').on('click', function() {
    window.location.href = menuContextPath + '/yolo/detail?channel='
        + encodeURIComponent(miniChannelKey);
});

function switchMiniChannel(channelKey) {
    if (miniChannelKey === channelKey) return;
    miniChannelKey = channelKey;
    
    $('.btn-mini-tab').removeClass('active');
    $('.btn-mini-tab').each(function() {
        if ($(this).attr('data-channel') === channelKey) {
            $(this).addClass('active');
        }
    });
    
    const names = { 'video_1': 'DRONE1', 'video_2': 'DRONE2', 'video_3': 'DRONE3', 'esp32': 'DRONE4' };
    $('#mini_sourceTitle').text(names[channelKey] || channelKey.toUpperCase());
    
    checkMiniStatus();
}

function setMiniStream(enabled) {
    const img = document.getElementById('mini_droneVideo');
    const box = document.getElementById('mini_videoBox');
    if (!img) return;
    
    box.classList.remove('stream-error');
    if (enabled) {
        img.onerror = function() {
            box.classList.add('stream-error');
        };
        img.src = menuContextPath + '/yolo/videoFeed/' + encodeURIComponent(miniChannelKey) + '?t=' + new Date().getTime();
    } else {
        img.onerror = null;
        img.removeAttribute('src');
    }
}

function checkMiniStatus() {
    $.ajax({
        url: menuContextPath + '/yolo/detection/status',
        type: 'GET',
        dataType: 'json',
        cache: false,
        success: function(response) {
            const sources = response && response.sources;
            const box = document.getElementById('mini_videoBox');
            if (!sources || !sources[miniChannelKey]) return;
            
            const workerStatus = sources[miniChannelKey];
            const enabled = !!workerStatus.running;
            
            if(box) box.classList.toggle('stream-off', !enabled);
            setMiniStream(enabled);
        }
    });
}
</script>
</body>
</html>
