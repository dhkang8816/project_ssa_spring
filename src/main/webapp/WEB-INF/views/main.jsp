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
    max-width: 1150px; 
    display: flex;
    flex-direction: column;
    align-items: flex-start;
}

/* 4분할 그리드 레이아웃 (중앙 설정 버튼 배치를 위해 relative 지정) */
.video-grid-container {
    position: relative;
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    grid-template-rows: repeat(2, 1fr);
    gap: 18px;
    width: 100%;
    max-width: 1100px;
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
    height: 240px;
    object-fit: cover;
    display: block;
    border-radius: 8px;
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
            <div class="video-display-box active-border" id="box_video_1">
                <img id="droneVideo_1" src="${pageContext.request.contextPath}/yolo/videoFeed" class="streaming-frame" alt="동영상 1번" />
                <div class="video-card-footer">
                    <span class="channel-title" id="sourceButton_video_1">DRONE-01</span>
                    <label class="switch-item">
                        <input type="checkbox" checked onchange="toggleChannelPower('video_1', this)">
                        <span class="slider"></span>
                        <span class="switch-label">ON</span>
                    </label>
                </div>
            </div>

            <!-- 동영상 2번 박스 -->
            <div class="video-display-box" id="box_video_2">
                <img id="droneVideo_2" src="${pageContext.request.contextPath}/yolo/videoFeed" class="streaming-frame" alt="동영상 2번" />
                <div class="video-card-footer">
                    <span class="channel-title" id="sourceButton_video_2">DRONE-02</span>
                    <label class="switch-item">
                        <input type="checkbox" checked onchange="toggleChannelPower('video_2', this)">
                        <span class="slider"></span>
                        <span class="switch-label">ON</span>
                    </label>
                </div>
            </div>

            <!-- 동영상 3번 박스 -->
            <div class="video-display-box" id="box_video_3">
                <img id="droneVideo_3" src="${pageContext.request.contextPath}/yolo/videoFeed" class="streaming-frame" alt="동영상 3번" />
                <div class="video-card-footer">
                    <span class="channel-title" id="sourceButton_video_3">DRONE-03</span>
                    <label class="switch-item">
                        <input type="checkbox" checked onchange="toggleChannelPower('video_3', this)">
                        <span class="slider"></span>
                        <span class="switch-label">ON</span>
                    </label>
                </div>
            </div>

            <!-- 실시간 CAM (ESP32) 박스 -->
            <div class="video-display-box" id="box_esp32">
                <img id="droneVideo_esp32" src="${flaskEsp32VideoUrl}" class="streaming-frame" alt="실시간 CAM" />
                <div class="video-card-footer">
                    <span class="channel-title" id="sourceButton_esp32">DRONE-04 (ESP32)</span>
                    <label class="switch-item">
                        <input type="checkbox" checked onchange="toggleChannelPower('esp32', this)">
                        <span class="slider"></span>
                        <span class="switch-label">ON</span>
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
 const toggleChannelPower = (channelKey, checkbox) => {
     const isChecked = checkbox.checked;
     const labelEl = checkbox.parentElement.querySelector('.switch-label');
     
     if (isChecked) {
         labelEl.innerText = "ON";
         console.log("🔌 [" + channelKey + "] 화면 켜짐");
     } else {
         labelEl.innerText = "OFF";
         console.log("🔌 [" + channelKey + "] 화면 꺼짐");
     }
 };
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
</body>
</html>