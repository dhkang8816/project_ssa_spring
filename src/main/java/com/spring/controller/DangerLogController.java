package com.spring.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.IOUtils; // 💡 아파치 commons 라이브러리 연동
import org.springframework.beans.factory.annotation.Autowired; // 💡 프로젝트 스타일 동기화
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
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
import com.spring.dto.CommonCodeVO;
import com.spring.dto.DangerDetailVO;
import com.spring.dto.DangerLogVO;
import com.spring.service.CommonCodeService;
import com.spring.service.DangerDetailService;
import com.spring.service.DangerLogService;
import com.spring.util.RuntimeSettings;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest; // 💡 Tomcat 10 사양 완벽 준수
import lombok.extern.log4j.Log4j2; // 💡 로그 어노테이션 통합 완료

@Log4j2
@Controller
@RequestMapping("/dangerlog")
public class DangerLogController {

    private static final String SNAPSHOT_UPLOAD_ROOT = RuntimeSettings.text("SSA_UPLOAD_ROOT", "C:" + File.separator + "upload");

    @Autowired
    private DangerLogService dangerLogService;
    
    @Autowired
    private DangerDetailService dangerDetailService;

    @Autowired
    private CommonCodeService commonCodeService;

    // 💡 이상개체 스냅샷 보관용 독립 영구 물리 디렉토리 경로 추출 및 noImage.jpg 자동 복사 메서드
    private String getUploadPath(HttpServletRequest request) {
        String path = new File(SNAPSHOT_UPLOAD_ROOT, "dangerlog").getPath();
        
        File uploadDir = new File(path);
        // 1. 디렉토리가 없다면 전체 자동 생성 (상위 폴더 포함)
        if (!uploadDir.exists()) {
            if (uploadDir.mkdirs()) {
                log.info("🚨 [시스템 알림] 이상객체 스냅샷 저장 물리 폴더가 자동으로 생성되었습니다: {}", path);
            }
        }
        
        // 2. 💡 [누락 복구] noImage.jpg 자동 파일 자가 치유(복사) 가동
        File noImageFile = new File(uploadDir, "noImage.jpg");
        if (!noImageFile.exists()) {
            // 프로젝트 내부(/resources/images/member/noImage.jpg) 원본 경로 지정
            ServletContext context = request.getServletContext();
            String resourcePath = context.getRealPath("/resources/images/member/noImage.jpg");
            File originFile = new File(resourcePath);
            
            if (originFile.exists()) {
                try (InputStream in = new FileInputStream(originFile);
                     FileOutputStream out = new FileOutputStream(noImageFile)) {
                    
                    // IOUtils를 활용하여 단 한 줄로 원본 이미지를 C드라이브로 안전하게 복사 생성!
                    IOUtils.copy(in, out);
                    log.info("🎯 [자가치유 완료] C:\\upload\\dangerlog\\noImage.jpg 파일이 자동 배포되었습니다.");
                    
                } catch (Exception e) {
                    log.error("기본 이미지 복사 중 시스템 예외 발생: ", e);
                }
            } else {
                log.warn("⚠️ [주의] 프로젝트 내부에 원본 noImage.jpg 파일이 존재하지 않습니다.");
            }
        }
        
        return path;
    }

    // 1. 관제 탐지 로그 페이징 목록 조회 (/dangerlog/list)
    @GetMapping("/list")
    public String dangerLogList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
        
        // A. 먼저 실시간 탐지 로그 원본 리스트를 가져옵니다 (조인 없는 순수 고속 쿼리)
        List<DangerLogVO> dangerLogList = dangerLogService.getDangerLogList(pageMaker);
        
        // B. 시스템 공통코드를 긁어오듯 이상객체 마스터 전체 목록을 넉넉하게 긁어옵니다.
        PageMaker pm = new PageMaker();
        pm.setPerPageNum(1000);
        List<DangerDetailVO> dangerMasterList = dangerDetailService.getDangerList(pm);
        
        // C. 마스터 데이터를 시스템 코드 맵(Map) 구조로 변환 (Key: ID, Value: 이름)
        Map<Integer, String> dangerCodeMap = new HashMap<>();
        for (DangerDetailVO master : dangerMasterList) {
            dangerCodeMap.put(master.getDangerId(), master.getDangerName());
        }
        
        // D. 탐지 로그들을 루프 돌며 시스템 코드 맵에서 이름을 찾아 자바단에서 바인딩!
        for (DangerLogVO log : dangerLogList) {
            String matchedName = dangerCodeMap.get(log.getDangerType());
            
            if (matchedName == null) {
                log.setDangerName("미등록객체(" +  log.getDangerType() + ")");
            } else {
                log.setDangerName(matchedName);
            }
        }

