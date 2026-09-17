<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>유기동물 관제 시스템</title>
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

/* 1. 콘텐츠 전체 영역을 왼쪽 정렬로 변경 */
.control-content-wrapper {
    position: absolute !important;
    top: 80px !important; 
    left: 200px !important; 
    width: calc(100% - 200px) !important; 
    padding: 15px 25px !important; 
    box-sizing: border-box;
    min-height: calc(100vh - 80px);
    display: flex;
    flex-direction: column;
    align-items: flex-start; /* ⭐ 카드를 왼쪽으로 정렬 */
    margin: 0 !important; 
    z-index: 50 !important;
}

/* 1. 메인 카드: 좌우 여백을 최소한으로 유지하며 화면에 맞게 확장 */
.c2-main-card {
    background: rgba(20, 26, 42, 0.85);
    border: 1px solid #1e293b;
    border-radius: 16px;
    padding: 16px;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
    width: calc(100% - 30px); /* 오른쪽에도 최소 30px 정도의 여백만 남기고 꽉 채움 */
    max-width: 1250px; /* 기존 제한 해제 */
    display: flex;
    flex-direction: column;
    align-items: flex-start;
}

/* 2. 비디오 그리드 컨테이너: 카드 안에서 꽉 차게 조절 */
.video-grid-container {
    position: relative;
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 12px;
    width: 100%;
    max-width: none; /* 그리드도 제한을 풀어 카드를 채우도록 함 */
    box-sizing: border-box;
}

.video-display-box {
    background-color: #000000;
    padding: 8px;
    border-radius: 12px;
    border: 2px solid #1e293b;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
    width: 100%;
    box-sizing: border-box;
    position: relative;
    transition: all 0.2s ease;
}

.video-display-box.active-border {
    border-color: #0ea5e9;
    box-shadow: 0 0 25px rgba(14, 165, 233, 0.35);
}

.streaming-frame {
    width: 100%;
    aspect-ratio: 16 / 9;
    height: auto;
    object-fit: cover;
    display: block;
    border-radius: 8px;
    background-color: #000000;
}

.video-display-box.stream-off .streaming-frame,
.video-display-box.stream-error .streaming-frame {
    /* src가 제거된 img의 alt 문구/깨진 이미지 아이콘은 감추되,
       16:9 화면 영역은 그대로 유지한다. */
    visibility: hidden;
}

.video-display-box.stream-off::after {
    content: "탐지 중지";
    position: absolute;
    top: 8px;
    left: 8px;
    right: 8px;
    aspect-ratio: 16 / 9;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #94a3b8;
    font-size: 14px;
    font-weight: 700;
    letter-spacing: 0.04em;
    pointer-events: none;
}

.video-display-box.stream-error::after {
    content: "영상 서버 연결 오류";
    position: absolute;
    top: 8px;
    left: 8px;
    right: 8px;
    aspect-ratio: 16 / 9;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #f87171;
    font-size: 14px;
    font-weight: 700;
    pointer-events: none;
}

.video-card-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 8px;
    padding: 0 4px;
}

.channel-title {
    font-size: 13px;
    font-weight: 700;
    color: #38bdf8;
}

/* 토글 스위치 스타일 */
.switch-item {
    display: flex;
    align-items: center;
    gap: 6px;
    cursor: pointer;
}

.switch-item input {
    display: none;
}

.slider {
    position: relative;
    width: 42px;
    height: 22px;
    background-color: #475569;
    border-radius: 22px;
    transition: background-color 0.2s ease;
}

.slider::before {
    content: "";
    position: absolute;
    top: 2px;
    left: 2px;
    width: 18px;
    height: 18px;
    background-color: #ffffff;
    border-radius: 50%;
    transition: transform 0.2s ease;
}

.switch-item input:checked + .slider {
    background-color: #06b6d4; 
}

.switch-item input:checked + .slider::before {
    transform: translateX(20px);
}

.switch-label {
    font-size: 11px;
    font-weight: 700;
    color: #94a3b8;
    width: 22px;
    text-align: left;
}

