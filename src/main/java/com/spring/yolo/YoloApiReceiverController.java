package com.spring.yolo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.spring.dto.DangerLogVO;
import com.spring.dto.DetectionLogVO;
import com.spring.service.DangerLogService;
import com.spring.service.DetectionLogService;

import lombok.extern.log4j.Log4j2;

@Log4j2
@RestController // 🎯 실무 팁: 데이터 전용 API 수신부이므로 @ResponseBody 생략 가능한 RestController 사용
@RequestMapping("/yolo/api") // 🎯 공통 보안 제외 구역 통합 패스
public class YoloApiReceiverController {

	@Autowired
	private DetectionLogService detectionLogService; // [INDEX]

	@Autowired
	private DangerLogService dangerLogService; // [INDEX]

	/**
	 * 🐶 트랙 A: 정상 축종(개/고양이) 보유 마리수 미달 로그 실시간 수급 API 주소:
	 * http://localhost:80/yolo/api/report-log
	 */
	@PostMapping(value = "/report-log", produces = "application/json; charset=UTF-8")
	public ResponseEntity<String> receiveNormalDetectionReport(@RequestBody DetectionLogVO vo) {
	    try {
	        log.info("⏰ [AI 수신 게이트웨이] 신호 유입 확인");
	        
	        log.info("▶ 수신된 드론 ID: " + vo.getDroneId()); 
	        log.info("▶ 수신된 개체수: " + vo.getDetectCount());
	        
	        // 만약 드론 ID가 톰캣 필터 노이즈로 날아갔다면 강제 심폐소생 복구
	        if (vo.getDroneId() == null || vo.getDroneId().isEmpty()) {
	            vo.setDroneId("DRONE01");
	        }
	        
	        detectionLogService.registerDetectionLog(vo); 
	        return new ResponseEntity<>("{\"status\":\"SUCCESS\"}", HttpStatus.OK);
	    } catch (Exception e) {
	        log.error("❌ [AI 수신 게이트웨이] 정상 축종 적재 실패: ", e);
	        return new ResponseEntity<>("{\"status\":\"FAIL\"}", HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}


	/**
	 * 🐯 트랙 B: 유해 야생동물(이상객체) 포착 로그 실시간 즉시 적재 API 주소:
	 * http://localhost:80/yolo/api/report
	 */
	@PostMapping(value = "/report", produces = "application/json; charset=UTF-8")
	public ResponseEntity<String> receiveDangerDetectionReport(@RequestBody DangerLogVO vo) {
        try {
            // 🎯 [아키텍처 최종 실링] 하드코딩 빗장을 풀고, 파이썬이 준 이상객체 코드를 100% 신뢰 접수합니다!
            log.info("🚨 [AI 수신 게이트웨이] 위험 객체 신호 유입 성공 ➔ 수신된 코드 번호: {}", vo.getDangerType());
            
            // 기존 vo.setDangerType(5) 조건문을 완전히 도려내고 곧바로 서비스를 호출합니다.
            dangerLogService.registerDangerLog(vo); // [INDEX]
            
            return new ResponseEntity<>("{\"status\":\"SUCCESS\"}", HttpStatus.OK); // [INDEX]
        } catch (Exception e) {
			log.error("❌ [AI 수신 게이트웨이] 위험 객체 적재 실패: ", e);
			return new ResponseEntity<>("{\"status\":\"FAIL\"}", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
}
