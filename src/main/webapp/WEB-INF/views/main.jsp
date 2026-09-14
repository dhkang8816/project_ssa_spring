<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>유기동물 관제 시스템</title>
<link rel="stylesheet" href="<c:url value='/resources/css/style.css'/>">
<!-- 🎨 하이테크 관제소 컴포넌트 전용 추가 스타일 (기본 기능 스크립트는 하단 보존) -->
<style>
/* 1. 글로벌 바디 및 가로 스크롤 누수 차단 */
body {
    margin: 0;
    padding: 0;
    background-color: #0b0f19; /* 깊은 사이버 블랙 톤 */
    color: #e2e8f0;
    font-family: 'Segoe UI', Roboto, sans-serif;
    overflow-x: hidden;
}

/* 2. 상단 헤더 고정 (최상단 레이어 잠금) */
header, .top-header {
    position: fixed !important;
    top: 0 !important;
    left: 0 !important;
    width: 100% !important;
    height: 80px !important;
    z-index: 1000 !important;
}

/* 3. 좌측 정위치 완전 밀착 정렬 및 좌측 정렬 기반 */
.control-content-wrapper {
    position: absolute !important;
    top: 80px !important; 
    left: 250px !important; /* 좌측 메뉴바 너비 바로 뒤에 밀착 */
    width: calc(100% - 250px) !important; /* 남은 전체 우측 레이아웃 확보 */
    padding: 30px 40px;
    box-sizing: border-box;
    min-height: calc(100vh - 80px);
    display: flex;
    flex-direction: column;
    align-items: flex-start; /* 완벽한 좌측 정렬 */
    margin: 0 !important; 
    z-index: 50 !important;
}

/* 4. 관제 메인 타이틀 디자인 */
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

/* 5. 와이드 하이테크 관제 대시보드 카드 (좌측 정렬 및 영상 대형화) */
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

/* 6. 블랙 비디오 디스플레이 박스 (최대 960px 대형 스케일 아키텍처) */
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

/* 7. YOLOv8 스트리밍 가변 반응형 핏 */
.streaming-frame {
    width: 100%;
    height: auto;
    display: block;
    border-radius: 8px;
}

/* 8. 투명 도화지 캔버스 오버레이 레이어 */
.ai-canvas-overlay {
    position: absolute;
    top: 6px;
    left: 6px;
    width: calc(100% - 12px);
    height: calc(100% - 12px);
    pointer-events: none;
    border-radius: 8px;
    z-index: 10;
}

/* 9. [요청 전면 반영] 채널 버튼 조작 영역 좌측 정렬 제어 박스 */
.control-bottom-bar {
    width: 100%;
    max-width: 960px;
    display: flex;
    flex-direction: column;
    align-items: flex-start; /* ⭕ 모든 조작 UI 요소를 좌측으로 정렬 변경 */
    margin-top: 15px;
    gap: 15px;
}

.video-btn-wrapper {
    display: flex;
    gap: 8px;
    justify-content: flex-start; /* ⭕ 버튼 내부 좌측 정렬 */
    width: 100%;
}

/* 10. 조작 스위치 버튼 스타일 모던화 */
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

/* 활성화 채널 하이라이트 */
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

/* 11. 드롭다운 컴포넌트 정돈 */
.drone-dropdown-wrapper {
    width: 100%;
    display: flex !important;
    justify-content: flex-start !important; /* ⭕ 드론 설정 버튼 및 팝업창도 좌측 기준으로 배치 */
    position: relative !important;
    box-sizing: border-box;
    z-index: 1000 !important;
}

#droneSettingDropdown {
    display: none;
    position: absolute;
    top: 38px;
    left: 0; /* ⭕ 드롭다운 레이어 창이 버튼 아래 좌측 기준으로 열리도록 정돈 */
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
        
        <!-- 실시간 관제 대형 비디오 상자 -->
        <div class="video-display-box">
            <img id="droneVideo" src="${pageContext.request.contextPath}/yolo/videoFeed" class="streaming-frame" alt="실시간 드론 관제 스트리밍" />
            <canvas id="aiCanvas" class="ai-canvas-overlay"></canvas>
        </div>
        
        <!-- ⭕ 모든 제어 UI 요소를 좌측으로 정렬하는 하단 컨트롤 랙 -->
        <div class="control-bottom-bar">
            
            <!-- 채널 변경 스위칭 버튼 그룹 -->
            <div class="video-btn-wrapper">
                <button type="button" onclick="switchMode('video_1')" class="btn-change" id="sourceButton_video_1">동영상 1번</button>
                <button type="button" onclick="switchMode('video_2')" class="btn-change" id="sourceButton_video_2">동영상 2번</button>
                <button type="button" onclick="switchMode('video_3')" class="btn-change" id="sourceButton_video_3">동영상 3번</button>
                <button type="button" onclick="switchMode('esp32')" class="btn-change btn-esp" id="sourceButton_esp32">실시간 드론 CAM (ESP32)</button>
            </div>
            
            <!-- 드론 설정 매핑 제어부 -->
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
        </div> <!-- .control-bottom-bar END -->
    </div> <!-- .c2-main-card END -->
