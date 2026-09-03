package com.spring.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest; // Tomcat 10 사양 준수

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.cmd.PageMaker;
import com.spring.dto.CommonCodeVO;
import com.spring.dto.MemberVO;
import com.spring.service.CommonCodeService;
import com.spring.service.MemberService;
import com.spring.util.MultipartFileUpload; // 유틸리티 연동

import lombok.extern.log4j.Log4j2;

@Log4j2
@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private MemberService memberService;
    
    @Autowired
    private CommonCodeService commonCodeService;

    // 톰캣 내부 리소스 가상 배포 경로를 추출하는 메서드
    private String getUploadPath(HttpServletRequest request) {
        // 가상 배포 경로를 걷어내고, C드라이브 하드디스크 내부의 독립된 영구 폴더를 직접 바라보게 만듭니다.
        return "C:" + File.separator + "upload" + File.separator + "member";
    }

    // 회원가입 폼 이동
    @GetMapping("/registForm")
    public String registForm() {
        return "member/memberRegister"; 
    }

    /**
     * 1. 회원가입 처리
     */
    @PostMapping("/regist")
    public String regist(MemberVO member, 
                         @RequestParam(value = "pictureFile", required = false) MultipartFile pictureFile,
                         HttpServletRequest request) throws Exception {
        log.info("회원가입 요청 진입: 사번(아이디) = {}", member.getMemberId());
        
        member.setPicture("noImage.jpg"); 

        if (pictureFile != null && !pictureFile.isEmpty()) {
            String uploadPath = getUploadPath(request);
            try {
                // 💡 상위 Exception 구조로 우회 매핑하여 클래스 미검출 크래시 전면 차단
                String savedName = MultipartFileUpload.saveFile(uploadPath, pictureFile);
                member.setPicture(savedName);
                log.info("회원가입 프로필 사진 유틸리티 저장 성공: 파일명 = {}", savedName);
            } catch (Exception e) {
                log.warn("회원가입 중 파일 업로드 예외 발생 -> 기본 이미지 배치");
            }
        }
        
        memberService.regist(member);
        return "redirect:/login"; 
    }

    /**
     * 2. 이미지 스트림 출력 렌더링
     */
    @GetMapping("/getPicture")
    @ResponseBody
    public ResponseEntity<byte[]> getPicture(@RequestParam("id") String id, HttpServletRequest request) throws IOException {
        InputStream in = null;
        try {
            MemberVO member = memberService.getMemberById(id);
            String picture = (member == null || member.getPicture() == null) ? "noImage.jpg" : member.getPicture();
            
            String uploadPath = getUploadPath(request);
            File file = new File(uploadPath, picture);
            
            if (!file.exists()) {
                file = new File(uploadPath, "noImage.jpg");
            }
            
            in = new FileInputStream(file);
            return new ResponseEntity<byte[]>(IOUtils.toByteArray(in), HttpStatus.OK);
            
        } catch (Exception e) {
            log.error("이미지 스트림 전송 중 시스템 예외 발생: ", e);
            return new ResponseEntity<byte[]>(HttpStatus.NOT_FOUND);
        } finally {
            if (in != null) in.close();
        }
    }

    // 직원 목록 조회
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
        return "member/memberDetail"; 
    }
    
    // 사원 수정 폼 이동
    @GetMapping("/modifyForm")
    public String modifyForm(@RequestParam("memberId") String memberId, Model model) throws Exception {
        MemberVO member = memberService.getMemberById(memberId);
        
        List<CommonCodeVO> statusList = commonCodeService.getCodeListByGroup("ACCOUNT_STATUS"); 
        List<CommonCodeVO> roleList = commonCodeService.getCodeListByGroup("USER_ROLE");
        
        model.addAttribute("statusList", statusList); 
        model.addAttribute("roleList", roleList);
        model.addAttribute("member", member);
        
        return "member/memberModify";
    }

    /**
     * 3. 사원 정보 수정 처리 (💡 크래시 차단 마감본)
     */
    @PostMapping("/modify")
    public String modify(MemberVO member,
                         @RequestParam(value = "pictureFile", required = false) MultipartFile pictureFile,
                         @RequestParam(value = "deleteOldPicture", defaultValue = "false") String deleteOldPicture,
                         HttpServletRequest request) throws Exception {
        
        log.info("직원 정보 수정 요청 최종 진입: 사번 = {}, 사진삭제플래그 = {}", member.getMemberId(), deleteOldPicture);
        
        MemberVO oldMember = memberService.getMemberById(member.getMemberId());
        String oldPictureName = oldMember.getPicture();
        String uploadPath = getUploadPath(request);
        
        // [A] 사진 삭제 버튼을 누른 경우
        if ("true".equals(deleteOldPicture)) {
            File oldFile = new File(uploadPath, oldPictureName);
            if (oldFile.exists() && !oldPictureName.equals("noImage.jpg")) {
                oldFile.delete();
            }
            member.setPicture("noImage.jpg");
            log.info("프로필 사진 삭제 처리 성공");
            
        // [B] 새로운 사진 파일이 정상 업로드된 경우
        } else if (pictureFile != null && !pictureFile.isEmpty()) {
            try {
                // 교정된 유틸리티 메서드를 안전하게 호출 (원스톱으로 기존 파일 삭제 및 신규 저장 완료)
                String savedName = MultipartFileUpload.saveFile(uploadPath, oldPictureName, pictureFile);
                member.setPicture(savedName);
                log.info("새로운 프로필 사진 유틸리티 원스톱 물리 교체 성공: {}", savedName);
            } catch (Exception e) {
                log.error("수정 중 파일 업로드 실패 예외 발생: ", e);
                member.setPicture(oldPictureName); // 에러 발생 시 원본 이미지명 유지 대피
            }
            
        // [C] 사진 변경 처리를 하지 않은 경우 (기존 파일명 유지)
        } else {
            member.setPicture(oldPictureName); 
            log.info("기존 파일명 유지: {}", oldPictureName);
        }

        // MyBatis 수정을 거쳐 최종 상세화면으로 리다이렉트
        int result = memberService.modifyMember(member);
        if (result > 0) {
            return "redirect:/member/detail?memberId=" + member.getMemberId();
        } else {
            return "redirect:/member/modifyForm?memberId=" + member.getMemberId() + "&error=true";
        }
    }

}
