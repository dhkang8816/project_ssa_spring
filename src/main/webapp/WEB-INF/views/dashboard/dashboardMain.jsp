<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>지능형 유기동물 관제 대시보드</title>

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<!-- 관제 아이콘 팩 연동 -->
<link rel="stylesheet" href="https://cloudflare.com">

<style>
body {
	background-color: #161920;
	color: #ffffff;
	font-family: 'Pretendard', -apple-system, sans-serif;
	margin: 0;
	padding: 0;
}

.dashboard-container {
	width: auto !important;
	margin: 100px 20px 32px 282px !important;
	box-sizing: border-box !important;
	padding: 0 !important;
}

@media ( max-width : 760px) {
	.dashboard-container {
		margin: 84px 16px 20px 230px !important;
	}
}

.header-title {
	font-size: 24px;
	font-weight: 600;
	margin-bottom: 20px;
	color: #5ddcff;
	display: flex;
	align-items: center;
	gap: 10px;
}
/* 💡 [신규 추가 1] 상단 4개 인포 카드가 반응형으로 유연하게 줄어들도록 조절 */
#aiBriefingContent>div[style*="display: grid"] {
	grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)) !important;
}

/* 💡 [신규 추가 2] 하단 2개 그래프 룸이 화면 크기에 맞춰 아래로 떨어지거나 유연하게 변하도록 조절 */
#dashboardGraphZone>div[style*="display: grid"] {
	grid-template-columns: repeat(auto-fit, minmax(380px, 1fr)) !important;
}
/* 그래프를 감싸는 룸(좌측/우측 그래프룸)에 크기 유연성 부여 */
#dashboardGraphZone>div>div {
	min-width: 0 !important; /* 💡 그리드 아이템의 최소 너비 제한을 풀어 캔버스가 줄어들 수 있게 만듦 */
	position: relative;
	width: 100%;
}

/* 캔버스 태그 자체의 절대적 너비 고정 파괴 */
#dashboardGraphZone canvas {
	width: 100% !important;
	height: 100% !important;
}

/* ================================================================ */
/*  [AI 브리핑 전용 레이아웃 테마 패키지 스타일] */
/* ================================================================ --> */
.ai-briefing-panel {
	background: linear-gradient(135deg, #222733 0%, #1a1e29 100%);
	border: 1px solid #2c313d;
	border-radius: 12px;
	padding: 25px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
	margin-bottom: 30px;
	position: relative;
	overflow: hidden;
}

.ai-briefing-panel::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	width: 4px;
	height: 100%;
	background-color: #007bff;
}

.panel-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 15px;
	border-bottom: 1px solid #2c313d;
	padding-bottom: 12px;
}

.panel-title {
	font-size: 16px;
	font-weight: 600;
	color: #ffffff;
	display: flex;
	align-items: center;
	gap: 8px;
}

.panel-title i {
	color: #007bff;
	animation: pulse 2s infinite;
}

.btn-refresh-ai {
	background-color: #2c313d;
	color: #ffffff;
	border: 1px solid #414858;
	padding: 6px 14px;
	border-radius: 6px;
	cursor: pointer;
	font-size: 13px;
	font-weight: 500;
	display: flex;
	align-items: center;
	gap: 6px;
	transition: all 0.2s;
}

.btn-refresh-ai:hover {
	background-color: #414858;
	border-color: #007bff;
}

.ai-content-box {
	font-size: 14px;
	line-height: 1.7;
	color: #e1e4ea;
	min-height: 80px;
	display: flex;
	align-items: center;
}
/* 로딩 애니메이션 기어 */
.ai-loading {
	color: #aaa;
	display: flex;
	align-items: center;
	gap: 10px;
	font-size: 14px;
	width: 100%;
	justify-content: center;
	padding: 20px 0;
}

.ai-loading i {
	font-size: 20px;
	animation: spin 1s infinite linear;
}

