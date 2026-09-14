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

    // 💡 독립 물리 경로 추출, 폴더 자동 생성 및 noImage.jpg 원스톱 복사 매핑
    private String getUploadPath(HttpServletRequest request) {
        String path = "C:" + File.separator + "upload" + File.separator + "member";
        File uploadDir = new File(path);
        
        // 1. 하드디스크에 물리 디렉토리가 없다면 자동 생성 (상위 폴더 포함)
        if (!uploadDir.exists()) {
            if (uploadDir.mkdirs()) {
                log.info("🚨 [시스템 알림] 회원 프로필 저장 물리 폴더가 자동으로 생성되었습니다: {}", path);
            }
        }
        
        // 2. 물리 경로에 noImage.jpg 기본 파일이 누락되었다면 자가 치유(자동 복사) 가동
        File noImageFile = new File(uploadDir, "noImage.jpg");
        if (!noImageFile.exists()) {
            // 프로젝트 내부의 원본 기본 스킨 이미지 경로 동적 추적
            jakarta.servlet.ServletContext context = request.getServletContext();
            String resourcePath = context.getRealPath("/resources/images/member/noImage.jpg");
            File originFile = new File(resourcePath);
            
            if (originFile.exists()) {
                try (InputStream in = new FileInputStream(originFile);
                     java.io.FileOutputStream out = new java.io.FileOutputStream(noImageFile)) {
                    
                    // IOUtils 활용으로 코드를 한 줄로 축소하여 원본 복제 완료
                    IOUtils.copy(in, out);
                    log.info("🎯 [자가치유 완료] C:\\upload\\member\\noImage.jpg 파일이 자동 복사 및 배포되었습니다.");
                    
                } catch (Exception e) {
                    log.error("회원 기본 이미지 복사 중 시스템 예외 발생: ", e);
                }
            } else {
                log.warn("⚠️ [주의] 프로젝트 내부에 원본 noImage.jpg 파일이 존재하지 않습니다.");
            }
        }
        
        return path;
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
                         @RequestParam(value = "popup", defaultValue = "false") boolean popup,
                         HttpServletRequest request) throws Exception {
        log.info("회원가입 요청 진입: 사번(아이디) = {}", member.getMemberId());
        
        member.setPicture("noImage.jpg"); 

        if (pictureFile != null && !pictureFile.isEmpty()) {
            String uploadPath = getUploadPath(request);
            try {
                String savedName = MultipartFileUpload.saveFile(uploadPath, pictureFile);
                member.setPicture(savedName);
                log.info("회원가입 프로필 사진 유틸리티 저장 성공: 파일명 = {}", savedName);
            } catch (Exception e) {
                log.warn("회원가입 중 파일 업로드 예외 발생 -> 기본 이미지 배치");
            }
        }
        
        memberService.regist(member);
        return popup ? "redirect:/member/list?popupSaved=true" : "redirect:/login"; 
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
     * 3. 사원 정보 수정 처리
     */
    @PostMapping("/modify")
    public String modify(MemberVO member,
                         @RequestParam(value = "pictureFile", required = false) MultipartFile pictureFile,
                         @RequestParam(value = "deleteOldPicture", defaultValue = "false") String deleteOldPicture,
                         @RequestParam(value = "popup", defaultValue = "false") boolean popup,
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
                String savedName = MultipartFileUpload.saveFile(uploadPath, oldPictureName, pictureFile);
                member.setPicture(savedName);
                log.info("새로운 프로필 사진 유틸리티 원스톱 물리 교체 성공: {}", savedName);
            } catch (Exception e) {
                log.error("수정 중 파일 업로드 실패 예외 발생: ", e);
                member.setPicture(oldPictureName); 
            }
            
        // [C] 사진 변경 처리를 하지 않은 경우 (기존 파일명 유지)
        } else {
            member.setPicture(oldPictureName); 
            log.info("기존 파일명 유지: {}", oldPictureName);
        }

        int result = memberService.modifyMember(member);
        if (result > 0) {
            return popup ? "redirect:/member/list?popupSaved=true"
                    : "redirect:/member/detail?memberId=" + member.getMemberId();
        } else {
            return "redirect:/member/modifyForm?memberId=" + member.getMemberId()
                    + "&error=true" + (popup ? "&popup=true" : "");
        }
    }
}