</div> <!-- .control-content-wrapper END -->

// =================================================================
// 중요: 기존 핵심 자바스크립트 로직 (100% 무결점 보존)
// =================================================================
<script src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
<script>
 // 현재 브라우저 페이지 세션 안에서 사용할 라우팅 메모리 상태 변수 정의 (기본값: videoFeed 기본 통로)
 let activeLabelUrl = window.location.origin + '${pageContext.request.contextPath}/yolo/labels';
 const esp32VideoUrl = "${flaskEsp32VideoUrl}" || "http://localhost:5000/esp32_yolov12/video_feed";
 
 // 채널 변경 시 버튼의 active 스타일 동기화를 결합한 switchMode 함수
 const switchMode = (modeKey) => {
     const video = document.getElementById('droneVideo');
     video.src = ""; // 좀비 세션 방어선
     
     // 디자인적 직관성을 위한 액티브 클래스 스왑 토글
     $(".btn-change").removeClass("active-drone");
     $("#sourceButton_" + modeKey).addClass("active-drone");
 
     if (modeKey === 'esp32') {
         // 1. 자바 백엔드에 모드 변경 신호를 보냅니다.
         fetch("${pageContext.request.contextPath}/yolo/changeVideo/esp32")
         .then(res => {
             console.log("✈ [자바 통지 성공] ESP32 모드 전환 완료");
             setTimeout(() => {
                 // 2. 7일 버전의 무결점 하이브리드 워프 가동 (Flask 다이렉트 주소 주입)
                 video.src = esp32VideoUrl;
                 // 3. 7일 버전의 ESP32 전용 라벨 배관 완벽 복구
                 activeLabelUrl = window.location.origin + '${pageContext.request.contextPath}/yolo/espLabels';
             }, 80);
         })
         .catch(err => console.error("ESP32 모드 전환 신호 실패:", err));
 
     } else {
         // 1. 자바 백엔드에 동영상 모드 변경 신호를 '먼저' 확실하게 보냅니다.
         fetch("${pageContext.request.contextPath}/yolo/changeVideo/" + modeKey)
         .then(res => {
             console.log("✈ [동영상 소스 변경 성공] 타겟: " + modeKey);
             setTimeout(() => {
                 // 2. 원래의 안전한 자바 로컬 피드로 복귀
                 video.src = "${pageContext.request.contextPath}/yolo/videoFeed?t=" + new Date().getTime();
                 // 3. 일반 동영상 라벨 배관 복구
                 activeLabelUrl = window.location.origin + '${pageContext.request.contextPath}/yolo/labels';
             }, 80);
         })
         .catch(err => console.error("소스 변경 통신 실패:", err));
     }
 };

 document.addEventListener('DOMContentLoaded', () => {
     const canvas = document.getElementById('aiCanvas');
     const ctx = canvas.getContext('2d');
     const video = document.getElementById('droneVideo');
     
     const syncCanvasSize = () => {
         if(video.clientWidth > 0 && video.clientHeight > 0) {
             canvas.width = video.clientWidth;
             canvas.height = video.clientHeight;
         }
     };
     video.onload = syncCanvasSize;
     window.addEventListener('resize', syncCanvasSize);
     
     // 오리지널 무결점 라벨링 박스 드로우 시각화 엔진
     const drawBoundingBox = (box) => {
         if (!box || box.length < 6) return; 
 
         let rx = box[0]; 
         let ry = box[1]; 
         let rw = box[2]; 
         let rh = box[3]; 
         let label = box[4]; 
         let score = box[5]; 
         
         // 해상도 왜곡 없는 정밀 픽셀 비율 맵핑
         const wScale = video.clientWidth / (video.naturalWidth || 640);
         const hScale = video.clientHeight / (video.naturalHeight || 640);
         const x = rx * wScale;
         const y = ry * hScale;
         const width = rw * wScale;
         const height = rh * hScale;
         
         // 1. 박스 테두리선 가동
         ctx.strokeStyle = '#00FF00';
         ctx.lineWidth = 3;
         ctx.strokeRect(x, y, width, height);
         
         // 2. 상단 라벨 텍스트 배경 시각화
         ctx.fillStyle = '#00FF00';
         ctx.font = 'bold 14px sans-serif';
         var textStr = label + " (" + (score * 100).toFixed(0) + "%)";
         var textWidth = ctx.measureText(textStr).width;
         ctx.fillRect(x - 1.5, y - 22, textWidth + 10, 22);
         
         // 3. 인덱스 텍스트 각인
         ctx.fillStyle = '#000000';
         ctx.fillText(textStr, x + 3, y - 6);
     };
     
     // [최종 안정화 버전] 플라스크 부활 감지형 관제 레이더 스크립트
     const pollAiRadar = async () => {
         if (canvas.width === 0 || canvas.height === 0) {
             syncCanvasSize();
             setTimeout(pollAiRadar, 500);
             return;
         }
         let delayTime = 60; // 기본 대기 주기 (60ms)
         try {
             // 백엔드 통합 스트림 엔진 주소 찌르기
             const response = await fetch(activeLabelUrl);
 
             if (!response.ok) {
                 delayTime = 3000; // 플라스크가 꺼져있으면 3초 대기
                 ctx.clearRect(0, 0, canvas.width, canvas.height); 
             } else {
                 const data = await response.json();
                 ctx.clearRect(0, 0, canvas.width, canvas.height);
                 // 1. 화면에 초록색 YOLO 바운딩 박스 그리기
                 if (data?.boxes?.length > 0) {
                     data.boxes.forEach(box => drawBoundingBox(box));
                 }
                 // 2. 성공 시에는 대기 시간 60ms 유지
                 delayTime = 60; 
             }
         } catch (error) {
             // 플라스크 엔진 끊김 시 3초 딜레이 부여하여 톰캣 보호
             delayTime = 3000;
             ctx.clearRect(0, 0, canvas.width, canvas.height); 
             console.log(" [관제 레이더 대기] 플라스크 서버 연결 상태를 확인 중입니다...");
         }
         // 가변 스케줄러 재호출
         setTimeout(pollAiRadar, delayTime);
     };
     
     // 최초 1회 레이더 작동 트리거 격발
     pollAiRadar();
 });
