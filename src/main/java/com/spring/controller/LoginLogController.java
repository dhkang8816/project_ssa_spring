package com.spring.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.cmd.PageMaker;
import com.spring.dao.LoginLogDAO;
import com.spring.dto.LoginLogVO;

import lombok.extern.log4j.Log4j2;

@Log4j2
@Controller
@RequestMapping("/loginlog")
public class LoginLogController {

    @Autowired
    private LoginLogDAO loginLogDAO;

    /**
     * 1. 로그인 이력 페이징 목록 조회 (/loginlog/list)
     */
    @GetMapping("/list")
    public String loginLogList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        log.info("📢 [화면 프로토타입] 로그인 이력 페이징 목록 요청 진입 - 페이지: {}", pageMaker.getPage());
        
        List<LoginLogVO> loginLogList = null;
        int totalCount = 0;
        
        try {
            // [실물 작동 시도] DB 연동이 성공하면 실물 데이터를 가져옵니다.
            totalCount = loginLogDAO.selectLoginLogListCount(pageMaker);
            pageMaker.setTotalCount(totalCount);
            loginLogList = loginLogDAO.selectLoginLogList(pageMaker);
            
            // 만약 DB 테이블이 비어있거나 에러 상태라면 가짜(더미) 데이터 전면 가동!
            if (loginLogList == null || loginLogList.isEmpty()) {
                log.warn("⚠️ 실물 DB에 로그인 로그가 없어 프로토타입용 가짜(더미) 데이터를 생성합니다.");
                loginLogList = generateDummyData(pageMaker);
                pageMaker.setTotalCount(55); // 더미 토탈 개수 강제 세팅 (페이징 버튼 활성화용)
            }
            
        } catch (Exception e) {
            log.error("🚨 DB 조회 중 크래시 발생 -> 화면 시연을 위해 더미 데이터 모드로 안전 전환합니다.");
            loginLogList = generateDummyData(pageMaker);
            pageMaker.setTotalCount(55); // 페이징 정상 작동 유도
        }
        
        model.addAttribute("loginLogList", loginLogList);
        model.addAttribute("pageMaker", pageMaker);
        
        return "loginlog/loginLogList"; // WEB-INF/views/loginlog/loginLogList.jsp 매핑
    }

    /**
     * 💡 [화면구현 전용 스마트 치유] 시연 및 기획서 제출용 가짜 데이터 생성 알고리즘
     */
    private List<LoginLogVO> generateDummyData(PageMaker pageMaker) {
        List<LoginLogVO> dummyList = new ArrayList<>();
        int currentPage = pageMaker.getPage();
        int perPageNum = pageMaker.getPerPageNum();
        
        // 현재 페이지 범위에 맞게 역순으로 인덱싱 계산
        int startNum = 55 - ((currentPage - 1) * perPageNum);
        
        for (int i = 0; i < perPageNum; i++) {
            int currentLogId = startNum - i;
            if (currentLogId <= 0) break; // 0이하 로그 번호 차단
            
            String targetMember = "user0" + ((currentLogId % 5) + 1);
            if (currentLogId == 55) targetMember = "admin"; // 최신 로그는 관리자 계정으로 매핑
            
            String status = (currentLogId % 4 == 0) ? "FAIL" : "SUCCESS";
            String ip = "192.168.0." + (10 + (currentLogId % 15));
            
            // 약 10분 간격으로 과거 시간 차감 계산
            long timeOffset = (55 - currentLogId) * 10L * 60L * 1000L;
            Date logDate = new Date(System.currentTimeMillis() - timeOffset);

            LoginLogVO dummy = LoginLogVO.builder()
                    .logId(currentLogId)
                    .memberId(targetMember)
                    .loginIp(ip)
                    .loginStatus(status)
                    .loginDate(logDate)
                    .build();
                    
            dummyList.add(dummy);
        }
        
        return dummyList;
    }
}
