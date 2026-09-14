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
	height: 80px !important; /* 오라클 표준 헤더 높이 사수 */
	z-index: 1000 !important; /* 메뉴나 본문 영상이 위로 올라오지 못하도록 잠금 */
}

/* 3. [위치 이상 완치 저격선] 유령 보라색 블록을 깨부수고 메뉴바 우측 정위치 고정 */
.control-content-wrapper {
	position: absolute !important;
	top: 80px !important; /* 고정 헤더 높이 80px 바로 아래에서 산뜻하게 시작 */
	left: 250px !important; /* 좌측 메뉴바 너비 250px 바로 오른쪽에 자석 밀착 */
	width: calc(100% - 250px) !important; /* 사이드바를 제외한머지 우측 공간 전체 할당 */
	padding: 20px 30px;
	box-sizing: border-box;
	min-height: calc(100vh - 80px);
	display: flex;
	flex-direction: column;
	align-items: center;
	margin: 0 !important; /* 기존 화면을 무너뜨리던 스페이스 마진 강제 완전 초기화 */
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

	<jsp:include page="/WEB-INF/views/menu.jsp" />
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div class="control-content-wrapper"
		style="position: absolute !important; top: 80px !important; left: 250px !important; width: calc(100% - 250px) !important; margin: 0 !important; padding: 20px 30px; box-sizing: border-box; display: flex; flex-direction: column; align-items: center; z-index: 50 !important;">
		<h2 class="section-title">실시간 유기동물 드론 관제 영상 (YOLOv8)</h2>

		<div class="video-display-box">
			<img id="droneVideo"
				src="${pageContext.request.contextPath}/yolo/videoFeed"
				class="streaming-frame" alt="실시간 드론 관제 AI 분석 스트리밍" />
			<canvas id="aiCanvas" class="ai-canvas-overlay"></canvas>
		</div>

		<div class="video-btn-wrapper">
			<!-- 🌟 [동작 원리 최적화] 복잡한 백엔드 경로 탐색 오류를 차단하기 위해 버튼을 클릭하면 자바스크립트 함수(switchMode)가 즉시 낚아채서 경로를 직통 맵핑하도록 버튼 구조 개량 -->
			<button type="button" onclick="switchMode('video_1')"
				class="btn-change">동영상 1번</button>
			<button type="button" onclick="switchMode('video_2')"
				class="btn-change">동영상 2번</button>
			<button type="button" onclick="switchMode('video_3')"
				class="btn-change">동영상 3번</button>
			<button type="button" onclick="switchMode('esp32')"
				class="btn-change btn-esp">실시간 드론 CAM (ESP32)</button>
		</div>

		<!-- ================================================================ -->
		<!--  [위치 이상 완치] 비디오 박스 상단 자석 고정형 드롭다운 설정 컴포넌트 -->
		<!-- ================================================================ -->
		<div class="drone-dropdown-wrapper"
			style="width: 100%; max-width: 640px; display: flex !important; justify-content: flex-end !important; position: relative !important; /* 상단 헤더로 뚫고 올라가는 현상 원천 차단 */ margin-top: 15px; margin-bottom: 10px; box-sizing: border-box; z-index: 1000 !important;">
			<!-- 토글 트리거 버튼 -->
			<button type="button" id="btnToggleDroneSetting"
				style="background-color: #2c313d; color: #ffffff; border: 1px solid #414858; padding: 6px 14px; border-radius: 5px; cursor: pointer; font-size: 13px; font-weight: 500; transition: background 0.2s;"
				onmouseover="this.style.backgroundColor='#414858'"
				onmouseout="this.style.backgroundColor='#2c313d'">⚙ 드론 설정</button>

			<!-- 클릭 시 아래로 정위치 팝업 처리되는 드롭다운 창 -->
			<div id="droneSettingDropdown"
				style="display: none; position: absolute; top: 35px; right: 0; width: 320px; background-color: #222733; border: 1px solid #2c313d; box-shadow: 0 8px 24px rgba(0, 0, 0, 0.5); border-radius: 8px; padding: 15px; box-sizing: border-box; z-index: 9999 !important;">
				<h4
					style="color: #ffffff; font-size: 13px; margin-top: 0; margin-bottom: 12px; font-weight: 600; border-bottom: 1px solid #3b4252; padding-bottom: 8px;">
					⚙ 채널별 드론 배정 실시간 매핑</h4>

				<div style="display: flex; flex-direction: column; gap: 10px;">
					<!-- 동영상 1번 -->
					<div
						style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 13px;">
						<span style="width: 100px;">동영상 1번</span> <select
							id="drone_select_video_1" class="drone-map-select"
							style="background: #161920; color: #fff; border: 1px solid #414858; padding: 4px; border-radius: 4px; width: 120px; font-size: 12px; cursor: pointer;">
							<!-- DB 데이터가 들어올 공간 (하드코딩 삭제) -->
						</select>
						<button type="button" onclick="fn_saveDroneMapping('video_1')"
							style="background: #007bff; color: #fff; border: none; padding: 4px 8px; border-radius: 4px; cursor: pointer; font-size: 12px;">적용</button>
					</div>
					<!-- 동영상 2번 -->
					<div
						style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 13px;">
						<span style="width: 100px;">동영상 2번</span> <select
							id="drone_select_video_2" class="drone-map-select"
							style="background: #161920; color: #fff; border: 1px solid #414858; padding: 4px; border-radius: 4px; width: 120px; font-size: 12px; cursor: pointer;">
							<!-- DB 데이터가 들어올 공간 (하드코딩 삭제) -->
						</select>
						<button type="button" onclick="fn_saveDroneMapping('video_2')"
							style="background: #007bff; color: #fff; border: none; padding: 4px 8px; border-radius: 4px; cursor: pointer; font-size: 12px;">적용</button>
					</div>
					<!-- 동영상 3번 -->
					<div
						style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 13px;">
						<span style="width: 100px;">동영상 3번</span> <select
							id="drone_select_video_3" class="drone-map-select"
							style="background: #161920; color: #fff; border: 1px solid #414858; padding: 4px; border-radius: 4px; width: 120px; font-size: 12px; cursor: pointer;">
							<!-- DB 데이터가 들어올 공간 (하드코딩 삭제) -->
						</select>
						<button type="button" onclick="fn_saveDroneMapping('video_3')"
							style="background: #007bff; color: #fff; border: none; padding: 4px 8px; border-radius: 4px; cursor: pointer; font-size: 12px;">적용</button>
					</div>
					<!-- 실시간 CAM -->
					<div
						style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 13px;">
						<span style="width: 100px; color: #5ddcff;">실시간 CAM</span> <select
							id="drone_select_esp32" class="drone-map-select"
							style="background: #161920; color: #fff; border: 1px solid #414858; padding: 4px; border-radius: 4px; width: 120px; font-size: 12px; cursor: pointer;">
							<!-- DB 데이터가 들어올 공간 (하드코딩 삭제) -->
						</select>
						<button type="button" onclick="fn_saveDroneMapping('esp32')"
							style="background: #157347; color: #fff; border: none; padding: 4px 8px; border-radius: 4px; cursor: pointer; font-size: 12px;">적용</button>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>

<script
	src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/script.js"></script>

<script>
        // 현재 브라우저 페이지 세션 안에서 사용할 라우팅 메모리 상태 변수 정의 (기본값: videoFeed 기본 통로)
        let activeLabelUrl = window.location.origin + '${pageContext.request.contextPath}/yolo/labels';
        const esp32VideoUrl = "${flaskEsp32VideoUrl}" || "http://localhost:5000/esp32_yolov12/video_feed";

        const switchMode = (modeKey) => {
            const video = document.getElementById('droneVideo');
            video.src = ""; // 좀비 세션 방어선
            
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
	                }
	            },
	            error: function(xhr, status, error) {
	                console.error("❌ 드론 맵 정보 획득 실패 사유: ", error);
	            }
	        });
	    }
	    
	 // [추가] HTML의 각 '적용' 버튼이 클릭되었을 때 백엔드로 단건 매핑 데이터를 전송하는 실시간 반영 함수
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
	                    alert("🎯 [" + sourceKey + "] 채널에 드론 배정이 완벽하게 적용되었습니다.");
	                    
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
</html>