@
keyframes spin { 0% {
	transform: rotate(0deg);
}

100
%
{
transform
:
rotate(
360deg
);
}
}
@
keyframes pulse { 0% {
	transform: scale(1);
	opacity: 1;
}

50
%
{
transform
:
scale(
1.1
);
opacity
:
0.7;
}
100
%
{
transform
:
scale(
1
);
opacity
:
1;
}
}
@page {
	size: A4;
	margin: 12mm;
}

@media print {
	body {
		background: #ffffff !important;
		color: #000000 !important;
		padding: 0;
	}
	body>:not(.dashboard-container), .no-print {
		display: none !important;
	}
	.dashboard-container, .dashboard-container div {
		background: #ffffff !important;
		color: #000000 !important;
		box-shadow: none !important;
	}
	.dashboard-container {
		width: auto !important;
		margin: 0 !important;
		padding: 0 !important;
	}
	.dashboard-container * {
		color: #000000 !important;
	}
	#dashboardGraphZone>div>div {
		break-inside: avoid;
	}
	.dashboard-container .print-chart-card, .dashboard-container .print-chart-card div
		{
		background: #222733 !important;
		color: #ffffff !important;
		-webkit-print-color-adjust: exact;
		print-color-adjust: exact;
	}
	.dashboard-container .print-chart-card * {
		color: #ffffff !important;
	}
	canvas {
		max-width: 100% !important;
	}
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/menu.jsp" />
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div class="dashboard-container">
		<!-- 변경 전 구역 (JSP 3~4페이지): 기존 샌드박스 박스를 아래 코드로 완전 대체하세요 -->
		<div class="ai-briefing-panel">
			<div class="panel-header">
				<div class="panel-title">
					<i class="fa-solid fa-robot"></i> 실시간 통합 관제 시스템 통계 수치 지표
				</div>
				<div class="d-flex gap-2 no-print">
					<button type="button" class="btn-refresh-ai"
						onclick="fn_fetchAiBriefing()">
						<i class="fa-solid fa-arrows-rotate"></i> 분석 동기화
					</button>
					<button type="button" class="btn-refresh-ai"
						onclick="window.print();">인쇄</button>
				</div>
			</div>

			<!-- [블록 1] 오직 상단 일반 표시 카드 4개만 순수하게 가로로 담아낼 상자 -->
			<div id="aiBriefingContent" class="ai-content-box">
				<div class="ai-loading">
					<i class="fa-solid fa-gear"></i> 오라클 통합 로그 데이터 집계 엔진 가동 중...
				</div>
			</div>

			<!-- [블록 2] 질문자님 의견 반영: 그래프 블럭을 완전히 따로 파서 아래로 내린 독립형 공간 -->
			<div id="dashboardGraphZone"
				style="width: 100%; margin-top: 25px; display: none;">
				<div
					style="width: 100%; display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
					<!-- 좌측 그래프룸 -->
					<div class="print-chart-card"
						style="background: #222733; padding: 20px; border-radius: 8px; border: 1px solid #2c313d;">
						<div
							style="font-size: 14px; color: #ffffff; font-weight: 600; margin-bottom: 15px;">
							<i class="fa-solid fa-calendar-days"
								style="color: #5ddcff; margin-right: 6px;"></i> 최근 7일간 일별 트렌드
						</div>
						<div style="position: relative; width: 100%; height: 250px;">
							<canvas id="trendChart"></canvas>
						</div>
					</div>
					<!-- 우측 그래프룸 -->
					<div class="print-chart-card"
						style="background: #222733; padding: 20px; border-radius: 8px; border: 1px solid #2c313d;">
						<div
							style="font-size: 14px; color: #ffffff; font-weight: 600; margin-bottom: 15px;">
							<i class="fa-solid fa-clock"
								style="color: #ffae19; margin-right: 6px;"></i> 실시간 당일 시간대별 통계
						</div>
						<div style="position: relative; width: 100%; height: 250px;">
							<canvas id="timeChart"></canvas>
						</div>
					</div>
				</div>
			</div>

			<!-- [블록 3] 축종별 / 이상객체별 분포 차트 공간 (기존 그래프존 바로 아래 추가 또는 내부에 배치) -->
			<div
				style="width: 100%; display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 25px;">

				<!-- 좌측: 축종별 미달 경보 비율 -->
				<div class="print-chart-card"
					style="background: #222733; padding: 20px; border-radius: 8px; border: 1px solid #2c313d; min-width: 0;">
					<div
						style="font-size: 14px; color: #ffffff; font-weight: 600; margin-bottom: 15px;">
						<i class="fa-solid fa-dog"
							style="color: #2ecc71; margin-right: 6px;"></i> 축종별 경보 발생 분포
					</div>
					<div style="position: relative; width: 100%; height: 250px;">
						<canvas id="animalChart"></canvas>
					</div>
				</div>

				<!-- 우측: 이상객체 종류별 포착 현황 -->
				<div class="print-chart-card"
					style="background: #222733; padding: 20px; border-radius: 8px; border: 1px solid #2c313d; min-width: 0;">
					<div
						style="font-size: 14px; color: #ffffff; font-weight: 600; margin-bottom: 15px;">
						<i class="fa-solid fa-skull-crossbones"
							style="color: #e74c3c; margin-right: 6px;"></i> 이상객체 유형별 포착 통계
					</div>
					<div style="position: relative; width: 100%; height: 250px;">
						<canvas id="dangerTypeChart"></canvas>
					</div>
				</div>

			</div>
		</div>


	</div>