.switch-item input:checked ~ .switch-label {
    color: #06b6d4;
}

.switch-item input:disabled + .slider {
    opacity: 0.55;
    cursor: wait;
}

/* 4분할 화면 정중앙에 위치하는 동그란 드론 설정 버튼 */
.drone-center-setting-btn {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 38px;
    height: 38px;
    background-color: #1e293b;
    border: 2px solid #334155;
    color: #94a3b8;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 15px;
    cursor: pointer;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.6);
    transition: all 0.2s ease;
    z-index: 100;
}

.drone-center-setting-btn:hover {
    background-color: #334155;
    color: #ffffff;
    border-color: #0ea5e9;
    box-shadow: 0 0 15px rgba(14, 165, 233, 0.4);
    transform: translate(-50%, -50%) scale(1.08);
}

/* 드론 설정 드롭다운 패널 (중앙 버튼 기준 위치) */
.drone-dropdown-wrapper {
    position: absolute !important;
    top: 50%;
    left: 50%;
    z-index: 1000 !important;
}

#droneSettingDropdown {
    display: none;
    position: absolute;
    top: 28px;
    left: -150px; /* 드롭다운이 중앙 기준으로 예쁘게 열리도록 조정 */
    width: 320px;
    background-color: #131926;
    border: 1px solid #334155;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.7);
    border-radius: 10px;
    padding: 16px;
    box-sizing: border-box;
    z-index: 9999 !important;
}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/menu.jsp" />
<jsp:include page="/WEB-INF/views/header.jsp" />

