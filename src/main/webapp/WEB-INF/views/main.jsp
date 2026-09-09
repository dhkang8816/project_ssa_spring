<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>유기동물 관제 시스템</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/style.css?v='/>">
    <style>
        /* 1. 글로벌 바디 및 가로 스크롤 누수 차단 */
        body { 
            margin: 0; 
            padding: 0; 
            background-color: #161920; 
            overflow-x: hidden; 
        }
        
        /* 2. 상단 헤더 화면 최상단 레이어 자석 고정 (메뉴 잘림 현상 원천 차단) */
        header, .top-header {
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            width: 100% !important;
            height: 80px !important;    /* 오라클 표준 헤더 높이 사수 */
            z-index: 1000 !important;   /* 메뉴나 본문 영상이 위로 올라오지 못하도록 잠금 */
        }

        /* 3. [위치 이상 완치 저격선] 유령 보라색 블록을 깨부수고 메뉴바 우측 정위치 고정 */
        .control-content-wrapper {
            position: absolute !important;
            top: 80px !important;        /* 고정 헤더 높이 80px 바로 아래에서 산뜻하게 시작 */
            left: 250px !important;      /* 좌측 메뉴바 너비 250px 바로 오른쪽에 자석 밀착 */
            width: calc(100% - 250px) !important; /* 사이드바를 제외한머지 우측 공간 전체 할당 */
            padding: 20px 30px; 
            box-sizing: border-box;
            min-height: calc(100vh - 80px); 
            display: flex; 
            flex-direction: column; 
            align-items: center;
            margin: 0 !important;        /* 기존 화면을 무너뜨리던 스페이스 마진 강제 완전 초기화 */
            z-index: 50 !important;
        }

        /* 4. 관제 메인 타이틀 폰트 규격 */
        .section-title { 
            color: #ffffff; 
            font-size: 22px; 
            font-weight: 600; 
            margin-top: 5px; 
            margin-bottom: 20px; 
        }

        /* 5. 블랙 비디오 프레임 디스플레이 상자 */
        .video-display-box { 
            background-color: #000000; 
            padding: 8px; 
            border-radius: 10px; 
            border: 1px solid #2c313d; 
            width: 100%; 
            max-width: 640px; 
            box-sizing: border-box; 
            position: relative;
        }

        /* 6. YOLOv8 바이너리 스트리밍 비디오 피드 태그 */
        .streaming-frame { 
            width: 100%; 
            height: auto; 
            display: block; 
            border-radius: 4px; 
        }

        /* 7. 투명 도화지 카운터 캔버스 오버레이 레이어 */
        .ai-canvas-overlay {
            position: absolute; 
            top: 8px; 
            left: 8px;
            width: calc(100% - 16px); 
            height: calc(100% - 16px);
            pointer-events: none; 
            border-radius: 4px; 
            z-index: 10;
        }

        /* 8. 멀티 채널 변환 하단 버튼 정렬 박스 */
        .video-btn-wrapper { 
            margin-top: 15px; 
            display: flex; 
            gap: 10px; 
        }

        /* 9. 동영상 1, 2, 3번 스위칭 기본 버튼 양식 */
        .btn-change { 
            display: inline-block; 
            padding: 8px 16px; 
            background-color: #2c313d; 
            color: #fff; 
            text-decoration: none; 
            border-radius: 5px; 
            font-size: 14px; 
            font-weight: 500; 
            transition: background 0.2s; 
            border: none;
            cursor: pointer;
        }
        
        .btn-change:hover { 
            background-color: #414858; 
        }

        /* 10. 실시간 드론 CAM (ESP32) 전용 녹색 강조 버튼 양식 */
        .btn-esp { 
            background-color: #157347; 
        } 
        
        .btn-esp:hover { 
            background-color: #1e7e34; 
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/header.jsp" />
    <jsp:include page="/WEB-INF/views/menu.jsp" />
	
    <div class="control-content-wrapper" style="position: absolute !important; top: 80px !important; left: 250px !important; width: calc(100% - 250px) !important; margin: 0 !important; padding: 20px 30px; box-sizing: border-box; display: flex; flex-direction: column; align-items: center; z-index: 50 !important;">
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

     // 🌟 [최종 완치 마스터 저격선] 윈도우 OS 소켓 좀비 락을 완전히 무력화시키는 단선 스위칭 엔진
        const switchMode = (modeKey) => {
            const video = document.getElementById('droneVideo');
            
            // 1. 영상 통로를 명시적으로 즉시 비워 자바/파이썬에 걸려있던 좀비 세션을 원천 차단합니다.
            video.src = ""; 
            
            // 2. 자바 백엔드에 모드 변경 명령을 전송하여 타이머와 캐시를 정비합니다.
            fetch("${pageContext.request.contextPath}/yolo/changeVideo/" + modeKey)
            .then(res => {
                console.log("✈ [채널 스위칭 통지 완수] 모드 키: " + modeKey);
                
                // 3. 찰나의 시간(50ms) 버퍼를 준 뒤, 주소 배관망을 완벽하게 분리하여 매핑합니다.
                setTimeout(() => {
                    if (modeKey === 'esp32') {
                        // 🌟 사용자가 ESP32 버튼을 누르면 플라스크 내부의 독립 개설된 esp32 직통 스트림관을 찌릅니다.
                        video.src = "http://localhost:5000/esp32_yolov12/video_feed";
                        activeLabelUrl = window.location.origin + '${pageContext.request.contextPath}/yolo/labels?t=' + new Date().getTime();
                    } else {
                        // 🌟 사용자가 일반 동영상(video_1,2,3)을 누르면 원래의 무결점 자바videoFeed 엔드포인트로 복귀합니다!
                        // 주소 배관이 완전히 분리되어 파이썬이 백그라운드에서 -138을 찾고 있더라도 
                        // 동영상 화면은 지연 시간 0ms 만에 즉각 살아나며 칼싱크 귀환에 성공합니다.
                        video.src = "${pageContext.request.contextPath}/yolo/videoFeed?t=" + new Date().getTime();
                        activeLabelUrl = window.location.origin + '${pageContext.request.contextPath}/yolo/labels?t=' + new Date().getTime();
                    }
                }, 50);
            })
            .catch(err => console.error("❌ 채널 스위칭 통신 실패:", err));
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

            // 🛠️ [최종 안정화 버전] 플라스크 부활 감지형 관제 레이더 스크립트
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
                    console.log("🔌 [관제 레이더 대기] 플라스크 서버 연결 상태를 확인 중입니다...");
                }

                // 가변 스케줄러 재호출
                setTimeout(pollAiRadar, delayTime);
            };

            // 최초 1회 트리거 발동
            pollAiRadar();
        });
    </script>

    
    <script>
		// 알림이 도착했을 때 동적으로 HTML 리스트를 밀어 넣는 공통 함수
	    function appendRealtimeAlarm(message) {
	        // '알림이 없습니다' 문구가 있으면 먼저 지우기
	        $('.empty-alarm-msg').remove();
	        
	        // 현재 시각 가져오기
	        let now = new Date();
	        let timeStr = now.getHours() + ':' + String(now.getMinutes()).padStart(2, '0');
	
	        // 최신 알림 디자인 생성
	        let newAlarmHtml = '<li style="padding: 12px 15px; border-bottom: 1px solid #f5f5f5; line-height: 1.4; background-color: #fffafb;">'
	                         + '  <div>' + message + '</div>'
	                         + '  <div style="font-size: 11px; color: #aaa; margin-top: 4px; text-align: right;">' + timeStr + '</div>'
	                         + '</li>';
	                         
	        // 알림 리스트 최상단(맨 위)에 새로운 알림 꼽아 넣기
	        $('.alarm-list-content').prepend(newAlarmHtml);
	        
	        // 🔔 헤더 종 흔들기 및 배지 카운트 올리기 트리거
	        $('#alarmBellIcon').addClass('fa-shake').css('color', '#ff4d4d');
	        let currentCount = parseInt($('.alarm-count-badge').text()) || 0;
	        $('.alarm-count-badge').text(currentCount + 1).show();
	    }

    </script>
</body>
</html>
