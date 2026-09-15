package com.spring.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model; // 🛠️ Model 클래스 표준 임포트
import org.springframework.web.bind.annotation.GetMapping;
import com.spring.cmd.PageMaker;
import com.spring.dto.AlertLogVO;
import com.spring.util.RuntimeSettings;
import com.spring.dao.AlertLogDAO; // 🛠️ DAO 인터페이스 표준 임포트

@Controller
public class MainController {
	
    @Autowired
    private AlertLogDAO alertLogDAO; // 검증된 진짜 오라클 직통 DAO 주입

    
    @GetMapping("/")
    public String main(Model model) {
        model.addAttribute("flaskEsp32VideoUrl", RuntimeSettings.text(
                "SSA_FLASK_ESP32_VIDEO_URL", "http://localhost:5000/esp32_yolov12/video_feed"));
        try {
            PageMaker alertPageCmd = new PageMaker();
            alertPageCmd.setPage(1);
            alertPageCmd.setPerPageNum(5); // 상단바 팝업 전용 딱 5건 추출 지정
            alertPageCmd.setSearchType(""); // XML 내부 검색 필터 우회를 위해 공백 수식 바인딩
            alertPageCmd.setKeyword("");
            List<AlertLogVO> headerAlertList = alertLogDAO.getAlertLogListWithPaging(alertPageCmd);
            model.addAttribute("headerAlertList", headerAlertList);
            System.out.println("📬 [백엔드 오라클 연동 완수] 메인 화면 팝업창 전용 과거 데이터 5건 바인딩 완료!");
            
        } catch (Exception e) {
            System.err.println("❌ [헤더 알림 초기 로딩 실패] 오라클 이력을 읽어오지 못했습니다: " + e.getMessage());
        }
        
        return "main"; // /WEB-INF/views/main.jsp로 부드럽게 화면 이동
    }
}
