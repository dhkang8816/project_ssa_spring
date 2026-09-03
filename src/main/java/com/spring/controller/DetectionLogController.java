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
import com.spring.dto.DetectionLogVO;
import com.spring.service.DetectionLogService;

import lombok.AllArgsConstructor;

@Controller
@RequestMapping("/detection")
@AllArgsConstructor
public class DetectionLogController {

    private final DetectionLogService detectionLogService;

    // 1. 관제 탐지 로그 페이징 목록 조회 (/detection/list)
    @GetMapping("/list")
    public String detectionList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        List<DetectionLogVO> detectionList = detectionLogService.getDetectionLogList(pageMaker);
        
        model.addAttribute("detectionList", detectionList);
        return "detection/detectionList"; // WEB-INF/views/detection/detectionList.jsp 매핑
    }

    // 2. 관제 탐지 로그 상세 조회 및 조치 입력 폼 이동 (/detection/detail)
    @GetMapping("/detail")
    public String detectionDetail(@RequestParam("dlogId") int dlogId, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        DetectionLogVO vo = detectionLogService.getDetectionLogById(dlogId);
        
        model.addAttribute("detection", vo);
        return "detection/detectionDetail"; // WEB-INF/views/detection/detectionDetail.jsp 매핑
    }

    // 3. 관제원 현장 조치 상태 및 사유 업데이트 처리 (/detection/modify)
    @PostMapping("/modify")
    public String modifyActionStatus(DetectionLogVO dlv, PageMaker pageMaker, RedirectAttributes rttr) {
        detectionLogService.modifyActionStatus(dlv);
        
        // 조치 업데이트 후 기존 페이징 및 검색 필터 유지 리다이렉트
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "MODIFY_SUCCESS");
        
        return "redirect:/detection/list";
    }
}
