<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>유기동물 관제 시스템</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/style.css?v='/>">
    <style>
        body { margin: 0; padding: 0; background-color: #161920; overflow-x: hidden; }
        .control-content-wrapper {
            margin-left: 250px; padding: 20px 30px; box-sizing: border-box;
            min-height: calc(100vh - 70px); display: flex; flex-direction: column; align-items: center;
        }
        .section-title { color: #ffffff; font-size: 22px; font-weight: 600; margin-top: 5px; margin-bottom: 20px; }
        .video-display-box { 
            background-color: #000000; padding: 8px; border-radius: 10px; border: 1px solid #2c313d; 
            width: 100%; max-width: 640px; box-sizing: border-box; position: relative;
        }
        .streaming-frame { width: 100%; height: auto; display: block; border-radius: 4px; }
        .ai-canvas-overlay {
            position: absolute; top: 8px; left: 8px;
            width: calc(100% - 16px); height: calc(100% - 16px);
            pointer-events: none; border-radius: 4px; z-index: 10;
        }
        .video-btn-wrapper { margin-top: 15px; display: flex; gap: 10px; }
        .btn-change { display: inline-block; padding: 8px 16px; background-color: #2c313d; color: #fff; text-decoration: none; border-radius: 5px; font-size: 14px; font-weight: 500; transition: background 0.2s; }
        .btn-change:hover { background-color: #414858; }
        .btn-esp { background-color: #157347; } 
        .btn-esp:hover { background-color: #1e7e34; }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/header.jsp" />
    <jsp:include page="/WEB-INF/views/menu.jsp" />
	
    <div class="control-content-wrapper">
        <h2 class="section-title">실시간 유기동물 드론 관제 영상 (YOLOv8)</h2>
        
        <div class="video-display-box">
            <img id="droneVideo" src="${pageContext.request.contextPath}/yolo/videoFeed" class="streaming-frame" alt="실시간 드론 관제 AI 분석 스트리밍" />
            <canvas id="aiCanvas" class="ai-canvas-overlay"></canvas>
        </div>
        
        <div class="video-btn-wrapper">
            <!-- 🌟 [동작 원리 최적화] 복잡한 백엔드 경로 탐색 오류를 차단하기 위해 버튼을 클릭하면 자바스크립트 함수(switchMode)가 즉시 낚아채서 경로를 직통 맵핑하도록 버튼 구조 개량 -->
            <button type="button" onclick="switchMode('video_1')" class="btn-change">동영상 1번</button> 
            <button type="button" onclick="switchMode('video_2')" class="btn-change">동영상 2번</button> 
            <button type="button" onclick="switchMode('video_3')" class="btn-change">동영상 3번</button>
            <button type="button" onclick="switchMode('esp32')" class="btn-change btn-esp">실시간 드론 CAM (ESP32)</button>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
    
    <script>
        // 현재 브라우저 페이지 세션 안에서 사용할 라우팅 메모리 상태 변수 정의 (기본값: videoFeed 기본 통로)
        let activeLabelUrl = window.location.origin + '${pageContext.request.contextPath}/yolo/labels';

        // 🌟 [최종 하이브리드 네이티브 스위칭 엔진]
        // 버튼을 누르면 자바 서버의 지연 타임아웃을 거치지 않고 프론트엔드가 즉시 다이렉트 스트리밍 주소로 강제 워프시킵니다.
		        // 🌟 [최종 하이브리드 네이티브 스위칭 엔진 - 레이스 컨디션 버그 완치 버전]
                // 🌟 [하이브리드 네이티브 스위칭 엔진 - 부드러운 전환 + 싱크 버그 완치 버전]
        const switchMode = (modeKey) => {
            const video = document.getElementById('droneVideo');
            
            if (modeKey === 'esp32') {
                // 1. 자바 백엔드에 모드 변경 신호를 보냅니다.
                fetch("${pageContext.request.contextPath}/yolo/changeVideo/esp32")
                    .then(res => {
                        console.log(" [자바 통지 성공] ESP32 모드 전환 완료");
                        // 2. 화면을 끄지 않고 부드럽게 Flask 주소로 워프시킵니다.
                        video.src = "http://localhost:5000/esp32_yolov12/video_feed";
                        activeLabelUrl = window.location.origin + '${pageContext.request.contextPath}/yolo/espLabels';
                    })
                    .catch(err => console.error("ESP32 모드 전환 신호 실패:", err));
                    
            } else {
                // 1. 자바 백엔드에 동영상 모드 변경 신호를 '먼저' 확실하게 보냅니다.
                fetch("${pageContext.request.contextPath}/yolo/changeVideo/" + modeKey)
                    .then(res => {
                        console.log(" [동영상 소스 변경 성공] 타겟: " + modeKey);
                        // 2. 자바 서버가 모드를 local로 인지한 직후, 화면 끊김 없이 곧바로 동영상 피드를 부드럽게 이어 붙입니다.
                        video.src = "${pageContext.request.contextPath}/yolo/videoFeed?t=" + new Date().getTime();
                        activeLabelUrl = window.location.origin + '${pageContext.request.contextPath}/yolo/labels';
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

            // 실시간 60ms 간격 AI 레이더 데이터 동적 폴링 가동
            setInterval(async () => {
                if (canvas.width === 0 || canvas.height === 0) {
                    syncCanvasSize();
                    return;
                }

                try {
                    // 동적으로 변경되는 activeLabelUrl 변수 주소를 찔러 다중 수집 처리
                    const response = await fetch(activeLabelUrl);
                    if (!response.ok) return;
                    
                    const data = await response.json();
                    ctx.clearRect(0, 0, canvas.width, canvas.height);

                    if (data?.boxes?.length > 0) {
                        data.boxes.forEach(box => drawBoundingBox(box));
                    }
                } catch (error) {
                    console.error("좌표 갱신 실패:", error);
                }
            }, 60); 
        });
    </script>
</body>
</html>
