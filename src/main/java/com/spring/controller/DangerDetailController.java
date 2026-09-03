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
import com.spring.service.DangerDetailService;

import lombok.AllArgsConstructor;

@Controller
@RequestMapping("/danger")
@AllArgsConstructor
public class DangerDetailController {

    private final DangerDetailService dangerDetailService;

    // 1. 이상 객체 페이징 목록 조회 (/danger/list)
    @GetMapping("/list")
    public String dangerList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        List<DangerDetailVO> dangerList = dangerDetailService.getDangerList(pageMaker);
        
        model.addAttribute("dangerList", dangerList);
        return "danger/dangerList"; // WEB-INF/views/danger/dangerList.jsp 매핑
    }

    // 2. 이상 객체 등록 폼 이동 (/danger/register - GET)
    @GetMapping("/register")
    public String registerForm() {
        return "danger/dangerRegister"; // WEB-INF/views/danger/dangerRegister.jsp 매핑
    }

    // 3. 이상 객체 등록 처리 (/danger/register - POST)
    // [DangerDetailController.java] 신규 객체 등록 처리 고도화
    @PostMapping("/register")
    public String register(DangerDetailVO ddv, Model model) {
        
        // 💡 [중복 에러 처리] 이미 마스터에 존재하는 이름인지 유효성 검증 수행
        PageMaker pm = new PageMaker();
        pm.setSearchType("n"); // 이름 검색 조건 바인딩
        pm.setKeyword(ddv.getDangerName()); // 사용자가 화면에 입력한 이름
        
        // 아까 만들어둔 selectDangerCount 메서드를 재활용하여 중복 건수를 조회합니다.
        int existCount = dangerDetailService.getDangerList(pm).size(); 
        
        if (existCount > 0) {
            // 중복된 이름이 있다면 공통 alert 화면으로 넘겨서 정중히 튕겨냅니다.
            model.addAttribute("message", "⚠️ '" + ddv.getDangerName() + "'은(는) 이미 마스터에 등록된 이상 객체입니다.");
            // redirectUrl을 적지 않으면 자동으로 jsp단에서 history.back()이 실행되어 입력창 내용이 보존됩니다!
            return "common/message"; 
        }

        // 중복 검사를 무사히 통과했을 때만 오라클 DB에 최종 저장 실행
        dangerDetailService.registerDanger(ddv);
        return "redirect:/danger/list";
    }


    // 4. 이상 객체 상세 조회 및 수정 폼 이동 (/danger/detail)
    @GetMapping("/detail")
    public String dangerDetail(@RequestParam("dangerId") int dangerId, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        DangerDetailVO vo = dangerDetailService.getDangerById(dangerId);
        
        model.addAttribute("danger", vo);
        return "danger/dangerDetail"; // WEB-INF/views/danger/dangerDetail.jsp 매핑
    }

    // 5. 이상 객체 정보 수정 처리 (/danger/modify)
    @PostMapping("/modify")
    public String modify(DangerDetailVO ddv, PageMaker pageMaker, RedirectAttributes rttr) {
        dangerDetailService.modifyDanger(ddv);
        
        // 수정 후 기존 페이징 및 검색 조건 유지
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "MODIFY_SUCCESS");
        
        return "redirect:/danger/list";
    }

    // 6. 이상 객체 정보 삭제 처리 (/danger/remove)
    @PostMapping("/remove")
    public String remove(@RequestParam("dangerId") int dangerId, PageMaker pageMaker, RedirectAttributes rttr) {
        dangerDetailService.removeDanger(dangerId);
        
        // 삭제 후 기존 페이징 및 검색 조건 유지
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "REMOVE_SUCCESS");
        
        return "redirect:/danger/list";
    }
}
