<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>헤더</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <style>
        /* 헤더 로그인 정보 가로 정렬 스타일 정의 */
        .user-info-box {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        /* 프로필 이미지에 마우스를 올렸을 때 클릭 가능하다는 표시(손가락) 및 효과 추가 */
        .header-profile-link {
            display: inline-block;
            transition: transform 0.2s ease;
        }
        .header-profile-link:hover {
            transform: scale(1.08); /* 마우스 올리면 살짝 커지는 효과 */
        }
        .header-profile-img {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
            border: 1px solid #ddd;
            cursor: pointer;
        }
        .user-text-info {
            color: #ffffff;
            font-size: 14px;
        }
        /* 폼 버튼을 일반 텍스트 링크처럼 보이게 만드는 스타일 */
        .logout-btn-submit {
            background: none;
            border: none;
            color: #ff4d4d;
            font-weight: bold;
            font-size: 14px;
            cursor: pointer;
            padding: 0;
            margin-left: 8px;
            text-decoration: none;
        }
        .logout-btn-submit:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="main-wrapper">
    <header class="top-header">
        <h1 class="system-title">
            <a href="${pageContext.request.contextPath}/">유기동물 관제시스템</a>
        </h1>

        <!-- 세션 정보를 직접 판별하여 UI를 변경하는 영역 -->
        <div id="util-box">
            
            <%-- 1. 비로그인 상태일 때 --%>
            <c:if test="${empty sessionScope.SPRING_SECURITY_CONTEXT}">
                <a href="${pageContext.request.contextPath}/login">로그인</a>
            </c:if>

           
			<%-- 2. 로그인 완료 상태일 때 --%>
			<c:if test="${not empty sessionScope.SPRING_SECURITY_CONTEXT}">
			    <div class="user-info-box"> <!-- 👑 1. 유저 박스가 여기서 시작됩니다. -->
			    
			        <!-- 내 정보 보기 프로필 이미지 -->
			        <a href="${pageContext.request.contextPath}/member/detail?memberId=${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal}" class="header-profile-link" title="내 정보 보기">
			            <img src="${pageContext.request.contextPath}/resources/images/member/noImage.jpg" class="header-profile-img" alt="프로필">
			        </a>
			        
			        <!-- 사번 텍스트 -->
			        <span class="user-text-info">
			            <strong>${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal}</strong>님 로그인 중
			        </span>
			        
			        <!-- 안전한 POST 로그아웃 폼 -->
			        <form:form action="${pageContext.request.contextPath}/logout" method="POST" style="display:inline;">
			            <button type="submit" class="logout-btn-submit">로그아웃</button>
			        </form:form>
			        
			        <!-- 🔔 [정위치 결합] 알림 종 상자가 user-info-box 내부 안으로 안전하게 들어옵니다! -->
			        <div class="alarm-container" style="position: relative; margin-left: 15px; display: inline-block; vertical-align: middle;">
			            <!-- 꽉 찬 종 모양 아이콘 -->
			            <i class="fa-solid fa-bell" id="alarmBellIcon" style="font-size: 20px; color: #ffffff; cursor: pointer;"></i>
			            
			            <!-- 알림 빨간 배지 -->
			            <span class="alarm-count-badge" style="position: absolute; top: -5px; right: -5px; background-color: #ff4d4d; color: white; font-size: 10px; padding: 2px 5px; border-radius: 50%; font-weight: bold; display: none;">0</span>
			            
			            <!-- 클릭 시 아래로 무조건 튀어나오는 실시간 알림 팝업창 -->
			            <div class="alarm-dropdown" style="display: none; position: absolute; top: 35px; right: -10px; width: 320px; max-height: 400px; background-color: #ffffff; border: 1px solid #dddddd; box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2); border-radius: 8px; z-index: 99999; overflow-y: auto;">
			                
			                <!-- 팝업 헤더 -->
			                <div style="padding: 12px 15px; border-bottom: 1px solid #eee; background-color: #f8f9fa; font-weight: bold; color: #333; font-size: 14px;">
			                    📢 실시간 시스템 경보 알림
			                </div>
			                
			                <!-- 팝업 내부 목록 리스트 레이어 -->
			                <ul class="alarm-list-content" style="list-style: none; padding: 0; margin: 0; font-size: 13px; color: #555;">
			                    <c:if test="${empty headerAlertList}">
			                        <li class="empty-alarm-msg" style="padding: 25px; text-align: center; color: #999;">새로운 경보 알림이 없습니다.</li>
			                    </c:if>
			                    <c:if test="${not empty headerAlertList}">
			                        <c:forEach var="alert" items="${headerAlertList}">
			                            <li style="padding: 12px 15px; border-bottom: 1px solid #f5f5f5; line-height: 1.4; background-color: #ffffff;">
			                                <div style="font-weight: 500; color: #333;">
			                                    <c:choose>
			                                        <c:when test="${alert.alertType eq '1'}"><span style="color: #ff4d4d; font-weight: bold;">[이상객체]</span></c:when>
			                                        <c:otherwise><span style="color: #ff9f43; font-weight: bold;">[개체미달]</span></c:otherwise>
			                                    </c:choose>
			                                    <c:out value="${alert.alertMsg}" />
			                                </div>
			                                <div style="font-size: 11px; color: #aaa; margin-top: 4px; text-align: right;">
			                                    <fmt:formatDate value="${alert.firstSendTime}" pattern="MM-dd HH:mm" />
			                                </div>
			                            </li>
			                        </c:forEach>
			                    </c:if>
			                </ul>
			                
			                <!-- 팝업 푸터 -->
			                <div style="padding: 10px; text-align: center; border-top: 1px solid #eee; background-color: #f8f9fa; border-bottom-left-radius: 8px; border-bottom-right-radius: 8px;">
			                    <a href="${pageContext.request.contextPath}/alert/list" style="text-decoration: none; color: #007bff; font-size: 12px; font-weight: bold;">전체 이력 보기</a>
			                </div>
			            </div>
			        </div>
			
			    </div> <!-- 👑 2. [위치 수정] 유저 박스를 닫는 </div>가 알림창 전체 구조가 완전히 끝난 이 자리로 내려옵니다! -->
			</c:if>
  
        </div>
    </header>
</div>

<script src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>

<script>
$(document).ready(function() {
    // 1. [기존 유지] 종 아이콘 클릭 시 알림 창 토글
    $('#alarmBellIcon').on('click', function(e) {
        e.stopPropagation();
        $('.alarm-dropdown').fadeToggle(150);
        $(this).removeClass('fa-shake').css('color', '#ffffff');
    });

    // 2. [기존 유지] 알림 팝업창 내부 클릭 시 꺼짐 방지
    $('.alarm-dropdown').on('click', function(e) {
        e.stopPropagation();
    });

    // 3. [기존 유지] 바깥 영역 클릭 시 팝업 닫기
    $(document).on('click', function() {
        $('.alarm-dropdown').fadeOut(100);
    });

    // ================================================================
    //  [실시간 버그 완치] 경보 로그 실시간 자동 업데이트 및 자동 팝업 레이더
    // ================================================================
    let lastProcessedAlertId = null; 

    const pollAlertServer = async () => {
        try {
            const response = await fetch('${pageContext.request.contextPath}/api/event/latest?t=' + new Date().getTime());
            
            if (response.ok) {
                const alertData = await response.json();
                
                if (alertData && alertData.alertId !== undefined) {
                    // 1. 최초 로딩 시점 동기화
                    if (lastProcessedAlertId === null) {
                        lastProcessedAlertId = alertData.alertId;
                    } 
                    // 2. 신규 경보 인서트 감지 시 실행
                    else if (alertData.alertId !== lastProcessedAlertId) {
                        let alertTypeTag = alertData.alertType === '1' 
                            ? '<span style="color: #ff4d4d; font-weight: bold;">[이상객체]</span>' 
                            : '<span style="color: #ff9f43; font-weight: bold;">[개체미달]</span>';
                            
                        // 스코프 안전 지대로 편입된 공통 함수 작동 격발
                        appendRealtimeAlarm(alertTypeTag + " " + alertData.alertMsg);
                        
                        // 경보창 강제 자동 팝업 활성화
                        $('.alarm-dropdown').fadeIn(200);
                        
                        lastProcessedAlertId = alertData.alertId;
                    }
                }
            }
        } catch (error) {
            console.error(" [알림 레이더 통신 대기] 경보 서버 상태를 확인 중입니다...", error);
        }
        setTimeout(pollAlertServer, 5000);
    };

    // 알림이 도착했을 때 동적으로 HTML 리스트를 밀어 넣는 공통 함수 (안전하게 제이쿼리 내부에 배치)
    function appendRealtimeAlarm(message) {
        // '알림이 없습니다' 기본 가이드 문구 즉시 청소
        $('.empty-alarm-msg').remove();
        
        let now = new Date();
        let timeStr = now.getHours() + ':' + String(now.getMinutes()).padStart(2, '0');
        
        // 새로운 알림 리스트 객체 디자인 조립
        let newAlarmHtml = '<li style="padding: 12px 15px; border-bottom: 1px solid #f5f5f5; line-height: 1.4; background-color: #fffafb;">'
            + ' <div>' + message + '</div>'
            + ' <div style="font-size: 11px; color: #aaa; margin-top: 4px; text-align: right;">' + timeStr + '</div>'
            + '</li>';
            
        // 1. 알림 리스트 맨 위(최상단)에 새로운 알림 삽입
        $('.alarm-list-content').prepend(newAlarmHtml);
        
        // ================================================================
        //  [최대 5개 강제 락 고도화] 오래된 하위 요소 실시간 즉시 컷트
        // ================================================================
        // 명확히 알림 리스트 구조 내부의 li 자식 요소들만 다시 정밀 추적 카운트합니다.
        let $listContainer = $('.alarm-list-content');
        
        while ($listContainer.children('li').length > 5) {
            $listContainer.children('li').last().remove(); // 5개를 초과하는 순간 맨 하단행 영구 소멸
        }
        // ================================================================
    
        // 헤더 종 흔들기 애니메이션 효과 및 알림 배지 카운트 누적
        $('#alarmBellIcon').addClass('fa-shake').css('color', '#ff4d4d');
        let currentCount = parseInt($('.alarm-count-badge').text()) || 0;
        $('.alarm-count-badge').text(currentCount + 1).show();
    }

    // 로그인 완료 시에만 관제 알림 감지 레이더 구동 격발
    <c:if test="${not empty sessionScope.SPRING_SECURITY_CONTEXT}">
        pollAlertServer();
    </c:if>
});

</script>
</body>
</html>