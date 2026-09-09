package com.spring.yolo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.sql.Timestamp;
import jakarta.servlet.http.HttpSession; 
import com.spring.dto.DangerLogVO;
import com.spring.dto.DetectionLogVO;
import com.spring.dto.AlertLogVO;
import com.spring.service.DangerLogService;
import com.spring.service.DetectionLogService;
import com.spring.dao.AlertLogDAO; 
import lombok.extern.log4j.Log4j2;

@Log4j2
@RestController
@RequestMapping("/yolo/api") 
public class YoloApiReceiverController {

    @Autowired
    private DetectionLogService detectionLogService;
    
    @Autowired
    private DangerLogService dangerLogService;
    
    @Autowired
    private AlertLogDAO alertLogDAO; 
    
    @Autowired
    private HttpSession session; 

    /**
     *  트랙 A: 정상 축종(개/고양이) 보유 마리수 미달 경보 수신 창구
     */
    @PostMapping(value = "/report-log", produces = "application/json; charset=UTF-8")
    public ResponseEntity<String> receiveNormalDetectionReport(@RequestBody DetectionLogVO vo) {
        // 🌟 [최종 방어선] 멀티 스레드가 동시에 인서트를 찔러 오라클 MAX+1이 충돌하는 현상을 완벽히 차단합니다.
        synchronized(YoloApiReceiverController.class) {
            try {
                log.info("⏰ [AI 수신 게이트웨이] 개체수 미달 신호 유입 확인");
                if (vo.getDroneId() == null || vo.getDroneId().isEmpty()) {
                    vo.setDroneId("DRONE01");
                }
                
                // 1. 부모 테이블(DETECTION_LOG) 적재 실행
                detectionLogService.registerDetectionLog(vo); 
                
                // 2. 다이렉트 DAO 연동 1
                try {
                    // 🌟 [데이터 왜곡 완치] 수신된 vo의 animalType을 보고 알림 메시지를 동적으로 바인딩합니다.
                    String animalName = "0".equals(vo.getAnimalType()) ? "반려견(dog)" : "고양이(cat)";
                    
                    AlertLogVO avo = AlertLogVO.builder()
                         .alertType("0") // 공통코드 규칙: '0' (동물미달)
                         .alertMsg("⚠ [관제 시스템 자동 알림] 관제 구역 내 " + animalName + " 보유 마리수 기준치 미달 현상 지속 감지!")
                         .sendStatus("1") // 공통코드 규칙: '1' (성공)
                         .dlogId(vo.getDlogId() != 0 ? vo.getDlogId() : null) 
                         .firstSendTime(new Timestamp(System.currentTimeMillis()))
                         .build();
                         
                    alertLogDAO.insertAlertLog(avo); 
                    log.info(" [다이렉트 적재 성공] '동물미달(0)' 경보 이력이 ALERT_LOG에 안전하게 등록되었습니다.");
                    
                    // 실시간 팝업 브릿지 세션 주머니 연동
                    session.setAttribute("REALTIME_ALERT_FLAG", "TRIGGER");
                    session.setAttribute("REALTIME_ALERT_MSG", avo.getAlertMsg());
             
                } catch (Exception alertEx) {
                    log.error("❌ [DAO 적재 에러] 트랙 A ALERT_LOG 직통 인서트 실패: ", alertEx);
                }
                return new ResponseEntity<>("{\"status\":\"SUCCESS\"}", HttpStatus.OK);
            } catch (Exception e) {
                log.error("❌ [AI 수신 게이트웨이] 정상 축종 적재 실패: ", e);
                return new ResponseEntity<>("{\"status\":\"FAIL\"}", HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }
    }

    /**
     *  트랙 B: 유해 야생동물(이상객체) 포착 로그 실시간 즉시 경보 수신 창구
     */
    @PostMapping(value = "/report", produces = "application/json; charset=UTF-8")
    public ResponseEntity<String> receiveDangerDetectionReport(@RequestBody DangerLogVO vo) {
        // 🌟 [최종 방어선] 상어, 호랑이 등이 동시다발적으로 포착되어 들어올 때 오라클 PK 충돌을 완전히 차단합니다.
        synchronized(YoloApiReceiverController.class) {
            try {
                log.info(" [AI 수신 게이트웨이] 위험 객체 신호 유입 성공 ➔ 수신된 코드 번호: {}", vo.getDangerType());
                
                // 1. 부모 위험 테이블(DANGER_LOG) 적재 실행
                dangerLogService.registerDangerLog(vo); 
                
                // 2. 다이렉트 DAO 연동 2
                try {
                    String dangerName = "확인불명 이상객체";
                    if (vo.getDangerType() == 2) dangerName = "외계 생물(블루)";
                    else if (vo.getDangerType() == 3) dangerName = "유해 수중체(샤크)"; // 🌟 누락된 상어(3번) 배관 추가 복구
                    else if (vo.getDangerType() == 4) dangerName = "유해 비행체(드래곤)";
                    else if (vo.getDangerType() == 5) dangerName = "맹수(호랑이)";
                    
                    AlertLogVO avo = AlertLogVO.builder()
                         .alertType("1") // 공통코드 규칙: '1' (이상개체)
                         .alertMsg("🚨 [비상 관제 경보] 관제 구역 내 위험 이상객체 [" + dangerName + "] 실시간 출현! 즉시 대피 요망.")
                         .sendStatus("1") // 공통코드 규칙: '1' (성공)
                         .danlogId(vo.getDanlogId() != 0 ? vo.getDanlogId() : null) 
                         .firstSendTime(new Timestamp(System.currentTimeMillis()))
                         .build();
                         
                    alertLogDAO.insertAlertLog(avo); 
                    log.info(" [다이렉트 적재 성공] '이상개체(1)' 경보 이력이 ALERT_LOG에 안전하게 등록되었습니다.");
                    
                    // 실시간 팝업 브릿지 세션 주머니 연동
                    session.setAttribute("REALTIME_ALERT_FLAG", "TRIGGER");
                    session.setAttribute("REALTIME_ALERT_MSG", avo.getAlertMsg());
             
                } catch (Exception alertEx) {
                    log.error("❌ [DAO 적재 에러] 트랙 B ALERT_LOG 직통 인서트 실패: ", alertEx);
                }
                return new ResponseEntity<>("{\"status\":\"SUCCESS\"}", HttpStatus.OK); 
            } catch (Exception e) {
                log.error("❌ [AI 수신 게이트웨이] 위험 객체 적재 실패: ", e);
                return new ResponseEntity<>("{\"status\":\"FAIL\"}", HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }
    }
}
