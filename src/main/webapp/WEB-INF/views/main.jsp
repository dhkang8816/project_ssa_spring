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
    padding: 30px 40px;
    box-sizing: border-box;
    min-height: calc(100vh - 80px);
    display: flex;
    flex-direction: column;
    align-items: flex-start; 
    margin: 0 !important; 
    z-index: 50 !important;
}


.section-title {
    color: #ffffff;
    font-size: 22px;
    font-weight: 700;
    margin-top: 5px;
    margin-bottom: 25px;
    letter-spacing: -0.02em;
    width: 100%;
    text-align: left;
}


.c2-main-card {
    background: rgba(20, 26, 42, 0.85);
    border: 1px solid #1e293b;
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
    width: 100%;
    max-width: 1000px;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
}


.video-display-box {
    background-color: #000000;
    padding: 6px;
    border-radius: 12px;
    border: 2px solid #0ea5e9;
    box-shadow: 0 0 25px rgba(14, 165, 233, 0.25);
    width: 100%;
    max-width: 960px;
    box-sizing: border-box;
    position: relative;
}


.streaming-frame {
    width: 100%;
    height: auto;
    display: block;
    border-radius: 8px;
}


.control-bottom-bar {
    width: 100%;
    max-width: 960px;
    display: flex;
    flex-direction: column;
    align-items: flex-start; 
    margin-top: 15px;
    gap: 15px;
}

.video-btn-wrapper {
    display: flex;
    gap: 8px;
    justify-content: flex-start; 
    width: 100%;
}


.btn-change {
    display: inline-block;
    padding: 9px 16px;
    background-color: #1e293b;
    color: #94a3b8;
    border: 1px solid #334155;
    text-decoration: none;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 600;
    transition: all 0.2s ease;
    cursor: pointer;
}

.btn-change:hover {
    background-color: #334155;
    color: #ffffff;
}


.btn-change.active-drone {
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
    border-color: #38bdf8 !important;
    box-shadow: 0 0 15px rgba(14, 165, 233, 0.4);
}

.btn-esp {
    background-color: #059669;
    border-color: #10b981;
    color: #ffffff;
}
.btn-esp:hover {
    background-color: #10b981;
    box-shadow: 0 0 15px rgba(16, 185, 129, 0.3);
}


.drone-dropdown-wrapper {
    width: 100%;
    display: flex !important;
    justify-content: flex-start !important; 
    position: relative !important;
    box-sizing: border-box;
    z-index: 1000 !important;
}

