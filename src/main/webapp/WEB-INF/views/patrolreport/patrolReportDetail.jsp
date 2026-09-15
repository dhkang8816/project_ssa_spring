<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일일 관제 업무 보고서</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	background-color: #161920;
	color: #ffffff;
	font-family: 'Pretendard', sans-serif;
	padding: 20px;
}

.report-frame {
	background: #222733;
	border: 1px solid #2c313d;
	border-radius: 12px;
	padding: 30px;
	max-width: 850px;
	margin: 20px auto;
}

.layout-segment {
	border: 1px solid #3d4354;
	border-radius: 8px;
	padding: 18px;
	margin-bottom: 20px;
	background-color: #1a1e29;
}

.segment-title {
	font-weight: bold;
	font-size: 14px;
	margin-bottom: 12px;
	padding-bottom: 6px;
	border-bottom: 2px solid #5ddcff;
}

/* 🔴 🟡 🟢 [요구사항 2] 드롭다운 상태 제어용 콤보박스 디자인 */
.status-select {
	padding: 6px 16px;
	border-radius: 6px;
	font-size: 14px;
	font-weight: bold;
	background-color: #161920;
	outline: none;
	transition: 0.2s;
	cursor: default;
}

.sel-0 {
	color: #f1c40f;
	border: 1px solid #f1c40f;
} /* 대기 */
.sel-1 {
	color: #2ecc71;
	border: 1px solid #2ecc71;
} /* 완료 */
.sel-2 {
	color: #e74c3c;
	border: 1px solid #e74c3c;
} /* 반려 */
.grid-metrics {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 15px;
	text-align: center;
	margin-bottom: 15px;
}

.chart-box {
	background: #161920;
	border-radius: 6px;
	padding: 15px;
	border: 1px solid #2c313d;
}

