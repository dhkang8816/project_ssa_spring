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
import com.spring.dto.FlightHistoryVO;
import com.spring.dto.DroneVO;
import com.spring.service.DroneService;
import com.spring.service.FlightHistoryService;

import lombok.AllArgsConstructor;

@Controller
@RequestMapping("/flighthistory")
@AllArgsConstructor
public class FlightHistoryController {

    private final FlightHistoryService flightHistoryService;
    private final DroneService droneService;

    // 1. 비행 이력 페이징 목록 조회 (/flighthistory/list)
    @GetMapping("/list")
    public String flightHistoryList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        List<FlightHistoryVO> flightHistoryList = flightHistoryService.getFlightHistoryList(pageMaker);
        PageMaker dronePageMaker = new PageMaker();
        dronePageMaker.setPerPageNum(1000);
        List<DroneVO> droneList = droneService.getDroneList(dronePageMaker);
        
        model.addAttribute("flightHistoryList", flightHistoryList);
        model.addAttribute("droneList", droneList);
        return "flighthistory/flightHistoryList"; // WEB-INF/views/flighthistory/flightHistoryList.jsp 매핑
    }

    // 2. 비행 이력 단건 상세 조회 (/flighthistory/detail)
    @GetMapping("/detail")
    public String flightHistoryDetail(@RequestParam("flightId") int flightId, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        FlightHistoryVO vo = flightHistoryService.getFlightHistoryById(flightId);
        
        model.addAttribute("flightHistory", vo);
        return "flighthistory/flightHistoryDetail"; // WEB-INF/views/flighthistory/flightHistoryDetail.jsp 매핑
    }

    // 3. 잘못 적재된 비행 이력 정보 삭제 처리 (/flighthistory/remove)
    @PostMapping("/remove")
    public String remove(@RequestParam("flightId") int flightId, PageMaker pageMaker, RedirectAttributes rttr,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup) {
        flightHistoryService.removeFlightHistory(flightId);
        
        // 삭제 후 기존 페이징 및 검색 필터 유지 리다이렉트
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "REMOVE_SUCCESS");
        
        return popup ? "redirect:/flighthistory/list?popupSaved=true" : "redirect:/flighthistory/list";
    }
}
