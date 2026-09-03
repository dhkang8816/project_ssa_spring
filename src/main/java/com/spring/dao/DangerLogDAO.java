package com.spring.dao;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.DangerLogVO;

public interface DangerLogDAO {

    // 1. 등록 (dlv 수칙 반영)
    public int insertDangerLog(DangerLogVO dlv);
    
    // 2. 다조건 페이징 목록 조회
    public List<DangerLogVO> selectDangerLogList(PageMaker pageMaker);
    
    // 3. 전체 행 카운트
    public int selectDangerLogCount(PageMaker pageMaker);
    
    // 4. 단건 상세 조회
    public DangerLogVO selectDangerLogById(int danlogId);
    
    // 5. 조치 상태 수정
    public int updateDactionStatus(DangerLogVO dlv);
}