#droneSettingDropdown {
    display: none;
    position: absolute;
    top: 38px;
    left: 0; 
    width: 320px;
    background-color: #131926;
    border: 1px solid #334155;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.6);
    border-radius: 10px;
    padding: 18px;
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
        
        
        <div class="video-display-box">
            <img id="droneVideo" src="${pageContext.request.contextPath}/yolo/videoFeed" class="streaming-frame" alt="실시간 드론 관제 스트리밍" />
        </div>
        
        
        <div class="control-bottom-bar">
            
            
            <div class="video-btn-wrapper">
                <button type="button" onclick="switchMode('video_1')" class="btn-change" id="sourceButton_video_1">동영상 1번</button>
                <button type="button" onclick="switchMode('video_2')" class="btn-change" id="sourceButton_video_2">동영상 2번</button>
                <button type="button" onclick="switchMode('video_3')" class="btn-change" id="sourceButton_video_3">동영상 3번</button>
                <button type="button" onclick="switchMode('esp32')" class="btn-change btn-esp" id="sourceButton_esp32">실시간 드론 CAM (ESP32)</button>
            </div>
            
            
            <div class="drone-dropdown-wrapper">
                <button type="button" id="btnToggleDroneSetting" class="btn btn-sm btn-dark border-secondary text-white" style="cursor: pointer; padding: 6px 14px; border-radius: 6px; font-weight: 500;">
                    ⚙ 드론 설정
                </button>
                
                <div id="droneSettingDropdown">
                    <h4 style="color: #38bdf8; font-size: 14px; margin-top: 0; margin-bottom: 15px; font-weight: 600; border-bottom: 1px solid #334155; padding-bottom: 8px;">
                        ⚙ 채널별 드론 배정 실시간 매핑
                    </h4>
                    <div style="display: flex; flex-direction: column; gap: 12px;">
                        <div style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 13px;">
                            <span style="width: 90px; color: #94a3b8;">동영상 1번</span>
                            <select id="drone_select_video_1" class="drone-map-select form-select form-select-sm bg-dark text-white border-secondary" style="width: 120px; padding: 4px; border-radius: 4px;"></select>
                            <button type="button" onclick="fn_saveDroneMapping('video_1')" class="btn btn-sm btn-primary py-1 px-2" style="font-size:12px;">적용</button>
                        </div>
                        <div style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 13px;">
                            <span style="width: 90px; color: #94a3b8;">동영상 2번</span>
                            <select id="drone_select_video_2" class="drone-map-select form-select form-select-sm bg-dark text-white border-secondary" style="width: 120px; padding: 4px; border-radius: 4px;"></select>
                            <button type="button" onclick="fn_saveDroneMapping('video_2')" class="btn btn-sm btn-primary py-1 px-2" style="font-size:12px;">적용</button>
                        </div>
                        <div style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 13px;">
                            <span style="width: 90px; color: #94a3b8;">동영상 3번</span>
                            <select id="drone_select_video_3" class="drone-map-select form-select form-select-sm bg-dark text-white border-secondary" style="width: 120px; padding: 4px; border-radius: 4px;"></select>
                            <button type="button" onclick="fn_saveDroneMapping('video_3')" class="btn btn-sm btn-primary py-1 px-2" style="font-size:12px;">적용</button>
                        </div>
                        <div style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 13px;">
                            <span style="width: 90px; color: #5ddcff; font-weight: bold;">실시간 CAM</span>
                            <select id="drone_select_esp32" class="drone-map-select form-select form-select-sm bg-dark text-white border-secondary" style="width: 120px; padding: 4px; border-radius: 4px;"></select>
                            <button type="button" onclick="fn_saveDroneMapping('esp32')" class="btn btn-sm btn-success py-1 px-2" style="font-size:12px;">적용</button>
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
 const esp32VideoUrl = "${flaskEsp32VideoUrl}" || "http://localhost:5000/esp32_yolov12/video_feed";
 const switchMode = (modeKey) => {
     const video = document.getElementById('droneVideo');
     video.src = ""; // 좀비 세션 방어선
     $(".btn-change").removeClass("active-drone");
     $("#sourceButton_" + modeKey).addClass("active-drone");
 
     if (modeKey === 'esp32') {
         fetch("${pageContext.request.contextPath}/yolo/changeVideo/esp32")
         .then(res => {
             console.log("✈ [자바 통지 성공] ESP32 모드 전환 완료");
            setTimeout(() => {
                video.src = esp32VideoUrl;
            }, 80);
         })
         .catch(err => console.error("ESP32 모드 전환 신호 실패:", err));
 
     } else {
         fetch("${pageContext.request.contextPath}/yolo/changeVideo/" + modeKey)
         .then(res => {
             console.log("✈ [동영상 소스 변경 성공] 타겟: " + modeKey);
            setTimeout(() => {
                video.src = "${pageContext.request.contextPath}/yolo/videoFeed?t=" + new Date().getTime();
            }, 80);
         })
         .catch(err => console.error("소스 변경 통신 실패:", err));
     }
 };

</script>

<script>
 $('#btnToggleDroneSetting').on('click', function(e) {
     e.stopPropagation(); // 이벤트 버블링 차단
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
         cache: false, // 브라우저 사이드 캐시 노이즈 원천 차단
         success: function(res) {
             console.log("✈ [시큐리티 돌파 수신 완료]:", res);
             if(res) {
                 var drones = res.dbDroneList; 
                 var mappings = res.activeMappings; 
                 $(".drone-map-select").each(function() {
                     var $el = $(this);
                     $el.empty(); // 텅 빈 상태로 초기화
 
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
         video_1: '동영상 1번',
         video_2: '동영상 2번',
         video_3: '동영상 3번',
         esp32: '실시간 드론 CAM (ESP32)'
     };
     Object.keys(sourceDefaults).forEach(function(sourceKey) {
         var $button = $("#sourceButton_" + sourceKey);
         if (!$button.length) {
             return;
         }
         var droneId = mappings && mappings[sourceKey];
         $button.text(droneId || sourceDefaults[sourceKey]);
         $button.attr('title', droneId ? sourceDefaults[sourceKey] + ' · ' + droneId : sourceDefaults[sourceKey]);
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
         dataType: "json", // 컨트롤러가 리턴하는 JSON({"status":"SUCCESS"}) 포맷 대응
         data: {
             sourceKey: sourceKey,
             droneId: droneId
         },
         success: function(res) {
             if (res && res.status === "SUCCESS") {
                 alert(" [" + sourceKey + "] 채널에 드론 배정이 완벽하게 적용되었습니다.");
                 $('#droneSettingDropdown').fadeOut(100);
                 fn_loadCurrentDroneMappings();
             } else {
                 alert("❌ 서버 처리 중 매핑 적용에 실패했습니다.");
             }
         },
         error: function(xhr, status, error) {
             console.error("❌ 드론 매핑 적용 통신 실패 사유: ", error);
             alert("서버와 통신 중 오류가 발생했습니다. (컨트롤러 확인 필요)");
         }
     });
 }
</script>
</body>
</html>
