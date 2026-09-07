document.addEventListener("DOMContentLoaded", function () {

    // 1. 서브메뉴 드롭다운 (jQuery)
    $(document).on('mouseenter', 'ul.menu>li', function(){
        $(this).find('.submenu').stop().slideDown(500);
    }).on('mouseleave', 'ul.menu>li', function(){
        $(this).find('.submenu').stop().slideUp(500);
    });

    // 2. 스크롤 시 서브메뉴 자동 닫기 (jQuery)
    let scrollTimer;
    $(window).on('scroll', function() {
        clearTimeout(scrollTimer);
        scrollTimer = setTimeout(function() {
            $('ul.menu>li').find('.submenu').stop().slideUp(500);
        }, 1000); 
    });

    // 3. Sothic 롤링 슬라이더 (Vanilla JS)
    const ul = document.querySelector("#Sothic ul");
    if (ul) { 
        setInterval(function () {
            const firstLi = ul.querySelector("li");
            if (!firstLi) return;
            
            firstLi.style.transition = "margin-left 0.5s ease";
            firstLi.style.marginLeft = "-25%";
            
            setTimeout(function () {
                firstLi.style.transition = "none";
                firstLi.style.marginLeft = "0";
                ul.appendChild(firstLi);
            }, 500);
        }, 3000);
    }
	$(document).ready(function() {
	    
	    // 1. 우측 상단 [등록] 버튼 클릭 시 -> 팝업창(모달) 나타나기
	    $('.staff-register-btn').on('click', function() {
	        $('#registerModal').css('display', 'flex').hide().fadeIn(200);
	        
	        // 팝업이 열릴 때 오늘 날짜를 입력창에 자동으로 채워주는 기능입니다.
	        var today = new Date().toISOString().substring(0, 10);
	        $('#regDate').val(today);
	    });

	    // 2. 팝업창 안의 X 버튼 클릭 시 -> 팝업창 닫히기
	    $('#closeModalBtn').on('click', function() {
	        $('#registerModal').fadeOut(200);
	    });

	    // 3. 팝업창 바깥 어두운 배경 클릭 시 -> 자동으로 팝업창 닫히기
	    $('#registerModal').on('click', function(e) {
	        if ($(e.target).is('#registerModal')) {
	            $('#registerModal').fadeOut(200);
	        }
	    });
	});
});