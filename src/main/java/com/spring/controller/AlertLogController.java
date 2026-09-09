package com.spring.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.cmd.PageMaker;
import com.spring.dto.AlertLogVO;
import com.spring.dto.CommonCodeVO; // 기존 프로젝트의 공통코드 VO 경로로 맞추세요
import com.spring.service.AlertLogService;
import com.spring.service.CommonCodeService; // 기존 프로젝트의 공통코드 서비스 구조 매핑

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Controller
@RequestMapping("/alert")
@RequiredArgsConstructor
public class AlertLogController {

    private final AlertLogService alertLogService;
    
    // 💡 [추가] ALERT_TYPE 추출을 위한 공통 코드 서비스 계층 생성자 주입
    private final CommonCodeService commonCodeService;

    /**
     * 1. 경보 이력 목록 조회 (컨트롤러 단에서 공통 코드 이름 매핑 해결 버전)
     */
    @GetMapping("/list")
    public String list(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        log.info("컨트롤러 진입: list -> 파라미터 상태: {}", pageMaker);
        
        try {
            // 1. 기존 매퍼/서비스를 통해 원본 경보 목록 조회 (alertType은 'ALT01' 등 코드 상태)
            List<AlertLogVO> alertList = alertLogService.getAlertLogList(pageMaker);
            
            // 2. ALERT_TYPE에 해당하는 공통 코드 전체 목록을 가져옴
            PageMaker searchCodeCmd = new PageMaker();
            searchCodeCmd.setSearchGrpCode("ALERT_TYPE");
            List<CommonCodeVO> commonCodeList = commonCodeService.getCommonCodeList(searchCodeCmd);
            
            // 3. 자바 스트림(Stream)을 이용해 공통 코드를 [코드값 : 한글명] 형태의 Map으로 빠른 변환
            // 예: {"ALT01"="드론 상태 경보", "ALT02"="위험 동물 탐지", ...}
            java.util.Map<String, String> codeMap = commonCodeList.stream()
                .collect(java.util.stream.Collectors.toMap(
                    CommonCodeVO::getCode, 
                    CommonCodeVO::getCodeName,
                    (existing, replacement) -> existing // 중복 키 방어
                ));
            
            // 4. 경보 목록을 루프 돌며 alertType(코드)을 codeMap에서 찾아 한글명으로 덮어쓰기
            for (AlertLogVO vo : alertList) {
                String korName = codeMap.get(vo.getAlertType());
                if (korName != null) {
                    // VO의 alertType 필드에 한글 이름을 그대로 세팅 (새 필드 추가 필요 없음)
                    vo.setAlertType(korName); 
                }
            }
            
            // 5. 한글 변환이 완료된 최종 리스트를 바인딩
            model.addAttribute("alertList", alertList);
            
        } catch (Exception e) {
            log.error("경보 목록 조회 및 코드 변환 중 에러 발생: ", e);
            model.addAttribute("errorMessage", "데이터를 불러오는 중 오류가 발생했습니다.");
        }
        
        return "alert/alertList";
    }


    /**
     * 3. 신규 경보 이력 등록 화면 진입 (ALERT_TYPE 공통 코드 추출 적용)
     */
    @GetMapping("/register")
    public String registerForm(Model model) {
        log.info("컨트롤러 진입: registerForm -> ALERT_TYPE 공통 코드 로딩");
        
        try {
            // 보내주신 PageMaker 설계에 존재하던 'searchGrpCode' 파라미터 규칙과 일치하도록 세팅
            PageMaker searchCodeCmd = new PageMaker();
            searchCodeCmd.setSearchGrpCode("ALERT_TYPE"); // 💡 ALERT_TYPE 그룹 코드를 지정
            
            // 기존 프로젝트의 공통코드 조회 로직(예: getCodeList)을 호출하여 데이터 적재
            List<CommonCodeVO> alertTypeCodeList = commonCodeService.getCommonCodeList(searchCodeCmd);
            
            // JSP 화면단으로 리스트 주입
            model.addAttribute("alertTypeCodeList", alertTypeCodeList);
            
        } catch (Exception e) {
            log.error("ALERT_TYPE 공통 코드 조회 중 예외 발생: ", e);
            model.addAttribute("errorMessage", "경보 구분 코드를 불러오지 못했습니다.");
        }
        
        return "alert/alertRegister";
    }

    /**
     * 신규 경보 이력 등록 처리 (POST)
     */
    @PostMapping("/register")
    public String register(AlertLogVO vo, RedirectAttributes rttr) {
        try {
            alertLogService.registerAlertLog(vo);
            rttr.addFlashAttribute("result", "success");
        } catch (Exception e) {
            log.error("경보 등록 실패: ", e);
            rttr.addFlashAttribute("result", "fail");
        }
        return "redirect:/alert/list";
    }
    
    @GetMapping("/alertDetail")
    public String detail(@RequestParam("alertId") int alertId, Model model) {
        log.info("컨트롤러 진입: detail -> 요청 경보 ID: {}", alertId);
        try {
            AlertLogVO alert = alertLogService.getAlertLogDetail(alertId);
            
            //  [디테일 싱크 고도화] 상세 화면에서도 alertType 한글 변환 처리
            PageMaker searchCodeCmd = new PageMaker();
            searchCodeCmd.setSearchGrpCode("ALERT_TYPE");
            List<CommonCodeVO> commonCodeList = commonCodeService.getCommonCodeList(searchCodeCmd);
            
            java.util.Map<String, String> codeMap = commonCodeList.stream()
                .collect(java.util.stream.Collectors.toMap(
                    CommonCodeVO::getCode, 
                    CommonCodeVO::getCodeName,
                    (existing, replacement) -> existing
                ));
                
            String korName = codeMap.get(alert.getAlertType());
            if (korName != null) {
                alert.setAlertType(korName); // 한글 이름으로 덮어쓰기
            }

            model.addAttribute("alert", alert);
        } catch (Exception e) {
            log.error("경보 상세 조회 중 에러 발생: ", e);
            model.addAttribute("errorMessage", "존재하지 않거나 불러올 수 없는 경보 이력입니다.");
        }
        return "alert/alertDetail";
    }


}