        PageMaker actionStatusPageMaker = new PageMaker();
        actionStatusPageMaker.setSearchGrpCode("ACTION_STATUS");
        actionStatusPageMaker.setSearchUseYn("Y");
        actionStatusPageMaker.setPerPageNum(1000);
        Map<String, String> actionStatusNames = new HashMap<>();
        for (CommonCodeVO code : commonCodeService.getCommonCodeList(actionStatusPageMaker)) {
            actionStatusNames.put(code.getCode(), code.getCodeName());
        }
        
        model.addAttribute("dangerLogList", dangerLogList);
        model.addAttribute("actionStatusNames", actionStatusNames);
        return "dangerlog/dangerLogList"; 
    }

    // 2. 관제 탐지 로그 상세 조회 및 조치 입력 폼 이동 (/dangerlog/detail)
    @GetMapping("/detail")
    public String dangerLogDetail(@RequestParam("danlogId") int danlogId, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
        
        // 1. 단건 상세 로그 원본 데이터 조회
        DangerLogVO log = dangerLogService.getDangerLogById(danlogId);
        
        // 2. 마스터 전체 목록을 가져와 시스템 코드 맵 구조 생성
        PageMaker pm = new PageMaker();
        pm.setPerPageNum(1000);
        List<DangerDetailVO> dangerMasterList = dangerDetailService.getDangerList(pm);
        
        Map<Integer, String> dangerCodeMap = new HashMap<>();
        for (DangerDetailVO master : dangerMasterList) {
            dangerCodeMap.put(master.getDangerId(), master.getDangerName());
        }
        
        // 3. 목록(List)과 완벽히 똑같은 맵 매핑 알고리즘 적용
        String matchedName = dangerCodeMap.get(log.getDangerType());
        if (matchedName == null) {
            log.setDangerName("미등록객체(" + log.getDangerType() + ")");
        } else {
            log.setDangerName(matchedName);
        }
        
        model.addAttribute("dangerLog", log);
        model.addAttribute("actionStatusList", commonCodeService.getCodeListByGroup("ACTION_STATUS"));
        return "dangerlog/dangerLogDetail";
    }

    // 3. 관제원 현장 조치 상태 및 사유 업데이트 처리 (/dangerlog/modify)
    @PostMapping("/modify")
    public String modifyDactionStatus(DangerLogVO dlv, PageMaker pageMaker, RedirectAttributes rttr,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup) {
        dangerLogService.modifyDactionStatus(dlv);
        
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "MODIFY_SUCCESS");
        
        return popup ? "redirect:/dangerlog/list?popupSaved=true" : "redirect:/dangerlog/list";
    }

    /**
     * 4. 💡 [신규 추가] 이상객체 스냅샷 이미지 스트림 출력 (DangerLogVO dsnapshotPath 연동)
     */
    @GetMapping("/getDangerSnapshot")
    @ResponseBody
    public ResponseEntity<byte[]> getDangerSnapshot(@RequestParam("danlogId") int danlogId, HttpServletRequest request) throws IOException {
        InputStream in = null;
        try {
            // 1. 이상객체 서비스(dangerLogService)를 통해 DB에서 상세 정보를 조회합니다.
            DangerLogVO vo = dangerLogService.getDangerLogById(danlogId);
            
            // 2. DB의 dsnapshotPath 변수명 검증 및 대치 (빈 값이면 noImage.jpg)
            String fileName = (vo == null || vo.getDsnapshotPath() == null || vo.getDsnapshotPath().isEmpty()) 
                              ? "noImage.jpg" : vo.getDsnapshotPath();
            
            // 3. 미달 감지와 동일하게 컨트롤러 내부의 getUploadPath를 호출하여 물리 경로를 얻어옵니다.
            String uploadPath = getUploadPath(request);
            File file = new File(uploadPath, fileName);
            // 4. 실물 파일이 폴더에 없을 경우 noImage.jpg로 우회 방어선 구축
            if (!file.exists()) {
                file = new File(uploadPath, "noImage.jpg");
            }
            
            in = new FileInputStream(file);
            
            // 5. 브라우저가 이미지(JPEG)로 올바르게 인지하도록 Content-Type 헤더 명시 추가 (더 안전함)
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_JPEG);
            
            return new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.OK);
            
        } catch (Exception e) {
            log.error("이상객체 스냅샷 이미지 스트림 전송 중 예외 발생: ", e);
            return new ResponseEntity<byte[]>(HttpStatus.NOT_FOUND);
        } finally {
            if (in != null) in.close();
        }
    }

}
