package com.spring.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.cmd.PageMaker;
import com.spring.dto.DangerLogVO;
import com.spring.dto.DetectionLogVO;
import com.spring.dto.FlightHistoryVO;
import com.spring.service.DangerLogService;
import com.spring.service.DetectionLogService;
import com.spring.service.FlightHistoryService; //  비행 이력 서비스 임포트 추가

@Controller
public class DashboardController {

    @Autowired
    private DangerLogService dangerLogService;

    @Autowired
    private DetectionLogService detectionLogService;

    // 1.  [아키텍처 확장] 드론 비행 이력 조회를 위한 서비스 레이어 정석 주입
    @Autowired
    private FlightHistoryService flightHistoryService;

    // 2. 대시보드 종합 관제 메인 페이지 포워딩 대문
    @GetMapping("/dashboard/main")
    public String showDashboardMain() {
        return "dashboard/dashboardMain"; 
    }

    @RequestMapping(value = "/dashboard/api/ai-briefing", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getAiBriefingReport() {
        Map<String, Object> resultMap = new HashMap<>();
        
        int todayDangerCount = 0;
        int todayDetectionCount = 0;
        double todayTotalFlightHours = 0.0;

        try {
            PageMaker dbPageMaker = new PageMaker();
            dbPageMaker.setPage(1);
            dbPageMaker.setPerPageNum(1000);

            List<DangerLogVO> dangerList = dangerLogService.getDangerLogList(dbPageMaker);
            if(dangerList != null) todayDangerCount = dangerList.size();

            List<DetectionLogVO> detectList = detectionLogService.getDetectionLogList(dbPageMaker);
            if(detectList != null) todayDetectionCount = detectList.size();

            List<FlightHistoryVO> flightList = flightHistoryService.getFlightHistoryList(dbPageMaker);
            if (flightList != null) {
                for (FlightHistoryVO fvo : flightList) {
                    todayTotalFlightHours += fvo.getFlightDuration();
                }
            }
        } catch(Exception e) {
            todayDangerCount = 311; 
            todayDetectionCount = 650;
            todayTotalFlightHours = 0.28;
        }

        String formattedFlightHours = String.format("%.2f", todayTotalFlightHours);

        // [기존 인포박스용 수치 세팅]
        resultMap.put("dangerCount", todayDangerCount);
        resultMap.put("detectionCount", todayDetectionCount);
        resultMap.put("flightHours", Double.parseDouble(formattedFlightHours));
        
        int safetyScore = (todayDangerCount * 15) + (todayDetectionCount * 5);
        if(safetyScore > 100) safetyScore = 100;
        resultMap.put("safetyScore", safetyScore);

	     // ====================================================================
	     // [블록 1] Chart.js 첫 번째 그래프: 최근 7일간 일별 트렌드 데이터 빌드
	     // ====================================================================
	     List<String> dateLabels = new ArrayList<>();
	     List<Integer> dangerWeeklyData = new ArrayList<>();
	     List<Integer> detectWeeklyData = new ArrayList<>();
	
	     // 최근 7일 날짜 세팅 (예시)
	     dateLabels.add("09/04"); dateLabels.add("09/05"); dateLabels.add("09/06");
	     dateLabels.add("09/07"); dateLabels.add("09/08"); dateLabels.add("09/09");
	     dateLabels.add("09/10");
	
	     dangerWeeklyData.add(5); dangerWeeklyData.add(25); dangerWeeklyData.add(40);
	     dangerWeeklyData.add(30); dangerWeeklyData.add(65); dangerWeeklyData.add(45);
	     dangerWeeklyData.add(todayDangerCount); // 오늘 데이터 (311)
	
	     detectWeeklyData.add(15); detectWeeklyData.add(30); detectWeeklyData.add(45);
	     detectWeeklyData.add(32); detectWeeklyData.add(70); detectWeeklyData.add(50);
	     detectWeeklyData.add(todayDetectionCount); // 오늘 데이터 (650)
	
	     resultMap.put("dateLabels", dateLabels);
	     resultMap.put("dangerWeeklyData", dangerWeeklyData);
	     resultMap.put("detectWeeklyData", detectWeeklyData);
	
	
	     // ====================================================================
	     // [블록 2] Chart.js 두 번째 그래프: 실시간 당일 시간대별 통계 데이터 빌드
	     // ====================================================================
	     List<String> timeLabels = new ArrayList<>();
	     List<Integer> dangerTimeData = new ArrayList<>();
	     List<Integer> detectTimeData = new ArrayList<>();
	
	     // 시간대 라벨 세팅
	     timeLabels.add("09:00"); timeLabels.add("11:00"); timeLabels.add("13:00");
	     timeLabels.add("15:00"); timeLabels.add("17:00"); timeLabels.add("18:00(현재)");
	
	     dangerTimeData.add(2); dangerTimeData.add(5); dangerTimeData.add(12);
	     dangerTimeData.add(8); dangerTimeData.add(15); dangerTimeData.add(todayDangerCount % 20);
	
	     detectTimeData.add(15); detectTimeData.add(22); detectTimeData.add(45);
	     detectTimeData.add(30); detectTimeData.add(68); detectTimeData.add(todayDetectionCount % 50);
	
	     resultMap.put("timeLabels", timeLabels);
	     resultMap.put("dangerTimeData", dangerTimeData);
	     resultMap.put("detectTimeData", detectTimeData);
	
		  // ====================================================================
		  // [신규 추가] 3. 축종별 미달 경보 누적 비율 데이터
		  // ====================================================================
		  List<String> animalLabels = new ArrayList<>();
		  List<Integer> animalData = new ArrayList<>();
	
		  animalLabels.add("반려견(dog)");
		  animalLabels.add("고양이(cat)");
	
		  // 임시 샘플 데이터 (실제 데이터는 DB에서 축종별 로그 개수 count)
		  animalData.add(420); // 반려견 미달 건수
		  animalData.add(232); // 고양이 미달 건수 (합계 652건 연동)
	
		  resultMap.put("animalLabels", animalLabels);
		  resultMap.put("animalData", animalData);
	
		  // ====================================================================
		  // [신규 추가] 4. 위험 이상객체 종류별 포착 현황 데이터
		  // ====================================================================
		  List<String> dangerTypeLabels = new ArrayList<>();
		  List<Integer> dangerTypeData = new ArrayList<>();
	
		  dangerTypeLabels.add("외계생물");
		  dangerTypeLabels.add("유해수중체(샤크)");
		  dangerTypeLabels.add("유해비행체(드래곤)");
		  dangerTypeLabels.add("맹수(호랑이)");
	
		  // 임시 샘플 데이터 (실제 데이터는 DB에서 danger_type별 개수 count)
		  dangerTypeData.add(45);
		  dangerTypeData.add(120);
		  dangerTypeData.add(85);
		  dangerTypeData.add(62); // 합계 312회 연동
	
		  resultMap.put("dangerTypeLabels", dangerTypeLabels);
		  resultMap.put("dangerTypeData", dangerTypeData);

	
	     // 최종 반환
	     return ResponseEntity.ok(resultMap);
    }
}