</body>

<script>
	// 화면 로딩이 끝나면 지체 없이 제미나이 특공대 출격 격발
	$(document).ready(function() {
		fn_fetchAiBriefing();
	});

	function fn_fetchAiBriefing() {
		var $contentBox = $("#aiBriefingContent");

		// 1. 재조회 대비 화면 백화 및 기어 회전 마스크 기동
		$contentBox
				.html('<div class="ai-loading">'
						+ '    <i class="fa-solid fa-gear"></i> 오라클 통합 수치 집계 및 Gemini AI 상황 분석 분석 중...'
						+ '</div>');

		// 2. DashboardController 독립 전용 관문 비동기 호출 타격
		$
				.ajax({
					url : "${pageContext.request.contextPath}/dashboard/api/ai-briefing",
					type : "GET",
					dataType : "json",
					success : function(res) {
						console.log("✈ [오라클 관제 데이터 수신 완료]:", res);
						try {
							// 데이터 누락을 대비한 기본 안전 처리
							var danger = (res.dangerCount !== undefined && res.dangerCount !== null) ? res.dangerCount
									: 0;
							var detect = (res.detectionCount !== undefined && res.detectionCount !== null) ? res.detectionCount
									: 0;
							var hours = (res.flightHours !== undefined && res.flightHours !== null) ? res.flightHours
									: 0.0;
							var todayDetect = (res.todayDetectCount !== undefined && res.todayDetectCount !== null) ? res.todayDetectCount
									: 0;
							var completeRate = (res.actionCompleteRate !== undefined && res.actionCompleteRate !== null) ? res.actionCompleteRate
									: 0.0;
							var score = (res.safetyScore !== undefined && res.safetyScore !== null) ? res.safetyScore
									: 0;

							var statusText = "안전";
							var statusColor = "#2ecc71";

							if (score >= 70) {
								statusText = "심각 (출동)";
								statusColor = "#e74c3c";
							} else if (score >= 40) {
								statusText = "주의 (감시)";
								statusColor = "#f1c40f";
							} else {
								statusText = "안전";
								statusColor = "#2ecc71";
							}

							// B. [수정 핵심] 신규 지표를 포함하여 가로 5열(repeat(5, 1fr)) 반응형 그리드로 확장 조립
							var cardHtml = '<div style="width:100%; display:grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap:15px; text-align:center; padding:10px 0;">'
									+

									// 카드 1: 종합 위험도 (기존 유지)
									'  <div style="background:#222733; padding:20px; border-radius:8px; border:1px solid #2c313d; border-top:4px solid ' + statusColor + ';">'
									+ '    <div style="font-size:12px; color:#aaa; margin-bottom:8px;">관제구역 종합 위험도</div>'
									+ '    <div style="font-size:18px; font-weight:bold; color:' + statusColor + ';">'
									+ score
									+ '점 ['
									+ statusText
									+ ']</div>'
									+ '  </div>'
									+

									// 카드 2: 당일 탐지 총 건수 (🔥 신규 지표 배치)
									'  <div style="background:#222733; padding:20px; border-radius:8px; border:1px solid #2c313d; border-top:4px solid #5ddcff;">'
									+ '    <div style="font-size:12px; color:#aaa; margin-bottom:8px;">당일 탐지 총 건수</div>'
									+ '    <div style="font-size:24px; font-weight:bold; color:#5ddcff;">'
									+ todayDetect
									+ ' 건</div>'
									+ '  </div>'
									+

									// 카드 3: 당일 조치 완료율 (🔥 신규 지표 배치)
									'  <div style="background:#222733; padding:20px; border-radius:8px; border:1px solid #2c313d; border-top:4px solid #2ecc71;">'
									+ '    <div style="font-size:12px; color:#aaa; margin-bottom:8px;">당일 현장조치 완료율</div>'
									+ '    <div style="font-size:24px; font-weight:bold; color:#2ecc71;">'
									+ completeRate
									+ ' %</div>'
									+ '  </div>'
									+

									// 카드 4: 드론 종합 누적 비행시간 (기존 유지, 텍스트 가시성 보정)
									'  <div style="background:#222733; padding:20px; border-radius:8px; border:1px solid #2c313d; border-top:4px solid #3498db;">'
									+ '    <div style="font-size:12px; color:#aaa; margin-bottom:8px;">당일 드론 총 비행시간</div>'
									+ '    <div style="font-size:24px; font-weight:bold; color:#ffffff;">'
									+ hours
									+ ' 시간</div>'
									+ '  </div>'
									+

									// 카드 5: 위험 이상객체 포착 풀 (기존 유지)
									'  <div style="background:#222733; padding:20px; border-radius:8px; border:1px solid #2c313d; border-top:4px solid #e74c3c;">'
									+ '    <div style="font-size:12px; color:#aaa; margin-bottom:8px;">누적 위험객체 포착</div>'
									+ '    <div style="font-size:24px; font-weight:bold; color:#ffffff;">'
									+ danger
									+ ' 회</div>'
									+ '  </div>'
									+

									// 카드 6: 마리수 기준 미달 경보 풀 (기존 유지)
									'  <div style="background:#222733; padding:20px; border-radius:8px; border:1px solid #2c313d; border-top:4px solid #f1c40f;">'
									+ '    <div style="font-size:12px; color:#aaa; margin-bottom:8px;">누적 미달경보 발생</div>'
									+ '    <div style="font-size:24px; font-weight:bold; color:#ffffff;">'
									+ detect + ' 건</div>' + '  </div>' +

									'</div>';

							// 상단 컨테이너 영역에 완성된 카드 주입
							$("#aiBriefingContent").html(cardHtml);

							// [이후 하단 차트 렌더링 코드는 기존 그대로 유지하면 됩니다]
							$("#dashboardGraphZone").show();

							// [행동 3-1] 차트 인스턴스 초기화 및 재생성 (꺾은선 그래프)
							var ctxTrend = document
									.getElementById('trendChart').getContext(
											'2d');
							if (window.myTrendChart)
								window.myTrendChart.destroy(); // 기존 차트 객체 제거로 버그 방지
							window.myTrendChart = new Chart(
									ctxTrend,
									{
										type : 'line',
										data : {
											labels : res.dateLabels,
											datasets : [
													{
														label : '위험객체 (회)',
														data : res.dangerWeeklyData,
														borderColor : '#e74c3c',
														backgroundColor : 'rgba(231, 76, 60, 0.05)',
														borderWidth : 2,
														tension : 0.3,
														fill : true
													},
													{
														label : '미달경보 (건)',
														data : res.detectWeeklyData,
														borderColor : '#f1c40f',
														backgroundColor : 'rgba(241, 196, 15, 0.05)',
														borderWidth : 2,
														tension : 0.3,
														fill : true
													} ]
										},
										options : {
											responsive : true,
											maintainAspectRatio : false,
											resizeDelay : 50, // 👈 렌더링 엇박자 방지 방어선 추가
											plugins : {
												legend : {
													labels : {
														color : '#fff',
														font : {
															size : 10
														}
													}
												}
											},
											scales : {
												x : {
													grid : {
														color : '#2c313d'
													},
													ticks : {
														color : '#aaa',
														font : {
															size : 10
														}
													}
												},
												y : {
													grid : {
														color : '#2c313d'
													},
													ticks : {
														color : '#aaa',
														font : {
															size : 10
														}
													},
													beginAtZero : true
												}
											// 🎯 Y축 자동 스케일링 활성화
											}
										}

									});

							// [행동 3-2] 시간대별 막대 차트
							var ctxTime = document.getElementById('timeChart')
									.getContext('2d');
							if (window.myTimeChart)
								window.myTimeChart.destroy();
							window.myTimeChart = new Chart(ctxTime, {
								type : 'bar',
								data : {
									labels : res.timeLabels,
									datasets : [ {
										label : '위험객체 (회)',
										data : res.dangerTimeData,
										backgroundColor : '#e74c3c',
										borderRadius : 4
									}, {
										label : '미달경보 (건)',
										data : res.detectTimeData,
										backgroundColor : '#f1c40f',
										borderRadius : 4
									} ]
								},
								options : {
									responsive : true,
									maintainAspectRatio : false,
									resizeDelay : 50,
									plugins : {
										legend : {
											display : false
										}
									},
									scales : {
										x : {
											grid : {
												color : '#2c313d'
											},
											ticks : {
												color : '#aaa',
												font : {
													size : 10
												}
											}
										},
										y : {
											grid : {
												color : '#2c313d'
											},
											ticks : {
												color : '#aaa',
												font : {
													size : 10
												}
											},
											beginAtZero : true
										}
									// 🎯 Y축 자동 스케일링 활성화
									}
								}

							});

							// [행동 3-3] 축종별 도넛 차트
							var ctxAnimal = document.getElementById(
									'animalChart').getContext('2d');
							if (window.myAnimalChart)
								window.myAnimalChart.destroy();
							window.myAnimalChart = new Chart(ctxAnimal, {
								type : 'doughnut',
								data : {
									labels : res.animalLabels,
									datasets : [ {
										data : res.animalData,
										backgroundColor : [ '#2980b9',
												'#ecf0f1' ],
										borderWidth : 0
									} ]
								},
								options : {
									responsive : true,
									maintainAspectRatio : false,
									resizeDelay : 50,
									plugins : {
										legend : {
											position : 'right',
											labels : {
												color : '#ffffff'
											}
										}
									}
								}
							});

							// [행동 3-4] 이상객체 유형별 가로 막대 차트
							var ctxDangerType = document.getElementById(
									'dangerTypeChart').getContext('2d');
							if (window.myDangerTypeChart)
								window.myDangerTypeChart.destroy();
							window.myDangerTypeChart = new Chart(ctxDangerType,
									{
										type : 'bar',
										data : {
											labels : res.dangerTypeLabels,
											datasets : [ {
												label : '포착 횟수',
												data : res.dangerTypeData,
												backgroundColor : [ '#3498db',
														'#e67e22', '#9b59b6',
														'#e74c3c' ],
												borderRadius : 4
											} ]
										},
										options : {
											indexAxis : 'y',
											responsive : true,
											maintainAspectRatio : false,
											resizeDelay : 50,
											plugins : {
												legend : {
													display : false
												}
											},
											scales : {
												x : {
													grid : {
														color : '#2c313d'
													},
													ticks : {
														color : '#aaa'
													},
													beginAtZero : true
												},
												y : {
													grid : {
														display : false
													},
													ticks : {
														color : '#ffffff'
													}
												}
											}
										}
									});

						} catch (parseError) {
							console.error("화면 시각화 매핑 에러:", parseError);
							$("#aiBriefingContent")
									.html(
											'<div style="color:#ff6b6b;">❌ 데이터 멀티 시각화 블록 분리 연동 중 오류가 발생했습니다.</div>');
						}
					}

				});
	}
</script>
</html>
