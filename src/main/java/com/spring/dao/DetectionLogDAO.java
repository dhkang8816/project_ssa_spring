package com.spring.dao;

import java.util.List;
import java.util.Map;

import com.spring.cmd.PageMaker;
import com.spring.dto.DetectionLogVO;

public interface DetectionLogDAO {

    // 1. 등록 (dlv 수칙 반영)
    public int insertDetectionLog(DetectionLogVO dlv);
    
    // 2. 다조건 페이징 목록 조회
    public List<DetectionLogVO> selectDetectionLogList(PageMaker pageMaker);
    
    // 3. 전체 행 카운트
    public int selectDetectionLogCount(PageMaker pageMaker);
    
    // 4. 단건 상세 조회
    public DetectionLogVO selectDetectionLogById(int dlogId);
    
    // 5. 조치 상태 수정
    public int updateActionStatus(DetectionLogVO dlv);
    
    // 6. 조치율 계산
    public Map<String, Object> selectTodayDetectionStats() throws Exception;
}
