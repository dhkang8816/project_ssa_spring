package com.spring.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.spring.cmd.PageMaker;
import com.spring.dto.AnimalCounterVO;
import com.spring.dto.CommonCodeVO;
import com.spring.dto.DetectionLogVO;
import com.spring.service.AnimalCounterService;
import com.spring.service.CommonCodeService;
import com.spring.service.DetectionLogService;

import lombok.AllArgsConstructor;

@RestController
@AllArgsConstructor
@RequestMapping("/api/v1/ai")
public class AiIntegrationController {

    private final AnimalCounterService animalCounterService;
    private final DetectionLogService detectionLogService;
    private final CommonCodeService commonCodeService; // 공통코드 서비스 주입

    /**
     * [Pipeline 1] Flask가 실시간으로 목표 기준 마리수를 조회해가는 API
     * GET http://localhost:8080/api/v1/ai/targets
     */
    @GetMapping("/targets")
    public ResponseEntity<Map<String, Integer>> getAiTargetCounts() {
        Map<String, Integer> targetMap = new HashMap<>();
        try {
            // [교정] 프로젝트의 PageMaker 표준 규격에 완벽히 맞춤 설정
            PageMaker pm = new PageMaker();
            pm.setPage(1);           // 첫 번째 페이지 지정
            pm.setPerPageNum(100);   // 한 번에 100개의 축종 카운터를 가져오도록 세팅 (ROWNUM 잘림 방지)
            
            // 서비스 호출 시 전체 카운트 계산과 리스트 조회가 동시에 정상 처리됨
            List<AnimalCounterVO> counterList = animalCounterService.getAnimalCounterList(pm);
            
            if (counterList != null && !counterList.isEmpty()) {
                for (AnimalCounterVO vo : counterList) {
                    // 0=개, 1=고양이 코드를 Key로, 설정 마리수를 Value로 매핑
                    targetMap.put(String.valueOf(vo.getCounterId()), vo.getCurrentCount());
                }
            } else {
                targetMap.put("0", 0); // 개 기본값
                targetMap.put("1", 0); // 고양이 기본값
            }
            return new ResponseEntity<>(targetMap, HttpStatus.OK);
        } catch (Exception e) {
            System.err.println("❌ [AI API] PageMaker 연동 중 오라클 수량 조회 실패: " + e.getMessage());
            targetMap.put("0", 0);
            targetMap.put("1", 0);
            return new ResponseEntity<>(targetMap, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * [Pipeline 2] Flask(YOLO)가 미달 혹은 이상 객체 검출 시 경보 로그를 오라클로 인서트하는 API
     * POST http://localhost:8080/api/v1/ai/report-log
     */
    @PostMapping("/report-log")
    public ResponseEntity<Map<String, Object>> createDetectionLogFromAi(@RequestBody DetectionLogVO vo) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 실무 방어 코드: 드론 ID 기본값 매핑 (부모 테이블 외래키 제약조건 위배 방지)
            if (vo.getDroneId() == null || vo.getDroneId().isEmpty()) {
                vo.setDroneId("DRONE01"); // 실제 존재하는 드론 ID로 매핑 필요
            }
            
            // 기존 구현된 서비스 로직 호출 -> MyBatis insertDetectionLog 작동
            detectionLogService.registerDetectionLog(vo);
            
            response.put("status", "SUCCESS");
            response.put("message", "오라클 DB에 성공적으로 탐지 로그가 적재되었습니다.");
            return new ResponseEntity<>(response, HttpStatus.CREATED);
            
        } catch (Exception e) {
            System.err.println("❌ [AI API] 오라클 DB 로그 적재 실패: " + e.getMessage());
            response.put("status", "FAIL");
            response.put("error", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    /**
     * [Pipeline 3] Flask가 오라클 DB의 한글 명칭 데이터를 동적으로 조회해가는 API
     * GET http://localhost:8080/api/v1/ai/code-map
     */
    @GetMapping("/code-map")
    public ResponseEntity<Map<String, String>> getAnimalCodeMap() {
        Map<String, String> codeMap = new HashMap<>();
        try {
            // 제공해주신 30페이지 폼 이동 로직 규격 완벽 준수
            PageMaker pm = new PageMaker();
            pm.setSearchGrpCode("ANIMAL_TYPE");
            pm.setSearchUseYn("Y");
            
            // 오라클 DB에서 활성화된 축종 공통코드 리스트 조회
            List<CommonCodeVO> typeList = commonCodeService.getCommonCodeList(pm);
            
            if (typeList != null && !typeList.isEmpty()) {
                for (CommonCodeVO vo : typeList) {
                    // 예: vo.getCode()가 "0"이고 vo.getCodeName()이 "개"라면 -> {"0": "개"}
                    codeMap.put(vo.getCode(), vo.getCodeName()); 
                }
            } else {
                // DB에 데이터가 없을 때를 대비한 최소한의 백업 데이터
                codeMap.put("0", "개");
                codeMap.put("1", "고양이");
            }
            return new ResponseEntity<>(codeMap, HttpStatus.OK);
        } catch (Exception e) {
            System.err.println("❌ [AI API] 오라클 공통코드 매핑 실패: " + e.getMessage());
            codeMap.put("0", "개");
            codeMap.put("1", "고양이");
            return new ResponseEntity<>(codeMap, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
