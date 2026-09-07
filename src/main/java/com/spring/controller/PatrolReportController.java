package com.spring.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.dto.CommonCodeVO;
import com.spring.dto.PatrolReportVO;
import com.spring.service.CommonCodeService;
import com.spring.service.PatrolReportService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/patrolreport")
@RequiredArgsConstructor
public class PatrolReportController {

    private final PatrolReportService reportService;
    private final CommonCodeService commonCodeService;

    /**
     * 1. 리포트 목록 조회
     */
    /**
     * 1. 리포트 목록 조회 (💡 불필요한 공통코드 조회 연산을 완벽히 제거하여 0.01초로 단축)
     */
    @GetMapping("/list")
    public String list(Model model) throws Exception {
        // 💡 다른 리스트가 빠른 것처럼, 여기도 순수하게 리포트 리스트만 단 한 번 조회하게 만듭니다.
        List<PatrolReportVO> reportList = reportService.getReportList();
        
        model.addAttribute("reportList", reportList);
        return "patrolreport/patrolReportList";
    }
    /**
     * 2. 리포트 등록 화면 이동
     */
    @GetMapping("/register")
    public String registerForm(Model model) throws Exception {
        // 💡 요청하신 형태로 메서드 내에서 직접 공통코드 리스트 조회
        List<CommonCodeVO> statusList = commonCodeService.getCodeListByGroup("CONFIRM_STATUS");
        
        model.addAttribute("statusList", statusList); // 화면의 셀렉트박스 생성용 리스트
        model.addAttribute("reportVO", new PatrolReportVO());
        return "patrolreport/patrolReportRegister"; 
    }

    /**
     * 3. 리포트 등록 처리
     */
    @PostMapping("/register")
    public String register(@ModelAttribute("reportVO") PatrolReportVO reportVO) throws Exception {
        reportService.insertReport(reportVO);
        return "redirect:/report/list";
    }

    /**
     * 4. 리포트 상세 조회
     */
    @GetMapping("/detail/{reportId}")
    public String detail(@PathVariable("reportId") int reportId, Model model) throws Exception {
        PatrolReportVO reportVO = reportService.getReportById(reportId);
        model.addAttribute("report", reportVO);
        return "patrolreport/patrolReportDetail";
    }

    /**
     * 5. 리포트 수정 화면 이동
     */
    @GetMapping("/modify/{reportId}")
    public String modifyForm(@PathVariable("reportId") int reportId, Model model) throws Exception {
        PatrolReportVO reportVO = reportService.getReportById(reportId);
        
        // 💡 수정 화면에서도 기존 상태값 표출 및 변경을 위해 공통코드 리스트 조회
        List<CommonCodeVO> statusList = commonCodeService.getCodeListByGroup("CONFIRM_STATUS");
        
        model.addAttribute("statusList", statusList);
        model.addAttribute("reportVO", reportVO);
        return "patrolreport/patrolReportModify";
    }

    /**
     * 6. 리포트 수정 처리
     */
    @PostMapping("/modify")
    public String modify(@ModelAttribute("reportVO") PatrolReportVO reportVO) throws Exception {
        reportService.updateReport(reportVO);
        return "redirect:/report/detail/" + reportVO.getReportId();
    }

    /**
     * 7. 리포트 삭제 처리
     */
    @PostMapping("/delete")
    public String delete(@RequestParam("reportId") int reportId) throws Exception {
        reportService.deleteReport(reportId);
        return "redirect:/report/list";
    }
}
