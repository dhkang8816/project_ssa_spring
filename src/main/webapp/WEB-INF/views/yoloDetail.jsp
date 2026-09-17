<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>유기동물 관제 시스템 - 상세 관제</title>
<link rel="stylesheet" href="<c:url value='/resources/css/style.css'/>">

<style>
body {
    margin: 0;
    padding: 0;
    background-color: #0b0f19; 
    color: #e2e8f0;
    font-family: 'Segoe UI', Roboto, sans-serif;
    overflow-x: hidden;
}

header, .top-header {
    position: fixed !important;
    top: 0 !important;
    left: 0 !important;
    width: 100% !important;
    height: 80px !important;
    z-index: 1000 !important;
}

.control-content-wrapper {
    position: absolute !important;
    top: 80px !important; 
    left: 250px !important; 
    width: calc(100% - 250px) !important; 
    padding: 25px 35px;
    box-sizing: border-box;
    min-height: calc(100vh - 80px);
    display: flex;
    flex-direction: column;
    align-items: flex-start; 
    margin: 0 !important; 
    z-index: 50 !important;
}

.c2-main-card {
    background: rgba(20, 26, 42, 0.85);
    border: 1px solid #1e293b;
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
    width: 100%;
    max-width: 1200px; 
    display: flex;
    flex-direction: column;
    align-items: flex-start;
}

/* 상단 네비게이션 및 드론 전환 버튼 바 */
.detail-top-bar {
    width: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
}

.btn-back {
    background-color: #1e293b;
    color: #94a3b8;
    border: 1px solid #334155;
    padding: 6px 14px;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.2s ease;
}

.btn-back:hover {
    background-color: #334155;
    color: #ffffff;
}

/* 드론 채널 빠른 전환 버튼 그룹 */
.drone-switch-buttons {
    display: flex;
    gap: 8px;
}

.btn-drone-tab {
    background-color: #1e293b;
    color: #94a3b8;
    border: 1px solid #334155;
    padding: 6px 14px;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    text-decoration: none;
    transition: all 0.2s ease;
}

.btn-drone-tab:hover {
    background-color: #334155;
    color: #ffffff;
}

.btn-drone-tab.active {
    background-color: #0ea5e9;
    color: #ffffff;
    border-color: #38bdf8;
    box-shadow: 0 0 12px rgba(14, 165, 233, 0.4);
}

.single-video-display-box {
    background-color: #000000;
    padding: 12px;
    border-radius: 14px;
    border: 2px solid #1e293b; 
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
    width: 100%;
    box-sizing: border-box;
    position: relative;
    transition: all 0.2s ease;
}

.single-video-display-box.active-border {
    border-color: #0ea5e9;
    box-shadow: 0 0 30px rgba(14, 165, 233, 0.3);
}

.streaming-frame-large {
    width: 100%;
    aspect-ratio: 16 / 9;
    max-height: 600px;
    object-fit: cover;
    display: block;
    border-radius: 8px;
    background-color: #000000;
}

.single-video-display-box.stream-off .streaming-frame-large,
.single-video-display-box.stream-error .streaming-frame-large {
    visibility: hidden;
}

.single-video-display-box.stream-off::after {
    content: "탐지 중지됨";
    position: absolute;
    top: 12px; left: 12px; right: 12px;
    aspect-ratio: 16 / 9;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #94a3b8;
    font-size: 16px;
    font-weight: 700;
}

.single-video-display-box.stream-error::after {
    content: "영상 서버 연결 오류";
    position: absolute;
    top: 12px; left: 12px; right: 12px;
    aspect-ratio: 16 / 9;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #f87171;
    font-size: 16px;
    font-weight: 700;
}

.video-card-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 12px;
    padding: 0 6px;
}

.channel-title {
    font-size: 15px;
    font-weight: 700;
    color: #38bdf8;
}

/* 토글 스위치 스타일 */
.switch-item {
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
}

.switch-item input {
    display: none;
}

.slider {
    position: relative;
    width: 48px;
    height: 24px;
    background-color: #475569;
    border-radius: 24px;
    transition: background-color 0.2s ease;
}

.slider::before {
    content: "";
    position: absolute;
    top: 2px;
    left: 2px;
    width: 20px;
    height: 20px;
    background-color: #ffffff;
    border-radius: 50%;
    transition: transform 0.2s ease;
}

.switch-item input:checked + .slider {
    background-color: #06b6d4; 
}

.switch-item input:checked + .slider::before {
    transform: translateX(24px);
}

.switch-label {
    font-size: 12px;
    font-weight: 700;
    color: #94a3b8;
    width: 26px;
    text-align: left;
}

.switch-item input:checked ~ .switch-label {
    color: #06b6d4;
}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/menu.jsp" />
<jsp:include page="/WEB-INF/views/header.jsp" />

<div class="control-content-wrapper">
    <div class="c2-main-card">
        
        <!-- 상단 바 -->
        <div class="detail-top-bar">
            <!-- 메인 관제 화면(예: /yolo/view 등)으로 바로 이동하도록 지정 -->
            <a href="${pageContext.request.contextPath}/yolo/view" class="btn-back">⬅</a>
            
            <div class="drone-switch-buttons">
                <button type="button" class="btn-drone-tab" data-channel="video_1" onclick="switchChannel('video_1')">DRONE 1</button>
                <button type="button" class="btn-drone-tab" data-channel="video_2" onclick="switchChannel('video_2')">DRONE 2</button>
                <button type="button" class="btn-drone-tab" data-channel="video_3" onclick="switchChannel('video_3')">DRONE 3</button>
                <button type="button" class="btn-drone-tab" data-channel="esp32" onclick="switchChannel('esp32')">DRONE 4</button>
            </div>
        </div>

        <div class="single-video-display-box stream-off" id="box_single">
            <img id="droneVideo_single" class="streaming-frame-large" alt="상세 드론 화면" />
            <div class="video-card-footer">
                <span class="channel-title" id="sourceButton_single">LOADING...</span>
                <label class="switch-item">
                    <input id="toggle_single" type="checkbox" disabled onchange="toggleDetailChannelPower(this)">
                    <span class="slider"></span>
                    <span class="switch-label">OFF</span>
                </label>
            </div>
        </div>

    </div> 