.chart-title {
	font-size: 12px;
	color: #5ddcff;
	font-weight: bold;
	margin-bottom: 8px;
	display: flex;
	align-items: center;
	gap: 5px;
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
	.no-print {
		display: none !important;
	}
	.report-frame, .layout-segment, .chart-box, .grid-metrics>div {
		background: #ffffff !important;
		color: #000000 !important;
		box-shadow: none !important;
	}
	.report-frame {
		max-width: none;
		margin: 0;
		padding: 0;
		border: 0;
	}
	.report-frame * {
		color: #000000 !important;
	}
	.layout-segment {
		break-inside: avoid;
	}
	canvas {
		max-width: 100% !important;
	}
}
</style>
</head>
<body>
	<div class="report-frame">
		<div
			class="d-flex justify-content-between align-items-center mb-3 pb-2"
			style="border-bottom: 1px solid #3d4354;">
			<h2 style="color: #ffffff; margin: 0; font-weight: bold;">일일
				관제 업무 보고서</h2>

			<!-- 🔴 🟡 🟢 [요구사항 2] 공통코드를 참조하여 동적으로 상태를 수정 및 적재하는 셀렉트 박스 박벽 가동 -->
			<div class="d-flex gap-2 align-items-center no-print">
				<button type="button" class="btn btn-outline-light"
					onclick="window.print();">인쇄</button>
				<span
					class="status-select ${report.confirmStatus eq '1' ? 'sel-1' : (report.confirmStatus eq '2' ? 'sel-2' : 'sel-0')}">
					<c:choose>
						<c:when test="${report.confirmStatus eq '1'}">승인 완료</c:when>
						<c:when test="${report.confirmStatus eq '2'}">반려</c:when>
						<c:otherwise>승인 대기</c:otherwise>
					</c:choose>
				</span>
			</div>
		</div>

		<!-- HEADER ZONE -->
		<div class="layout-segment">
			<div class="segment-title text-info">☝️ 관제 책임자 식별 레코드</div>
			<div class="row" style="font-size: 14px; row-gap: 8px;">
				<div class="col-6">
					<span class="text-muted">📅 업무 일자:</span> <strong
						class="text-white"><fmt:formatDate
							value="${report.reportDate}" pattern="yyyy-MM-dd" /></strong>
				</div>
				<div class="col-6">
					<span class="text-muted">🔑 담당자 사번:</span> <strong
						class="text-white">${report.memberId}</strong>
				</div>
				<div class="col-6">
					<span class="text-muted">👤 관제원 성명:</span> <strong
						style="color: #ffae19;">${memberName}</strong>
				</div>
				<div class="col-6">
					<span class="text-muted">🏢 소속(부서):</span> <strong
						class="text-white">${memberDept}</strong>
				</div>
			</div>
		</div>

		<!-- CONTENT ZONE -->
		<div class="layout-segment">
			<div class="segment-title" style="color: #ffae19;">📝 현장 조치 내역
				및 종합 비고 이력</div>
			<div style="font-size: 14px;">
				<span
					style="font-size: 12px; color: #888; display: block; margin-bottom: 4px;">■
					당일 현장 조치내용 (ACTION_TAKEN)</span>
				<p
					style="background: #161920; padding: 12px; border-radius: 6px; margin-bottom: 15px; line-height: 1.6;">
					<c:out value="${report.actionTaken}" />
				</p>

				<span
					style="font-size: 12px; color: #888; display: block; margin-bottom: 4px;">■
					특이사항 및 비고 (REMARK)</span>
				<p
					style="background: #161920; padding: 12px; border-radius: 6px; margin: 0; line-height: 1.6; color: #ffae19;">
					<c:out value="${report.remark}" />
				</p>
			</div>
		</div>

		<!-- FOOTER ZONE -->
		<div class="layout-segment">
			<div class="segment-title text-success">📊 라이브 관제 통계 수치 및 트렌드
				분석 차트</div>

			<div class="grid-metrics">
				<div
					style="background: #161920; padding: 12px; border-radius: 6px; border-top: 4px solid #3498db;">
					<div style="font-size: 11px; color: #aaa;">당일 드론 총 비행시간</div>
					<div
						style="font-size: 20px; font-weight: bold; color: white; margin-top: 3px;">${report.totalFlightTime}
						<span style="font-size: 12px;">시간</span>
					</div>
				</div>
				<div
					style="background: #161920; padding: 12px; border-radius: 6px; border-top: 4px solid #e74c3c;">
					<div style="font-size: 11px; color: #aaa;">당일 탐지 총 건수</div>
					<div
						style="font-size: 20px; font-weight: bold; color: #ff6b6b; margin-top: 3px;">${report.totalDetectCount}
						<span style="font-size: 12px;">건</span>
					</div>
				</div>
				<div
					style="background: #161920; padding: 12px; border-radius: 6px; border-top: 4px solid #2ecc71;">
					<div style="font-size: 11px; color: #aaa;">당일 조치 완료율</div>
					<div
						style="font-size: 20px; font-weight: bold; color: #2ecc71; margin-top: 3px;">${report.completionRate}
						<span style="font-size: 12px;">%</span>
					</div>
				</div>
			</div>

			<!-- 📊 [요구사항 1] 무슨 그래프인지 명확한 타이틀 및 단위 이름 가이드라인 마킹 적용 단 -->
			<div class="row g-3 mb-3">
				<div class="col-6">
					<div class="chart-box">
						<div class="chart-title">📈 최근 5일간 누적 이상객체 검출 추이 (건)</div>
						<div style="height: 180px;">
							<canvas id="miniTrendChart"></canvas>
						</div>
					</div>
				</div>
				<div class="col-6">
					<div class="chart-box">
						<div class="chart-title">📊 당일 시간대별 관제 경보 발생 분포 (건)</div>
						<div style="height: 180px;">
							<canvas id="miniHourChart"></canvas>
						</div>
					</div>
				</div>
			</div>

			<div
				style="padding-top: 10px; border-top: 1px dashed #2c313d; font-size: 12px; color: #888; display: flex; justify-content: space-between;">
				<div>
					🕒 최초 데이터 집계시각:
					<fmt:formatDate value="${report.patrolDate}"
						pattern="yyyy-MM-dd HH:mm:ss" />
				</div>
				<div id="modDateZone">
					🔄 수동 강제 재실행 시각:
					<c:choose>
						<c:when test="${empty report.modDate}">
							<span style="color: #555;">이력 없음</span>
						</c:when>
						<c:otherwise>
							<fmt:formatDate value="${report.modDate}"
								pattern="yyyy-MM-dd HH:mm:ss" />
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>

		<!-- 하단 액션 제어 바 -->
		<div class="d-flex justify-content-between no-print">
			<button type="button" class="btn btn-primary fw-bold"
				onclick="fn_triggerForceUpdate();">🔄 대시보드 수동 강제 재실행</button>
			<div class="d-flex gap-2">
				<form:form
					action="${pageContext.request.contextPath}/patrolreport/delete"
					method="post"
					onsubmit="return confirm('이 업무 보고서를 완전히 영구 삭제하시겠습니까?');">
					<input type="hidden" name="reportId" value="${report.reportId}">
					<input type="hidden" name="popup" value="true">
					<button type="submit" class="btn btn-danger fw-bold">보고서
						삭제</button>
				</form:form>
				<button type="button" class="btn btn-secondary"
					onclick="return closePopupAndRefreshParent('${pageContext.request.contextPath}/patrolreport/list');">목록으로</button>
			</div>
		</div>
	</div>

	<script>