<div class="control-content-wrapper">
    <div class="c2-main-card">
        
        <!-- 4분할 비디오 그리드 -->
        <div class="video-grid-container">
            
            <!-- 동영상 1번 박스 -->
            <div class="video-display-box stream-off" id="box_video_1">
                <img id="droneVideo_video_1" class="streaming-frame" alt="동영상 1번" />
                <div class="video-card-footer">
                    <span class="channel-title" id="sourceButton_video_1">DRONE-01</span>
                    <label class="switch-item">
                        <input id="toggle_video_1" type="checkbox" disabled onchange="toggleChannelPower('video_1', this)">
                        <span class="slider"></span>
                        <span class="switch-label">OFF</span>
                    </label>
                </div>
            </div>

            <!-- 동영상 2번 박스 -->
            <div class="video-display-box stream-off" id="box_video_2">
                <img id="droneVideo_video_2" class="streaming-frame" alt="동영상 2번" />
                <div class="video-card-footer">
                    <span class="channel-title" id="sourceButton_video_2">DRONE-02</span>
                    <label class="switch-item">
                        <input id="toggle_video_2" type="checkbox" disabled onchange="toggleChannelPower('video_2', this)">
                        <span class="slider"></span>
                        <span class="switch-label">OFF</span>
                    </label>
                </div>
            </div>

            <!-- 동영상 3번 박스 -->
            <div class="video-display-box stream-off" id="box_video_3">
                <img id="droneVideo_video_3" class="streaming-frame" alt="동영상 3번" />
                <div class="video-card-footer">
                    <span class="channel-title" id="sourceButton_video_3">DRONE-03</span>
                    <label class="switch-item">
                        <input id="toggle_video_3" type="checkbox" disabled onchange="toggleChannelPower('video_3', this)">
                        <span class="slider"></span>
                        <span class="switch-label">OFF</span>
                    </label>
                </div>
            </div>

            <!-- 실시간 CAM (ESP32) 박스 -->
            <div class="video-display-box stream-off" id="box_esp32">
                <img id="droneVideo_esp32" class="streaming-frame" alt="실시간 CAM" />
                <div class="video-card-footer">
                    <span class="channel-title" id="sourceButton_esp32">DRONE-04 (ESP32)</span>
                    <label class="switch-item">
                        <input id="toggle_esp32" type="checkbox" disabled onchange="toggleChannelPower('esp32', this)">
                        <span class="slider"></span>
                        <span class="switch-label">OFF</span>
                    </label>
                </div>
            </div>

            <!-- 4분할 화면 중앙에 위치한 동그란 드론 설정 버튼 및 드롭다운 -->
            <div class="drone-dropdown-wrapper">
                <button type="button" id="btnToggleDroneSetting" class="drone-center-setting-btn" title="드론 설정">
                    ⚙
                </button>
                
                <div id="droneSettingDropdown">
                    <h4 style="color: #38bdf8; font-size: 13px; margin-top: 0; margin-bottom: 12px; font-weight: 600; border-bottom: 1px solid #334155; padding-bottom: 6px;">
                        ⚙ 채널별 드론 배정 실시간 매핑
                    </h4>
                    <div style="display: flex; flex-direction: column; gap: 10px;">
                        <div style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 12px;">
                            <span style="width: 80px; color: #94a3b8;">동영상 1번</span>
                            <select id="drone_select_video_1" class="drone-map-select form-select form-select-sm bg-dark text-white border-secondary" style="width: 120px; padding: 4px; border-radius: 4px; font-size: 11px;"></select>
                            <button type="button" onclick="fn_saveDroneMapping('video_1')" class="btn btn-sm btn-primary py-1 px-2" style="font-size:11px;">적용</button>
                        </div>
                        <div style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 12px;">
                            <span style="width: 80px; color: #94a3b8;">동영상 2번</span>
                            <select id="drone_select_video_2" class="drone-map-select form-select form-select-sm bg-dark text-white border-secondary" style="width: 120px; padding: 4px; border-radius: 4px; font-size: 11px;"></select>
                            <button type="button" onclick="fn_saveDroneMapping('video_2')" class="btn btn-sm btn-primary py-1 px-2" style="font-size:11px;">적용</button>
                        </div>
                        <div style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 12px;">
                            <span style="width: 80px; color: #94a3b8;">동영상 3번</span>
                            <select id="drone_select_video_3" class="drone-map-select form-select form-select-sm bg-dark text-white border-secondary" style="width: 120px; padding: 4px; border-radius: 4px; font-size: 11px;"></select>
                            <button type="button" onclick="fn_saveDroneMapping('video_3')" class="btn btn-sm btn-primary py-1 px-2" style="font-size:11px;">적용</button>
                        </div>
                        <div style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 12px;">
                            <span style="width: 80px; color: #5ddcff; font-weight: bold;">실시간 CAM</span>
                            <select id="drone_select_esp32" class="drone-map-select form-select form-select-sm bg-dark text-white border-secondary" style="width: 120px; padding: 4px; border-radius: 4px; font-size: 11px;"></select>
                            <button type="button" onclick="fn_saveDroneMapping('esp32')" class="btn btn-sm btn-success py-1 px-2" style="font-size:11px;">적용</button>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </div> 
</div> 