</script>

<script>
 // 1. 드론 설정 버튼 클릭 시 팝업 창 슬라이드/페이드 토글
 $('#btnToggleDroneSetting').on('click', function(e) {
     e.stopPropagation(); // 이벤트 버블링 차단
     $('#droneSettingDropdown').fadeToggle(150);
 });
 
 // 2. 드론 설정 팝업창 내부를 클릭했을 때는 닫히지 않도록 버그 스킵 방어
 $('#droneSettingDropdown').on('click', function(e) {
     e.stopPropagation();
 });
 
 // 3. 팝업창 바깥의 검은 화면이나 본문을 아무 데나 누르면 팝업이 자동으로 부드럽게 닫히도록 마스킹
 $(document).on('click', function() {
     $('#droneSettingDropdown').fadeOut(100);
 });

 // [최종 개량 버전] 페이지 최초 로드 시 격발 연동
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
                 // 백엔드가 송신한 변수 key 이름 구조와 정확하게 1:1 디펜스 매핑
                 var drones = res.dbDroneList; 
                 var mappings = res.activeMappings; 
                 
                 // 1. 화면 내 동적 드론 select 콤보박스 순회 구동
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
                         // 만약 이 가이드라인 글씨가 콤보박스에 출력된다면 
                         // 컨트롤러 내부에서 droneService의 getDroneList가 0건을 반환한 것입니다.
                         $el.append('<option value="">등록 드론 없음</option>');
                     }
                 });

                 // 2. 옵션 동적 삽입이 끝난 직후, DB에 매핑되어 있던 실시간 값으로 selected 고정
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

 // 영상 sourceKey는 그대로 유지하고, 운영 화면에 보이는 버튼명만 배정된 드론 ID로 표시합니다.
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

 // HTML의 각 '적용' 버튼이 클릭되었을 때 백엔드로 단건 매핑 데이터를 전송하는 실시간 반영 함수
 function fn_saveDroneMapping(sourceKey) {
     // 1. 버튼에 맵핑된 sourceKey를 조합하여 매칭되는 select 박스 엘리먼트 타겟팅
     var targetSelect = $("#drone_select_" + sourceKey);
     if (targetSelect.length === 0) {
         alert("해당 채널의 설정 요소를 찾을 수 없습니다.");
         return;
     }
     
     // 2. 사용자가 콤보박스에서 최종 선택한 드론 ID 값 가져오기
     var droneId = targetSelect.val();
     if (!droneId) {
         alert("배정할 드론을 선택해 주세요.");
         return;
     }

     // 3. 백엔드 컨트롤러(@RequestParam 서블릿 사양)에 맞춰 POST Form 형태로 전송
     $.ajax({
         url: "${pageContext.request.contextPath}/yolo/updateMapping",
         type: "POST",
         dataType: "json", // 컨트롤러가 리턴하는 JSON({"status":"SUCCESS"}) 포맷 대응
         data: {
             sourceKey: sourceKey,
             droneId: droneId
         },
         success: function(res) {
             // 컨트롤러가 FAIL 응답을 보냈거나 성공했을 때의 분기 처리
             if (res && res.status === "SUCCESS") {
                 alert(" [" + sourceKey + "] 채널에 드론 배정이 완벽하게 적용되었습니다.");
                 // 설정 창을 부드럽게 닫기
                 $('#droneSettingDropdown').fadeOut(100);
                 // 전역 인메모리 캐시 및 화면 컴포넌트 데이터 최신화를 위해 재조회
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
