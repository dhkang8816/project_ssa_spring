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
import com.spring.dto.DroneVO;
import com.spring.dto.MemberVO;
import com.spring.service.DroneService;
import com.spring.service.MemberService;

import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
@RequestMapping("/drone")
public class DroneController {

    private final DroneService droneService;
    private final MemberService memberService;

    // 1. 드론 페이징 목록 조회 (/drone/list)
    @GetMapping("/list")
    public String droneList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        List<DroneVO> droneList = droneService.getDroneList(pageMaker);
        
        model.addAttribute("droneList", droneList);
        return "drone/droneList"; // WEB-INF/views/drone/droneList.jsp 매핑
    }

    @GetMapping("/register")
    public String registerForm(Model model) throws Exception {
        // 직원 목록을 넉넉하게 가져오기 위해 perPageNum을 크게 잡은 임시 PageMaker 세팅
        PageMaker pm = new PageMaker();
        pm.setPerPageNum(1000); 
        
        // 실제 가입된 직원 리스트를 전원 긁어와 model에 담아 보냅니다.
        List<MemberVO> memberList = memberService.getMemberList(pm);
        
        model.addAttribute("memberList", memberList);
        return "drone/droneRegister";
    }
    
    // 💡 오직 이 Model 기반 튜닝 메서드 하나만 남겨두셔야 중복 매핑(Ambiguous)이 해결됩니다.
    @PostMapping("/register")
    public String register(DroneVO dvo, Model model,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup) throws Exception {
        
        // 1. 이미 존재하는 드론 ID 중복 체크
        DroneVO existDrone = droneService.getDroneById(dvo.getDroneId());
        if (existDrone != null) {
            model.addAttribute("message", "⚠️ 이미 등록된 드론 기체 ID입니다. 다시 확인해 주세요.");
            return "common/message"; 
        }
        
        // 2. 담당자 사번을 입력했을 때만 실제 존재하는 사번인지 유효성 검증 수행
        if (dvo.getMemberId() != null && !dvo.getMemberId().trim().equals("")) {
            MemberVO member = memberService.getMemberById(dvo.getMemberId());
            
            if (member == null) {
                model.addAttribute("message", "❌ 존재하지 않는 관제원 사번입니다. 올바른 사번을 입력해 주세요.");
                return "common/message";
            }
        }

        // 3. 중복 및 유효성 검사를 모두 통과하면 드론 등록 실행
        droneService.registerDrone(dvo);
        return popup ? "redirect:/drone/list?popupSaved=true" : "redirect:/drone/list";
    }


    // 4. 드론 상세 조회 및 배정 수정 폼 이동 (/drone/detail)
    @GetMapping("/detail")
    public String droneDetail(@RequestParam("droneId") String droneId, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
        DroneVO vo = droneService.getDroneById(droneId);
        
        // 수정 창에서도 똑같이 직원 풀을 select 박스에 뿌리기 위해 목록 조회
        PageMaker pm = new PageMaker();
        pm.setPerPageNum(1000);
        List<MemberVO> memberList = memberService.getMemberList(pm);
        
        model.addAttribute("drone", vo);
        model.addAttribute("memberList", memberList);
        return "drone/droneDetail";
    }

    // 5. 드론 배정 정보 수정 처리 (/drone/modify)
    @PostMapping("/modify")
    public String modify(DroneVO dvo, PageMaker pageMaker, RedirectAttributes rttr) {
        droneService.modifyDrone(dvo);
        
        // 수정 후 기존 페이징 및 검색 조건 유지 리다이렉트
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "MODIFY_SUCCESS");
        
        return "redirect:/drone/list";
    }

    // 6. 드론 정보 삭제 처리 (/drone/remove)
    @PostMapping("/remove")
    public String remove(@RequestParam("droneId") String droneId, PageMaker pageMaker, RedirectAttributes rttr) {
        droneService.removeDrone(droneId);
        
        // 삭제 후 기존 페이징 및 검색 조건 유지 리다이렉트
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "REMOVE_SUCCESS");
        
        return "redirect:/drone/list";
    }
}
