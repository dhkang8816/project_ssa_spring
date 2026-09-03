package com.spring.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.cmd.PageMaker;
import com.spring.dto.CommonCodeVO;
import com.spring.dto.MemberVO;
import com.spring.service.CommonCodeService;
import com.spring.service.MemberService;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private MemberService memberService;
    
    @Autowired
    private CommonCodeService commonCodeService;

    // 회원가입 폼 이동
    @GetMapping("/registForm")
    public String registForm() {
        return "member/memberRegister"; // 💡 memberRegist.jsp로 매핑
    }

    // 회원가입 처리
    @PostMapping("/regist")
    public String regist(MemberVO member) throws Exception {
        memberService.regist(member);
        return "redirect:/login"; 
    }

    // 직원 목록 조회 (페이징 적용)
    @GetMapping("/list")
    public String getMemberList(PageMaker pageMaker, Model model) throws Exception {
        int totalCount = memberService.getMemberListCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        
        List<MemberVO> memberList = memberService.getMemberList(pageMaker);
        
        model.addAttribute("memberList", memberList);
        model.addAttribute("pageMaker", pageMaker);
        
        return "member/memberList";
    }

    // 직원 상세 조회
    @GetMapping("/detail")
    public String getMemberDetail(@RequestParam("memberId") String memberId, Model model) throws Exception {
        MemberVO member = memberService.getMemberById(memberId);
        model.addAttribute("member", member);
        return "member/memberDetail"; // 💡 memberDetail.jsp로 매핑
    }
    
    // 사원 수정 폼 페이지 이동 (GET)
    @GetMapping("/modifyForm")
    public String modifyForm(@RequestParam("memberId") String memberId, Model model) throws Exception {
        MemberVO member = memberService.getMemberById(memberId);
        
        // 💡 계정 상태 공통 코드 목록 조회 (그룹 코드가 'ACCOUNT STATUS' 또는 'USER STATUS'인지 확인 필요)
        List<CommonCodeVO> statusList = commonCodeService.getCodeListByGroup("ACCOUNT_STATUS"); 
        List<CommonCodeVO> roleList = commonCodeService.getCodeListByGroup("USER_ROLE");
        
        model.addAttribute("statusList", statusList); // 👈 뷰로 상태 목록 전달
        model.addAttribute("roleList", roleList);
        model.addAttribute("member", member);
        
        return "member/memberModify";
    }

    // 사원 정보 수정 처리 (POST)
    @PostMapping("/modify")
    public String modify(MemberVO member) throws Exception {
        int result = memberService.modifyMember(member);
        if (result > 0) {
            // 수정 성공 시 상세 페이지로 이동
            return "redirect:/member/detail?memberId=" + member.getMemberId();
        } else {
            // 실패 시 수정 폼 또는 에러 페이지로 유도
            return "redirect:/member/modifyForm?memberId=" + member.getMemberId() + "&error=true";
        }
    }
}