<script src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
<script>
 const yoloSourceKeys = ['video_1', 'video_2', 'video_3', 'esp32'];
 const yoloContextPath = "${pageContext.request.contextPath}";
 const detectionEnabled = {};
 const isToggling = {};
 let detectionStatusRefreshTimer = null;

 function getChannelElements(channelKey) {
     return {
         image: document.getElementById('droneVideo_' + channelKey),
         box: document.getElementById('box_' + channelKey),
         checkbox: document.getElementById('toggle_' + channelKey)
     };
 }

 function setChannelStream(channelKey, enabled) {
     const elements = getChannelElements(channelKey);
     if (!elements.image) return;
     elements.box.classList.remove('stream-error');
     if (enabled) {
         elements.image.onerror = function() {
             elements.box.classList.add('stream-error');
         };
         elements.image.src = yoloContextPath + '/yolo/videoFeed/' + encodeURIComponent(channelKey)
             + '?t=' + new Date().getTime();
     } else {
         // MJPEG는 숨기는 것만으로 연결이 끊기지 않으므로 src 자체를 제거한다.
         elements.image.onerror = null;
         elements.image.removeAttribute('src');
     }
 }

 function renderChannelState(channelKey, enabled, disabled, statusText) {
	    const elements = getChannelElements(channelKey);
	    if (!elements.checkbox || !elements.box) return;
	    
	    elements.checkbox.checked = !!enabled;
	    elements.checkbox.disabled = !!disabled;
	    
	    elements.box.classList.toggle('stream-off', !enabled);
	    
	    elements.box.classList.toggle('active-border', !!enabled);
	    
	    const label = elements.checkbox.parentElement.querySelector('.switch-label');
	    if (label) label.innerText = statusText || (enabled ? 'ON' : 'OFF');
	}

 function applyServerChannelState(channelKey, workerStatus) {
     const enabled = !!(workerStatus && workerStatus.running);
     const stopping = !!(workerStatus && workerStatus.stopping);
     detectionEnabled[channelKey] = enabled;
     renderChannelState(channelKey, enabled, stopping, stopping ? 'STOPPING' : null);
     setChannelStream(channelKey, enabled);
     return stopping;
 }

 function readDetectionStatus() {
     $.ajax({
         url: yoloContextPath + '/yolo/detection/status',
         type: 'GET',
         dataType: 'json',
         cache: false,
         success: function(response) {
             const sources = response && response.sources;
             if (!sources) {
                 handleDetectionStatusFailure();
                 return;
             }
             let hasStoppingWorker = false;
             yoloSourceKeys.forEach(function(channelKey) {
                 hasStoppingWorker = applyServerChannelState(channelKey, sources[channelKey]) || hasStoppingWorker;
             });
             scheduleDetectionStatusRefresh(hasStoppingWorker ? 700 : 2000);
         },
         error: function() {
             handleDetectionStatusFailure();
             scheduleDetectionStatusRefresh(3000);
         }
     });
 }

 function scheduleDetectionStatusRefresh(delay) {
     window.clearTimeout(detectionStatusRefreshTimer);
     detectionStatusRefreshTimer = window.setTimeout(readDetectionStatus, delay);
 }

 function handleDetectionStatusFailure() {
     yoloSourceKeys.forEach(function(channelKey) {
         const elements = getChannelElements(channelKey);
         if (!elements.checkbox) return;
         elements.checkbox.disabled = true;
         const label = elements.checkbox.parentElement.querySelector('.switch-label');
         if (label) label.innerText = 'ERR';
     });
 }

 function toggleChannelPower(channelKey, checkbox) {
     const previousState = !!detectionEnabled[channelKey];
     const requestedState = checkbox.checked;
     if (isToggling[channelKey]) {
         checkbox.checked = previousState;
         return;
     }
     if (requestedState === previousState) {
         renderChannelState(channelKey, previousState, false);
         return;
     }

     isToggling[channelKey] = true;
     renderChannelState(channelKey, previousState, true, '...');
     if (!requestedState) setChannelStream(channelKey, false);

     $.ajax({
         url: yoloContextPath + '/yolo/detection/' + encodeURIComponent(channelKey)
             + '/' + (requestedState ? 'start' : 'stop'),
         type: 'POST',
         dataType: 'json'
     }).done(function(response) {
         const workerStatus = response && response.sources && response.sources[channelKey];
         const actualState = !!(workerStatus && workerStatus.running);
         if (response.status !== 'SUCCESS' || actualState !== requestedState) {
             detectionEnabled[channelKey] = previousState;
             renderChannelState(channelKey, previousState, false);
             setChannelStream(channelKey, previousState);
             alert('[' + channelKey + '] worker 상태가 요청과 일치하지 않습니다.');
             return;
         }
         detectionEnabled[channelKey] = actualState;
         renderChannelState(channelKey, actualState, false);
         setChannelStream(channelKey, actualState);
     }).fail(function() {
         detectionEnabled[channelKey] = previousState;
         renderChannelState(channelKey, previousState, false);
         setChannelStream(channelKey, previousState);
         alert('[' + channelKey + '] 탐지 worker 상태 변경에 실패했습니다.');
     }).always(function() {
         isToggling[channelKey] = false;
         const enabled = !!detectionEnabled[channelKey];
         renderChannelState(channelKey, enabled, false);
     });
 }

 $(document).ready(function() {
     readDetectionStatus();
 });
