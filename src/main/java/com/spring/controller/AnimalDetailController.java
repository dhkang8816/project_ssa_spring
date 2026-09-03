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
import com.spring.dto.AnimalCounterVO;
import com.spring.dto.AnimalDetailVO;
import com.spring.dto.CommonCodeVO;
import com.spring.service.AnimalCounterService;
import com.spring.service.AnimalDetailService;
import com.spring.service.CommonCodeService;

import lombok.AllArgsConstructor;

@Controller
@RequestMapping("/animal")
@AllArgsConstructor
public class AnimalDetailController {

    private final AnimalDetailService animalDetailService;
    // AnimalCounterService 주입을 상단 필드에 추가하셔야 합니다.
    private final AnimalCounterService animalCounterService;
    // 상단에 공통코드 서비스 주입이 필요합니다
    private final CommonCodeService commonCodeService;

    // 1. 동물 페이징 목록 조회 (/animal/list)
    @GetMapping("/list")
    public String animalList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        // 서비스 내부에서 전체 카운터 조회 및 페이징 계산이 동시에 처리됩니다.
        List<AnimalDetailVO> animalList = animalDetailService.getAnimalList(pageMaker);
        
        model.addAttribute("animalList", animalList);
        return "animal/animalList"; // WEB-INF/views/animal/list.jsp 매핑
    }

    // 2. 동물 등록 폼 화면 이동
    @GetMapping("/register")
    public String registerForm(Model model) throws Exception {
        // 💡 DB에서 'ANIMAL_TYPE' 그룹의 모든 활성화된 코드를 가져옵니다.
        PageMaker pm = new PageMaker();
        pm.setSearchGrpCode("ANIMAL_TYPE");
        pm.setSearchUseYn("Y");
        
        // 공통코드 서비스의 목록 조회 메서드 호출 (프로젝트의 실제 메서드명 확인 필요)
        List<CommonCodeVO> animalTypeList = commonCodeService.getCommonCodeList(pm);
        
        model.addAttribute("animalTypeList", animalTypeList);
        return "animal/animalRegister";
    }

    // 3. 동물 등록 처리 (/animal/register - POST)
    @PostMapping("/register")
    public String register(AnimalDetailVO vo, RedirectAttributes rttr) {
        animalDetailService.registerAnimal(vo);
        rttr.addFlashAttribute("msg", "REGISTER_SUCCESS");
        return "redirect:/animal/list";
    }

    // 4. 동물 상세 조회 및 수정 폼 이동
    @GetMapping("/detail")
    public String animalDetail(@RequestParam("animalId") int animalId, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
        AnimalDetailVO vo = animalDetailService.getAnimalById(animalId);
        
        // 💡 상세/수정 화면에도 똑같이 축종 목록을 실어 보냅니다.
        PageMaker pm = new PageMaker();
        pm.setSearchGrpCode("ANIMAL_TYPE");
        pm.setSearchUseYn("Y");
        List<CommonCodeVO> animalTypeList = commonCodeService.getCommonCodeList(pm);
        
        model.addAttribute("animal", vo);
        model.addAttribute("animalTypeList", animalTypeList);
        return "animal/animalDetail";
    }

    // 5. 동물 정보 수정 처리 (/animal/modify)
    @PostMapping("/modify")
    public String modify(AnimalDetailVO vo, PageMaker pageMaker, RedirectAttributes rttr) {
        animalDetailService.modifyAnimal(vo);
        
        // 수정 후 기존 페이징 정보 유지하며 리다이렉트
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "MODIFY_SUCCESS");
        
        return "redirect:/animal/list";
    }

    // 6. 동물 정보 삭제 처리 (/animal/remove)
    @PostMapping("/remove")
    public String remove(@RequestParam("animalId") int animalId, PageMaker pageMaker, RedirectAttributes rttr) {
        animalDetailService.removeAnimal(animalId);
        
        // 삭제 후 기존 페이징 정보 유지하며 리다이렉트
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "REMOVE_SUCCESS");
        
        return "redirect:/animal/list";
    }

    // 💡 [추가] 실시간 개체수 현황판 화면 이동 및 페이징 처리 (/animal/counterList)
    @GetMapping("/counterList")
    public String animalCounterList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        // PageMaker 연동 미래 확장형 서비스 호출
        List<AnimalCounterVO> counterList = animalCounterService.getAnimalCounterList(pageMaker);
        
        model.addAttribute("counterList", counterList);
        return "animal/animalCounterList"; // WEB-INF/views/animal/animalCounterList.jsp 매핑
    }

}
