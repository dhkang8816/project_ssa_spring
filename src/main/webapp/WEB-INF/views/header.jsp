<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>헤더</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/style.css">
<style>
/* 1. 상단 관제소 전용 탑 헤더 바 스타일 */
.top-header {
    background-color: #111827 !important; /* 메인 관제소와 톤을 맞춘 심해 블랙 톤 */
    border-bottom: 1px solid #1e293b;
    padding: 0 30px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
    box-sizing: border-box;
}

/* 2. 시스템 대타이틀 모던 글래시 폰트 */
.system-title {
    margin: 0;
    font-size: 20px;
    font-weight: 800;
    letter-spacing: -0.03em;
}

.system-title a {
    color: #38bdf8 !important; /* 사이버 네온 블루 정체성 각인 */
    text-decoration: none !important;
    transition: color 0.2s ease;
}

.system-title a:hover {
    color: #0ea5e9 !important;
}

/* 3. 우측 유저 및 알림 제어 컴포넌트 박스 */
.user-info-box {
    display: flex !important;
    align-items: center !important; /* ⭕ 세로축 중앙 정렬 강제 고정 */
    gap: 16px;
    height: 100%; /* 부모 헤더 높이에 맞춤 */
}

.user-info-box form {
    display: flex !important;
    align-items: center !important; /* ⭕ Form 태그 내부 정렬 누수 차단 */
    margin: 0 !important;
    padding: 0 !important;
}

