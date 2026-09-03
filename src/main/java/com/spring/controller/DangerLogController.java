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
import com.spring.dto.DangerDetailVO;
import com.spring.dto.DangerLogVO;
import com.spring.service.DangerDetailService;
import com.spring.service.DangerLogService;

import lombok.AllArgsConstructor;

@Controller
@RequestMapping("/dangerlog")
@AllArgsConstructor
public class DangerLogController {

    private final DangerLogService dangerLogService;
    private final DangerDetailService dangerDetailService;

    // 1. 관제 탐지 로그 페이징 목록 조회 (/dangerlog/list)
    // 💡 [DangerLogController.java] 시스템 코드 스타일 매핑 고도화
    @GetMapping("/list")
    public String dangerLogList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        
        // A. 먼저 실시간 탐지 로그 원본 리스트를 가져옵니다 (조인 없는 순수 고속 쿼리)
        List<DangerLogVO> dangerLogList = dangerLogService.getDangerLogList(pageMaker);
        
        // B. 시스템 공통코드를 긁어오듯 이상객체 마스터 전체 목록을 넉넉하게 긁어옵니다.
        PageMaker pm = new PageMaker();
        pm.setPerPageNum(1000);
        List<DangerDetailVO> dangerMasterList = dangerDetailService.getDangerList(pm);
        
        // C. 💡 [핵심] 마스터 데이터를 시스템 코드 맵(Map) 구조로 변환 (Key: ID, Value: 이름)
        java.util.Map<Integer, String> dangerCodeMap = new java.util.HashMap<>();
        for (DangerDetailVO master : dangerMasterList) {
            dangerCodeMap.put(master.getDangerId(), master.getDangerName());
        }
        
        // D. 탐지 로그들을 루프 돌며 시스템 코드 맵에서 이름을 찾아 자바단에서 바인딩!
        for (DangerLogVO log : dangerLogList) {
            // 시스템 코드 저장소(Map)에서 숫자에 매핑된 진짜 이름을 꺼내옵니다.
            String matchedName = dangerCodeMap.get(log.getDangerType());
            
            // 만약 마스터에 매핑된 이름이 없다면 '미등록객체(ID)'로 안전 처리
            if (matchedName == null) {
                log.setDangerName("미등록객체(" +  log.getDangerType() + ")");
            } else {
                log.setDangerName(matchedName);
            }
        }
        
        model.addAttribute("dangerLogList", dangerLogList);
        return "dangerlog/dangerLogList"; 
    }


    // 2. 관제 탐지 로그 상세 조회 및 조치 입력 폼 이동 (/dangerlog/detail)
    // 💡 상세 보기에서도 동일하게 마스터 시스템 코드를 매핑해 줍니다.
    // 💡 DangerLogController.java 내부의 detail 메서드를 아래 내용으로 대체
    @GetMapping("/detail")
    public String dangerLogDetail(@RequestParam("danlogId") int danlogId, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        
        // 1. 단건 상세 로그 원본 데이터 조회
        DangerLogVO log = dangerLogService.getDangerLogById(danlogId);
        
        // 2. 💡 [목록과 100% 동일화] 마스터 전체 목록을 가져와 시스템 코드 맵 구조 생성
        PageMaker pm = new PageMaker();
        pm.setPerPageNum(1000);
        List<DangerDetailVO> dangerMasterList = dangerDetailService.getDangerList(pm);
        
        java.util.Map<Integer, String> dangerCodeMap = new java.util.HashMap<>();
        for (DangerDetailVO master : dangerMasterList) {
            dangerCodeMap.put(master.getDangerId(), master.getDangerName());
        }
        
        // 3. 💡 목록(List)과 완벽히 똑같은 맵 매핑 알고리즘 적용
        String matchedName = dangerCodeMap.get(log.getDangerType());
        if (matchedName == null) {
            log.setDangerName("미등록객체(" + log.getDangerType() + ")");
        } else {
            log.setDangerName(matchedName);
        }
        
        model.addAttribute("dangerLog", log);
        return "dangerlog/dangerLogDetail";
    }



    // 3. 관제원 현장 조치 상태 및 사유 업데이트 처리 (/dangerlog/modify)
    @PostMapping("/modify")
    public String modifyDactionStatus(DangerLogVO dlv, PageMaker pageMaker, RedirectAttributes rttr) {
        dangerLogService.modifyDactionStatus(dlv);
        
        // 조치 업데이트 후 기존 페이징 및 검색 필터 유지 리다이렉트
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "MODIFY_SUCCESS");
        
        return "redirect:/dangerlog/list";
    }
}
