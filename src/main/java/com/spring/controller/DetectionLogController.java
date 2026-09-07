package com.spring.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest; // 💡 Tomcat 10 사양 완벽 준수

import org.apache.commons.io.IOUtils; // 💡 아파치 commons 라이브러리 연동
import org.springframework.beans.factory.annotation.Autowired; // 💡 Member 쪽과 스타일 동기화
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.cmd.PageMaker;
import com.spring.dto.DetectionLogVO;
import com.spring.service.DetectionLogService;

import lombok.extern.log4j.Log4j2; // 💡 로그 어노테이션 추가

@Log4j2
@Controller
@RequestMapping("/detection")
public class DetectionLogController {

    @Autowired
    private DetectionLogService detectionLogService; // 💡 깔끔하게 의존성 주입 구조 변경

    // 독립된 영구 물리 디렉토리 경로 추출 및 자가 치유 메서드
    private String getUploadPath(HttpServletRequest request) {
        String path = "C:" + File.separator + "upload" + File.separator + "detection";
        File uploadDir = new File(path);
        if (!uploadDir.exists()) {
            if (uploadDir.mkdirs()) {
                log.info("🚨 [시스템 알림] 관제 탐지 스냅샷 저장 물리 폴더가 자동으로 생성되었습니다: {}", path);
            }
        }
        
        File noImageFile = new File(uploadDir, "noImage.jpg");
        if (!noImageFile.exists()) {
            jakarta.servlet.ServletContext context = request.getServletContext();
            String resourcePath = context.getRealPath("/resources/images/member/noImage.jpg");
            File originFile = new File(resourcePath);
            if (originFile.exists()) {
                try (InputStream in = new FileInputStream(originFile);
                     java.io.FileOutputStream out = new java.io.FileOutputStream(noImageFile)) {
                    IOUtils.copy(in, out);
                    log.info("🎯 [자가치유 완료] C:\\upload\\detection\\noImage.jpg 파일이 자동 배포되었습니다.");
                } catch (Exception e) { log.error("이미지 복사 실패: ", e); }
            }
        }
        return path;
    }

    // 1. 관제 탐지 로그 페이징 목록 조회 (/detection/list)
    @GetMapping("/list")
    public String detectionList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        List<DetectionLogVO> detectionList = detectionLogService.getDetectionLogList(pageMaker);
        
        model.addAttribute("detectionList", detectionList);
        return "detection/detectionList"; 
    }

    // 2. 관제 탐지 로그 상세 조회 및 조치 입력 폼 이동 (/detection/detail)
    @GetMapping("/detail")
    public String detectionDetail(@RequestParam("dlogId") int dlogId, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        DetectionLogVO vo = detectionLogService.getDetectionLogById(dlogId);
        
        model.addAttribute("detection", vo);
        return "detection/detectionDetail"; 
    }

    // 3. 관제원 현장 조치 상태 및 사유 업데이트 처리 (/detection/modify)
    @PostMapping("/modify")
    public String modifyActionStatus(DetectionLogVO dlv, PageMaker pageMaker, RedirectAttributes rttr) {
        detectionLogService.modifyActionStatus(dlv);
        
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "MODIFY_SUCCESS");
        
        return "redirect:/detection/list";
    }

    /**
     * 4. 💡 탐지 스냅샷 이미지 스트림 출력 (오라클 DB snapshotPath 완벽 연동)
     */
    @GetMapping("/getSnapshot")
    @ResponseBody
    public ResponseEntity<byte[]> getSnapshot(@RequestParam("dlogId") int dlogId, HttpServletRequest request) throws IOException {
        InputStream in = null;
        try {
            DetectionLogVO vo = detectionLogService.getDetectionLogById(dlogId);
            
            // DB의 snapshotPath 검증 및 대치
            String fileName = (vo == null || vo.getSnapshotPath() == null || vo.getSnapshotPath().isEmpty()) 
                              ? "noImage.jpg" : vo.getSnapshotPath();
            
            // 💡 [교정] getUploadPath 호출 시 request 아규먼트를 정상 전송
            String uploadPath = getUploadPath(request);
            File file = new File(uploadPath, fileName);
            
            // 실물 파일 없을 시 하드디스크 폭발 방지 대피선 구축
            if (!file.exists()) {
                file = new File(uploadPath, "noImage.jpg");
            }
            
            in = new FileInputStream(file);
            return new ResponseEntity<byte[]>(IOUtils.toByteArray(in), HttpStatus.OK);
            
        } catch (Exception e) {
            log.error("스냅샷 이미지 스트림 전송 중 예외 발생: ", e);
            return new ResponseEntity<byte[]>(HttpStatus.NOT_FOUND);
        } finally {
            if (in != null) in.close();
        }
    }
}