/* 프로필 썸네일 인터랙션 모던화 */
.header-profile-link {
    display: inline-block;
    transition: transform 0.2s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.header-profile-link:hover {
    transform: scale(1.1);
}
.header-profile-img {
    width: 34px;
    height: 34px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid #334155;
    cursor: pointer;
}

/* 관제사 로그인 정보 가독성 증폭 */
.user-text-info {
    color: #94a3b8;
    font-size: 13px;
    font-weight: 500;
}
.user-text-info strong {
    color: #ffffff;
    font-weight: 600;
    background: rgba(56, 189, 248, 0.1);
    padding: 2px 6px;
    border-radius: 4px;
    margin-right: 2px;
}

/* 4. 로그아웃 세련된 텍스트 버튼 튜닝 */
.logout-btn-submit {
    background: none !important;
    border: none !important;
    color: #ef4444 !important; 
    font-weight: 700 !important;
    font-size: 13px !important;
    cursor: pointer !important;
    
    /* ⭕ 다른 화면의 버튼 패딩/마진 초기화 및 가로 정렬 고정 */
    padding: 0 !important;
    margin: 0 0 0 12px !important; /* 왼쪽에만 살짝 여백 부여 */
    line-height: 1 !important;     /* 텍스트 자체 높이 고정 */
    vertical-align: middle !important; /* 라인 핏 맞춤 */
    text-decoration: none !important;
    
    display: inline-block !important;
    transition: color 0.2s;
}

.logout-btn-submit:hover {
    color: #f87171 !important;
    text-decoration: underline !important;
}

/* 5. [중요] 실시간 알림Dropdown 창의 다크 관제소 테마 셋업 */
.alarm-dropdown {
    display: none;
    position: absolute;
    top: 40px;
    right: -10px;
    width: 340px;
    max-height: 420px;
    background-color: #131926 !important; /* 드론 설정창과 동기화된 다크 모달 배경 */
    border: 1px solid #334155 !important;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.6) !important;
    border-radius: 12px !important;
    z-index: 99999;
    overflow-y: auto;
}

/* 알림 드롭다운 헤더 */
.alarm-dropdown .pop-header-title {
    padding: 14px 18px;
    border-bottom: 1px solid #232d3f;
    background-color: #171e2e;
    font-weight: 700;
    color: #38bdf8;
    font-size: 14px;
    letter-spacing: -0.01em;
}

/* 알림 리스트 아이템 모던화 */
.alarm-list-content li {
    padding: 0;
    border-bottom: 1px solid #1e293b !important;
    line-height: 1.5;
    background-color: #131926 !important;
    transition: background 0.2s;
}
.alarm-list-content li:hover {
    background-color: #171e2e !important;
}

.alarm-list-content li a {
    display: block;
    padding: 14px 18px;
    color: #cbd5e1 !important; /* 다크 모드용 텍스트 컬러 보정 */
    text-decoration: none;
    cursor: pointer;
}

/* 알림 푸터 영역 */
.alarm-dropdown .pop-footer-box {
    padding: 12px;
    text-align: center;
    border-top: 1px solid #232d3f;
    background-color: #171e2e;
    border-bottom-left-radius: 12px;
    border-bottom-right-radius: 12px;
}
.alarm-dropdown .pop-footer-box a {
    text-decoration: none;
    color: #38bdf8;
    font-size: 12px;
    font-weight: 700;
}
.alarm-dropdown .pop-footer-box a:hover {
    text-decoration: underline;
}
</style>
</head>
<body>
<div class="main-wrapper">
<header class="top-header">
<h1 class="system-title">
<a href="${pageContext.request.contextPath}/">유기동물 보호소 관제시스템</a>
</h1>

<!-- 세션 정보를 직접 판별하여 UI를 변경하는 영역 -->
<div id="util-box">
    <%-- 1. 비로그인 상태일 때 --%>
    <c:if test="${empty sessionScope.SPRING_SECURITY_CONTEXT}">
        <a href="${pageContext.request.contextPath}/login" class="btn-change text-decoration-none py-1 px-3" style="font-size: 13px;">로그인</a>
    </c:if>
    
    <%-- 2. 로그인 완료 상태일 때 --%>
    <c:if test="${not empty sessionScope.SPRING_SECURITY_CONTEXT}">
        <div class="user-info-box">
            
            <!-- 내 정보 보기 프로필 이미지 -->
            <a href="${pageContext.request.contextPath}/member/detail?memberId=${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal}" class="header-profile-link" title="내 정보 보기" data-detail-popup data-popup-name="memberDetail">
                <img src="${pageContext.request.contextPath}/resources/images/member/noImage.jpg" class="header-profile-img" alt="프로필">
            </a>
            
            <!-- 사번 텍스트 및 상태 정보 -->
            <span class="user-text-info"> 
                <strong>${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal}</strong>님 로그인 중
            </span>
            
            <!-- 안전한 POST 로그아웃 폼 -->
            <form:form action="${pageContext.request.contextPath}/logout" method="POST" style="display:inline;">
                <button type="submit" class="logout-btn-submit">로그아웃</button>
            </form:form>
            
            <!-- [정위치 결합] 알림 종 레이어 바인딩 세션 -->
            <div class="alarm-container" style="position: relative; margin-left: 8px; display: inline-block; vertical-align: middle;">
                <!-- 꽉 찬 종 모양 아이콘 -->
                <i class="fa-solid fa-bell" id="alarmBellIcon" style="font-size: 19px; color: #94a3b8; cursor: pointer; transition: color 0.2s;" onmouseover="this.style.color='#ffffff'" onmouseout="this.style.color='#94a3b8'"></i>
                
                <!-- 알림 빨간 배지 -->
                <span class="alarm-count-badge" style="position: absolute; top: -6px; right: -7px; background-color: #ef4444; color: white; font-size: 9px; padding: 2px 5px; border-radius: 50%; font-weight: 700; display: none;">0</span>
                
                <!-- 클릭 시 아래로 무조건 튀어나오는 실시간 알림 팝업창 -->
                <div class="alarm-dropdown">
                    <!-- 팝업 헤더 명칭 컴포넌트화 -->
                    <div class="pop-header-title">🔔 실시간 시스템 경보 알림</div>
                    
                    <!-- 팝업 내부 목록 리스트 레이어 -->
                    <ul class="alarm-list-content" style="list-style: none; padding: 0; margin: 0; font-size: 13px;">
                        <c:if test="${empty headerAlertList}">
                            <li class="empty-alarm-msg text-center text-muted py-4 small" style="background-color: #131926 !important;">새로운 경보 알림이 없습니다.</li>
                        </c:if>
                        <c:if test="${not empty headerAlertList}">
                            <c:forEach var="alert" items="${headerAlertList}">
                                <c:choose>
                                    <c:when test="${not empty alert.dlogId}">
                                        <c:set var="headerAlertUrl" value="${pageContext.request.contextPath}/detection/detail?dlogId=${alert.dlogId}" />
                                        <c:set var="headerAlertPopupName" value="detectionDetail" />
                                    </c:when>
                                    <c:when test="${not empty alert.danlogId}">
                                        <c:set var="headerAlertUrl" value="${pageContext.request.contextPath}/dangerlog/detail?danlogId=${alert.danlogId}" />
                                        <c:set var="headerAlertPopupName" value="dangerLogDetail" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="headerAlertUrl" value="${pageContext.request.contextPath}/alert/alertDetail?alertId=${alert.alertId}" />
                                        <c:set var="headerAlertPopupName" value="alertDetail" />
                                    </c:otherwise>
                                </c:choose>
                                
                                <li>
                                    <a data-detail-popup data-popup-name="${headerAlertPopupName}" href="${headerAlertUrl}">
                                        <span style="display: block; font-weight: 500;"> 
                                            <c:choose>
                                                <c:when test="${alert.alertType eq '1'}">
                                                    <span style="color: #ef4444; font-weight: 700;">[이상객체] </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #f59e0b; font-weight: 700;">[개체미달] </span>
                                                </c:otherwise>
                                            </c:choose> 
                                            <c:out value="${alert.alertMsg}" />
                                        </span> 
                                        <span style="display: block; font-size: 11px; color: #64748b; margin-top: 4px; text-align: right;">
                                            <fmt:formatDate value="${alert.firstSendTime}" pattern="MM-dd HH:mm" />
                                        </span>
                                    </a>
                                </li>
                            </c:forEach>
                        </c:if>
                    </ul>
                    
                    <!-- 팝업 푸터 -->
                    <div class="pop-footer-box">
                        <a href="${pageContext.request.contextPath}/alert/list">전체 이력 보기</a>
                    </div>
                </div> <!-- .alarm-dropdown END -->
            </div> <!-- .alarm-container END -->
            
        </div> <!-- .user-info-box END -->
    </c:if>
</div> <!-- #util-box END -->
</header>
</div>

</body>
<script
	src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>

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
        var detailLink = e.target.closest('a[data-detail-popup]');
        if (detailLink) {
            e.preventDefault();
            e.stopPropagation();
            openDetailPopup(detailLink.href, detailLink.getAttribute('data-popup-name'));
            return;
        }
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
                        appendRealtimeAlarm(alertData);
                        
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
    function appendRealtimeAlarm(alertData) {
        // '알림이 없습니다' 기본 가이드 문구 즉시 청소
        $('.empty-alarm-msg').remove();
        
        let now = new Date();
        let timeStr = now.getHours() + ':' + String(now.getMinutes()).padStart(2, '0');
        
        // 새로운 알림 리스트 객체 디자인 조립
        let contextPath = '${pageContext.request.contextPath}';
        let targetUrl = contextPath + '/alert/alertDetail?alertId=' + encodeURIComponent(alertData.alertId);
        let popupName = 'alertDetail';
        if (alertData.dlogId) {
            targetUrl = contextPath + '/detection/detail?dlogId=' + encodeURIComponent(alertData.dlogId);
            popupName = 'detectionDetail';
        } else if (alertData.danlogId) {
            targetUrl = contextPath + '/dangerlog/detail?danlogId=' + encodeURIComponent(alertData.danlogId);
            popupName = 'dangerLogDetail';
        }

        let typeText = alertData.alertType === '1' ? '[이상객체]' : '[개체미달]';
        let typeColor = alertData.alertType === '1' ? '#ff4d4d' : '#ff9f43';
        let $link = $('<a>', {
            href: targetUrl,
            'data-detail-popup': '',
            'data-popup-name': popupName,
            css: { textDecoration: 'none', color: '#333', display: 'block' }
        });
        $link.append($('<span>', { text: typeText, css: { color: typeColor, fontWeight: 'bold' } }));
        $link.append(document.createTextNode(' ' + (alertData.alertMsg || '새 경보가 발생했습니다.')));

        let $newAlarm = $('<li>', {
            css: { padding: '12px 15px', borderBottom: '1px solid #f5f5f5', lineHeight: '1.4', backgroundColor: '#fffafb' }
        });
        $newAlarm.append($link);
        $newAlarm.append($('<div>', {
            text: timeStr,
            css: { fontSize: '11px', color: '#aaa', marginTop: '4px', textAlign: 'right' }
        }));
            
        // 1. 알림 리스트 맨 위(최상단)에 새로운 알림 삽입
        $('.alarm-list-content').prepend($newAlarm);
        
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
<script>
    function openDetailPopup(url, windowName) {
        // Form/detail popups should follow their content width, while report
        // and workflow screens need room for wider document/table layouts.
        var popupName = (windowName || '').toLowerCase();
        var compactProfiles = {
            dangerregister: { width: 640, height: 520 },
            dangerdetail: { width: 700, height: 600 },
            droneregister: { width: 720, height: 620 },
            dronedetail: { width: 720, height: 680 },
            coderegister: { width: 720, height: 760 },
            codedetail: { width: 720, height: 720 },
            animalregister: { width: 760, height: 820 },
            animaldetail: { width: 760, height: 880 },
            alertdetail: { width: 780, height: 700 }
        };
        var isWidePopup = /patrolreport|workflow|flighthistory|animalcounter/.test(popupName);
        var isMediumPopup = /detection|dangerlog/.test(popupName);
        var compactProfile = compactProfiles[popupName];
        var preferredWidth = compactProfile ? compactProfile.width
            : (isWidePopup ? 1100 : (isMediumPopup ? 920 : 780));
        var preferredHeight = compactProfile ? compactProfile.height
            : (isWidePopup ? 960 : 940);
        var maxWidth = screen.availWidth - 40;
        var maxHeight = screen.availHeight - 36;
        var popupWidth = Math.max(320, Math.min(preferredWidth, maxWidth));
        var popupHeight = Math.max(420, Math.min(preferredHeight, maxHeight));
        var left = Math.max(0, Math.round((screen.availWidth - popupWidth) / 2));
        var top = Math.max(12, Math.min(24, screen.availHeight - popupHeight - 12));
        var popup = window.open(url, windowName || 'ssaDetailPopup',
            'width=' + popupWidth + ',height=' + popupHeight + ',left=' + left + ',top=' + top
            + ',resizable=yes,scrollbars=yes');

        if (popup) {
            // A reused named popup may retain its previous geometry in Chrome.
            // Reapply the computed size and top position for every open.
            popup.moveTo(left, top);
            popup.resizeTo(popupWidth, popupHeight);
            popup.focus();
            return false;
        }

        window.location.href = url;
        return false;
    }

    function openFormPopup(url, windowName) {
        var separator = url.indexOf('?') === -1 ? '?' : '&';
        return openDetailPopup(url + separator + 'popup=true', windowName || 'ssaFormPopup');
    }

    function closePopupAndRefreshParent(fallbackUrl) {
        if (window.opener && !window.opener.closed) {
            try {
                var rootOpener = window.opener;
                while (rootOpener.opener && !rootOpener.opener.closed) {
                    rootOpener = rootOpener.opener;
                }
                rootOpener.location.reload();
            } catch (error) {
                // The popup may still be closed when its opener is unavailable.
            }
            window.close();
            return false;
        }

        if (fallbackUrl) {
            window.location.href = fallbackUrl;
        }
        return false;
    }

    // All list JSPs include this header, so CSV buttons always have one
    // available global implementation regardless of individual script imports.
    function downloadTableAsCsv(tableSelector, filename) {
        var table = document.querySelector(tableSelector);
        if (!table) {
            window.alert('CSV 다운로드 대상을 찾을 수 없습니다.');
            return;
        }

        var csvRows = Array.prototype.slice.call(table.querySelectorAll('tr'))
            .map(function(row) {
                return Array.prototype.slice.call(row.querySelectorAll('th, td'))
                    .map(function(cell) {
                        var value = (cell.innerText || cell.textContent || '')
                            .replace(/\r?\n|\r/g, ' ')
                            .replace(/\s{2,}/g, ' ')
                            .trim()
                            .replace(/"/g, '""');
                        return '"' + value + '"';
                    }).join(',');
            }).filter(function(row) { return row.length > 0; });

        if (csvRows.length < 2) {
            window.alert('다운로드할 목록 데이터가 없습니다.');
            return;
        }

        var blob = new Blob(['\ufeff' + csvRows.join('\r\n')], { type: 'text/csv;charset=utf-8;' });
        var link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = (filename || 'ssa-list') + '-' + new Date().toISOString().slice(0, 10) + '.csv';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(link.href);
    }

    document.addEventListener('click', function(event) {
        var link = event.target.closest('a[data-detail-popup]');
        if (!link || event.ctrlKey || event.metaKey || event.shiftKey || event.button !== 0) {
            return;
        }
        event.preventDefault();
        openDetailPopup(link.href, link.dataset.popupName);
    });

    (function closeSavedPopup() {
        if (new URLSearchParams(window.location.search).get('popupSaved') !== 'true' || !window.opener) {
            return;
        }

        try {
            var rootOpener = window.opener;
            while (rootOpener.opener && !rootOpener.opener.closed) {
                rootOpener = rootOpener.opener;
            }
            rootOpener.location.reload();
            window.close();
        } catch (error) {
            // The redirected list remains usable if the opener is unavailable.
        }
    })();
</script>
</html>