</div> 

<script src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
<script>
 const urlParams = new URLSearchParams(window.location.search);
 let currentChannelKey = urlParams.get('channel') || 'video_1';
 const yoloContextPath = "${pageContext.request.contextPath}";
 
 let detectionEnabled = false;
 let isToggling = false;

 $(document).ready(function() {
     updateActiveTabUI();
     readStatus();
     fn_loadMappingInfo();
     
     setInterval(readStatus, 2000);
 });

 // 새로고침 없는 비동기 드론 채널 변경
 function switchChannel(channelKey) {
     if (currentChannelKey === channelKey) return;
     currentChannelKey = channelKey;
     
     const newUrl = window.location.pathname + '?channel=' + channelKey;
     window.history.pushState({ channel: channelKey }, '', newUrl);

     updateActiveTabUI();
     readStatus();
     fn_loadMappingInfo();
 }

 // 브라우저 뒤로가기/앞으로가기 감지 시 채널 동기화
 window.addEventListener('popstate', function(event) {
     const params = new URLSearchParams(window.location.search);
     const channel = params.get('channel') || 'video_1';
     
     if (currentChannelKey !== channel) {
         currentChannelKey = channel;
         updateActiveTabUI();
         readStatus();
         fn_loadMappingInfo();
     }
 });

 function updateActiveTabUI() {
     $('.btn-drone-tab').removeClass('active');
     $('.btn-drone-tab').each(function() {
         if ($(this).attr('data-channel') === currentChannelKey) {
             $(this).addClass('active');
         }
     });
 }

 function getElements() {
     return {
         image: document.getElementById('droneVideo_single'),
         box: document.getElementById('box_single'),
         checkbox: document.getElementById('toggle_single'),
         title: document.getElementById('sourceButton_single')
     };
 }

 function setStream(enabled) {
     const els = getElements();
     if (!els.image) return;
     els.box.classList.remove('stream-error');
     if (enabled) {
         els.image.onerror = function() {
             els.box.classList.add('stream-error');
         };
         els.image.src = yoloContextPath + '/yolo/videoFeed/' + encodeURIComponent(currentChannelKey)
             + '?t=' + new Date().getTime();
     } else {
         els.image.onerror = null;
         els.image.removeAttribute('src');
     }
 }

 function renderState(enabled, disabled, statusText) {
     const els = getElements();
     if (!els.checkbox || !els.box) return;
     els.checkbox.checked = !!enabled;
     els.checkbox.disabled = !!disabled;
     els.box.classList.toggle('stream-off', !enabled);
     els.box.classList.toggle('active-border', !!enabled);
     const label = els.checkbox.parentElement.querySelector('.switch-label');
     if (label) label.innerText = statusText || (enabled ? 'ON' : 'OFF');
 }

 function readStatus() {
     $.ajax({
         url: yoloContextPath + '/yolo/detection/status',
         type: 'GET',
         dataType: 'json',
         cache: false,
         success: function(response) {
             const sources = response && response.sources;
             if (!sources || !sources[currentChannelKey]) return;
             
             const workerStatus = sources[currentChannelKey];
             const enabled = !!workerStatus.running;
             const stopping = !!workerStatus.stopping;
             
             detectionEnabled = enabled;
             renderState(enabled, stopping, stopping ? 'STOPPING' : null);
             setStream(enabled);
         }
     });
 }

 function toggleDetailChannelPower(checkbox) {
     const previousState = detectionEnabled;
     const requestedState = checkbox.checked;
     if (isToggling) {
         checkbox.checked = previousState;
         return;
     }

     isToggling = true;
     renderState(previousState, true, '...');
     if (!requestedState) setStream(false);

     $.ajax({
         url: yoloContextPath + '/yolo/detection/' + encodeURIComponent(currentChannelKey)
             + '/' + (requestedState ? 'start' : 'stop'),
         type: 'POST',
         dataType: 'json'
     }).done(function(response) {
         const workerStatus = response && response.sources && response.sources[currentChannelKey];
         const actualState = !!(workerStatus && workerStatus.running);
         
         detectionEnabled = actualState;
         renderState(actualState, false);
         setStream(actualState);
     }).fail(function() {
         detectionEnabled = previousState;
         renderState(previousState, false);
         setStream(previousState);
         alert('탐지 worker 상태 변경에 실패했습니다.');
     }).always(function() {
         isToggling = false;
     });
 }

 function fn_loadMappingInfo() {
     $.ajax({
         url: yoloContextPath + '/yolo/currentMappings',
         type: 'GET',
         dataType: 'json',
         cache: false,
         success: function(res) {
             if(res && res.activeMappings) {
                 var mappings = res.activeMappings;
                 if(mappings[currentChannelKey]) {
                     $('#sourceButton_single').text(mappings[currentChannelKey]);
                 } else {
                     $('#sourceButton_single').text(currentChannelKey.toUpperCase());
                 }
             }
         }
     });
 }
</script>
</body>
</html>