package com.spring.service;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.DangerLogVO;

public interface DangerLogService {

    // 1. 관제 탐지 로그 등록 (dlv 명명 규칙 반영)
    public void registerDangerLog(DangerLogVO dlv);
    
    // 2. 페이징 및 다조건 검색 처리된 목록 조회 (PageMaker 세팅 포함)
    public List<DangerLogVO> getDangerLogList(PageMaker pageMaker);
    
    // 3. 단건 상세 조회
    public DangerLogVO getDangerLogById(int danlogId);
    
    // 4. 현장 조치 상태 및 내용 업데이트
    public void modifyDactionStatus(DangerLogVO dlv);
}