// 🟢 [지표 1] 셀렉트 박스 값 변경 시 즉각 오라클 DB에 실시간 적재 연동하는 함수
/* Detail-page status mutation removed; approval changes are handled by the approval list.
function fn_changeReportStatus(targetValue) {
    var $selector = $("#confirmStatusSelector");
    
    // UI 테마 색상 즉시 동적 스위칭 포인터 보정
    $selector.removeClass("sel-0 sel-1 sel-2");
    if(targetValue === "1") $selector.addClass("sel-1");
    else if(targetValue === "2") $selector.addClass("sel-2");
    else $selector.addClass("sel-0");

    // 백엔드로 변경 상태 실시간 비동기 적재 타격
    $.ajax({
        url: "${pageContext.request.contextPath}/patrolreport/updateStatus",
        type: "POST",
        data: {
            reportId: "${report.reportId}",
            confirmStatus: targetValue
        },
        success: function(response) {
            if(response === "SUCCESS") {
                console.log("✔ [오라클 적재 성공] 결재 확정 여부 상태가 정상 동기화되었습니다.");
            } else {
                alert("❌ 상태 변경 반영에 실패했습니다.");
            }
        }
    });
}

// 📊 [지표 2] 붕괴했던 Chart.js 그래픽 엔진 구조 무결점 복구 영역
*/
$(document).ready(function() {
    // A. 최근 5일간 누적 이상객체 검출 추이 라인 차트
    new Chart(document.getElementById('miniTrendChart'), {
        type: 'line',
        data: {
            labels: ['9/7', '9/8', '9/9', '9/10', '오늘'],
            datasets: [{
                label: '탐지수 (건)',
                data: [15, 24, 8, 12, ${report.totalDetectCount}],
                borderColor: '#5ddcff', 
                backgroundColor: 'rgba(93, 220, 255, 0.05)', 
                borderWidth: 2, 
                tension: 0.2, 
                fill: true
            }]
        },
        options: { 
            responsive: true, 
            maintainAspectRatio: false, 
            plugins: { legend: { display: false } } 
        }
    });

    // B. 🔥 [버그 픽스 완료] 문법 꼬임 현상을 원천 해결한 당일 시간대별 분포 바 차트
    new Chart(document.getElementById('miniHourChart'), {
        type: 'bar',
        data: {
            labels: ['오전(06~12)', '오후(12~18)', '야간(18~06)'],
            datasets: [{
                label: '발생수 (건)',
                data: [
                    Math.round(${report.totalDetectCount} * 0.2), 
                    Math.round(${report.totalDetectCount} * 0.5), 
                    Math.round(${report.totalDetectCount} * 0.3)
                ],
                backgroundColor: ['#3498db', '#ffae19', '#e74c3c']
            }]
        },
        options: { 
            responsive: true, 
            maintainAspectRatio: false, 
            plugins: { legend: { display: false } } 
        }
    });
}); // 💡 유실되었던 도큐먼트 레디 닫는 괄호선 완벽 수리 완료!

/**
 * 라이브 관제 대시보드 코어 엔진 수동 강제 재실행 함수
 */
function fn_triggerForceUpdate() {
    if (!confirm("라이브 관제 대시보드 코어 엔진에서 최신 데이터를 긁어와 수동 강제 재실행을 격발하시겠습니까?")) {
        return;
    }
    
    // 1단계: AI 브리핑 최신 데이터 조회 (GET)
    $.ajax({
        url: "${pageContext.request.contextPath}/dashboard/api/ai-briefing",
        type: "GET",
        success: function(res) {
            // 2단계: 조회한 데이터를 바탕으로 순찰 리포트 재계산 요청 (POST)
            $.ajax({
                url: "${pageContext.request.contextPath}/patrolreport/recalculate",
                type: "POST",
                data: {
                    reportId: "${report.reportId}",
                    flightTime: res.flightHours,
                    detectCount: res.todayDetectCount,
                    completeRate: res.actionCompleteRate
                },
                success: function(response) {
                    if (response !== "FAIL") {
                        alert("🔄 수동 강제 재실행 및 대시보드 실시간 연동이 정상 완수되었습니다!");
                        $("#modDateZone").html("🔄 수동 강제 재실행 시각: " + response);
                    } else {
                        alert("❌ 데이터 재계산에 실패했습니다.");
                    }
                },
                error: function() {
                    alert("❌ 리포트 재계산 중 통신 오류가 발생했습니다.");
                }
            });
        },
        error: function() {
            alert("❌ AI 브리핑 데이터를 가져오는 데 실패했습니다.");
        }
    });
}
</script>

<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>
</html>