</script>

<script>
 $('#btnToggleDroneSetting').on('click', function(e) {
     e.stopPropagation(); 
     $('#droneSettingDropdown').fadeToggle(150);
 });
 $('#droneSettingDropdown').on('click', function(e) {
     e.stopPropagation();
 });
 $(document).on('click', function() {
     $('#droneSettingDropdown').fadeOut(100);
 });
 $(document).ready(function() {
     fn_loadCurrentDroneMappings();
 });

 function fn_loadCurrentDroneMappings() {
     $.ajax({
         url: "${pageContext.request.contextPath}/yolo/currentMappings",
         type: "GET",
         dataType: "json",
         cache: false,
         success: function(res) {
             if(res) {
                 var drones = res.dbDroneList; 
                 var mappings = res.activeMappings; 
                 $(".drone-map-select").each(function() {
                     var $el = $(this);
                     $el.empty(); 
                     if(drones && drones.length > 0) {
                         drones.forEach(function(droneId) {
                             $el.append($('<option>', {
                                 value: droneId,
                                 text: droneId
                             }));
                         });
                     } else {
                         $el.append('<option value="">등록 드론 없음</option>');
                     }
                 });
                 if(mappings) {
                     Object.keys(mappings).forEach(function(key) {
                         var targetSelect = $("#drone_select_" + key);
                         if(targetSelect.length > 0) {
                             targetSelect.val(mappings[key]);
                         }
                     });
                 }
                 fn_updateSourceButtonLabels(mappings);
             }
         },
         error: function(xhr, status, error) {
             console.error("❌ 드론 맵 정보 획득 실패 사유: ", error);
         }
     });
 }
 
 function fn_updateSourceButtonLabels(mappings) {
     var sourceDefaults = {
         video_1: 'DRONE-01',
         video_2: 'DRONE-02',
         video_3: 'DRONE-03',
         esp32: 'DRONE-04 (ESP32)'
     };
     Object.keys(sourceDefaults).forEach(function(sourceKey) {
         var $title = $("#sourceButton_" + sourceKey);
         if (!$title.length) return;
         var droneId = mappings && mappings[sourceKey];
         $title.text(droneId || sourceDefaults[sourceKey]);
     });
 }
 
 function fn_saveDroneMapping(sourceKey) {
     var targetSelect = $("#drone_select_" + sourceKey);
     if (targetSelect.length === 0) {
         alert("해당 채널의 설정 요소를 찾을 수 없습니다.");
         return;
     }
     var droneId = targetSelect.val();
     if (!droneId) {
         alert("배정할 드론을 선택해 주세요.");
         return;
     }
     $.ajax({
         url: "${pageContext.request.contextPath}/yolo/updateMapping",
         type: "POST",
         dataType: "json",
         data: {
             sourceKey: sourceKey,
             droneId: droneId
         },
         success: function(res) {
             if (res && res.status === "SUCCESS") {
                 alert("✅ [" + sourceKey + "] 채널에 드론 배정이 완벽하게 적용되었습니다.");
                 $('#droneSettingDropdown').fadeOut(100);
                 fn_loadCurrentDroneMappings();
             } else {
                 alert("❌ 서버 처리 중 매핑 적용에 실패했습니다.");
             }
         },
         error: function(xhr, status, error) {
             console.error("❌ 드론 매핑 적용 통신 실패 사유: ", error);
             alert("서버와 통신 중 오류가 발생했습니다.");
         }
     });
 }
</script>

<script>
$('.video-display-box').on('click', function(e) {
    if ($(e.target).closest('.switch-item, .drone-dropdown-wrapper, button, select').length > 0) {
        return;
    }
    const boxId = $(this).attr('id'); // 예: box_video_1, box_esp32 등
    const channelKey = boxId.replace('box_', '');
    location.href = yoloContextPath + '/yolo/detail?channel=' + encodeURIComponent(channelKey);
});
</script>
</body>
</html>
